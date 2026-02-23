"""Watchdog-based daemon.

- Watches cfg.paths.watch_dir for ZIP changes.
- Uses a periodic rescan as safety net.
- Determines eligibility by size stability and processes eligible ZIPs by mtime oldest-first.
- Runs serially (one ZIP at a time).
"""

from __future__ import annotations

import argparse
import threading
import time
from pathlib import Path
from typing import Optional, List

from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

from .config import load_config, AppConfig
from .util import ensure_dirs, is_size_stable
from .worker import process_zip
from .retention import prune_older_than
from .manifest import render_index_html
from .admin import list_published_issues, remove_issue


class _EventFlagHandler(FileSystemEventHandler):
    def __init__(self, dirty_flag: threading.Event):
        super().__init__()
        self.dirty_flag = dirty_flag

    def on_any_event(self, event):
        # Any event indicates directory may have changed
        self.dirty_flag.set()


def _list_zip_candidates(cfg: AppConfig) -> List[Path]:
    zips = [p for p in cfg.paths.watch_dir.glob("*.zip") if p.is_file()]
    # Oldest mtime first
    zips.sort(key=lambda p: (p.stat().st_mtime, p.name))
    return zips


def _claim_zip(cfg: AppConfig, zip_path: Path) -> Path:
    """Atomically move a ZIP from watch_dir to processing_dir."""
    ensure_dirs(cfg.paths.processing_dir)
    dest = cfg.paths.processing_dir / zip_path.name
    if dest.exists():
        # name collision; append timestamp
        ts = int(time.time())
        dest = cfg.paths.processing_dir / f"{ts}__{zip_path.name}"
    zip_path.rename(dest)
    return dest


def _run_retention(cfg: AppConfig) -> None:
    days = cfg.processing.retention_days
    prune_older_than(cfg.paths.archive_dir, days)
    prune_older_than(cfg.paths.failed_dir, days)
    prune_older_than(cfg.paths.log_dir, days)
    prune_older_than(cfg.paths.staging_dir, days)


def run_daemon(cfg: AppConfig) -> None:
    ensure_dirs(
        cfg.paths.watch_dir,
        cfg.paths.processing_dir,
        cfg.paths.staging_dir,
        cfg.paths.archive_dir,
        cfg.paths.failed_dir,
        cfg.paths.log_dir,
        cfg.paths.publish_root,
    )

    dirty = threading.Event()
    handler = _EventFlagHandler(dirty)
    observer = Observer()
    observer.schedule(handler, str(cfg.paths.watch_dir), recursive=False)
    observer.start()

    last_retention = 0.0

    try:
        # initial scan
        dirty.set()
        while True:
            # periodic retention once per 24h
            if time.time() - last_retention > 86400:
                _run_retention(cfg)
                last_retention = time.time()

            # periodic safety rescan
            time.sleep(cfg.processing.rescan_seconds)
            dirty.set()

            if not dirty.is_set():
                continue
            dirty.clear()

            # Build eligible list
            for zip_path in _list_zip_candidates(cfg):
                # Must be stable
                if not is_size_stable(zip_path, cfg.processing.stability_seconds):
                    continue

                # Claim and process
                claimed = _claim_zip(cfg, zip_path)
                process_zip(cfg, claimed)
                # After each job, break to rebuild ordering (mtime may have changed due to new arrivals)
                break

    finally:
        observer.stop()
        observer.join()


def main() -> None:
    """Entry point.

    We keep the daemon as the default behavior, but also expose administrator
    subcommands so common operations (like removing an issue) do not require
    manual editing of generated HTML.
    """
    ap = argparse.ArgumentParser()
    ap.add_argument("--config", required=True, help="Path to config.toml")

    sub = ap.add_subparsers(dest="cmd")

    # Default: run the watchdog daemon
    sub.add_parser("run", help="Run watchdog daemon (default)")

    # Rebuild the top-level index without processing any ZIPs
    sub.add_parser("reindex", help="Regenerate /data/index.html from manifests")

    # List currently published issues (from manifests)
    sub.add_parser("list-issues", help="List published issues discovered under publish_root")

    rm = sub.add_parser("remove-issue", help="Remove a published issue and regenerate index")
    rm.add_argument("--journal-id", required=True, help="journal-id path segment")
    rm.add_argument("--volume", required=True, help="volume (raw or normalized)")
    rm.add_argument("--issue", required=True, help="issue (raw or normalized)")

    args = ap.parse_args()
    cfg = load_config(args.config)

    cmd = args.cmd or "run"
    if cmd == "run":
        run_daemon(cfg)
        return
    if cmd == "reindex":
        render_index_html(cfg.paths.publish_root, cfg.index.index_filename)
        return
    if cmd == "list-issues":
        issues = list_published_issues(cfg.paths.publish_root)
        # Human-readable output intended for administrators.
        for it in sorted(issues, key=lambda x: (x.journal_id, x.volume_token, x.issue_dir_token)):
            print(
                f"{it.journal_id}\tVol {it.volume_raw} (id={it.volume_id})\tIssue {it.issue_raw} (id={it.issue_id})\t{it.issue_dir}"
            )
        return
    if cmd == "remove-issue":
        remove_issue(
            cfg.paths.publish_root,
            journal_id=args.journal_id,
            volume_value=args.volume,
            issue_value=args.issue,
            index_filename=cfg.index.index_filename,
        )
        return

    ap.error(f"Unknown command: {cmd}")


if __name__ == "__main__":
    main()
