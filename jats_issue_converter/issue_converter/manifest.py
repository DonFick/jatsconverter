"""Manifest writing and index generation."""

from __future__ import annotations

import json
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Optional

from .jats import IssueIdentity


@dataclass(frozen=True)
class IssueManifest:
    journal_title: str
    journal_id: str
    volume_raw: str
    issue_raw: str
    volume_id: str
    issue_id: str
    issue_dir_token: str
    toc_relpath: str
    published_utc: str
    source_zip_filename: str
    source_zip_mtime_utc: str


def write_issue_manifest(issue_dir: Path, ident: IssueIdentity, toc_path: Path, zip_name: str, zip_mtime: float) -> Path:
    published = datetime.now(timezone.utc).isoformat()
    mtime = datetime.fromtimestamp(zip_mtime, tz=timezone.utc).isoformat()
    rel_toc = str(toc_path.relative_to(issue_dir.parent.parent.parent)) if False else str(toc_path.relative_to(issue_dir))

    # toc_relpath should be relative to /data/ root for linking from index.html
    # We'll compute that at index generation time by using known directory structure; here we store path relative to publish_root later.
    manifest = {
        "publisher_name": ident.publisher_name,
        "publisher_id": ident.publisher_id,
        "journal_title": ident.journal_title,
        "journal_id": ident.journal_id,
        "volume_raw": ident.volume_raw,
        "issue_raw": ident.issue_raw,
        "volume_id": ident.volume_id,
        "issue_id": ident.issue_id,
        "issue_dir_token": ident.issue_dir_token,
        "toc_filename": toc_path.name,
        "published_utc": published,
        "source_zip_filename": zip_name,
        "source_zip_mtime_utc": mtime,
    }
    out = issue_dir / "manifest.json"
    out.write_text(json.dumps(manifest, indent=2, sort_keys=True), encoding="utf-8")
    return out


def load_all_manifests(publish_root: Path) -> List[dict]:
    manifests: List[dict] = []
    for mf in publish_root.rglob("manifest.json"):
        try:
            manifests.append(json.loads(mf.read_text(encoding="utf-8")))
            manifests[-1]["_manifest_path"] = str(mf)
        except Exception:
            continue
    return manifests


def render_index_html(publish_root: Path, index_filename: str = "index.html") -> Path:
    """Regenerate top-level /data/index.html grouped by publisher then journal.

    Grouping: journal-id ascending.
    Sorting within journal: volume desc (numeric when possible), issue desc (numeric when possible), published_utc desc.
    """
    manifests = load_all_manifests(publish_root)

    def _num_or_none(s: str):
        try:
            return int(s)
        except Exception:
            return None

    # Compute toc href relative to publish_root
    for m in manifests:
        mp = Path(m.get("_manifest_path", ""))
        issue_dir = mp.parent if mp else None
        if issue_dir and issue_dir.exists():
            # issue_dir relative to publish_root
            rel_issue_dir = issue_dir.relative_to(publish_root)
            m["toc_href"] = "/data/" + str(rel_issue_dir / m.get("toc_filename", "toc.html"))
        else:
            m["toc_href"] = ""

    # Group by publisher_id then journal_id
    grouped_by_publisher: Dict[str, Dict[str, List[dict]]] = {}
    for m in manifests:
        pid = m.get("publisher_id", "unknown")
        jid = m.get("journal_id", "unknown")
        grouped_by_publisher.setdefault(pid, {}).setdefault(jid, []).append(m)

    # Sort publishers
    publisher_ids = sorted(grouped_by_publisher.keys())

    # Sort entries within each journal (inside each publisher)
    for pid, journals in grouped_by_publisher.items():
        for jid, items in journals.items():
            items.sort(
                key=lambda m: (
                    _num_or_none(m.get("volume_raw", "")) or -1,
                    _num_or_none(m.get("issue_raw", "")) or -1,
                    m.get("published_utc", "")
                ),
                reverse=True
            )

    # Render
    parts: List[str] = []
    parts.append("<!doctype html><html><head><meta charset='utf-8'><title>All issues</title></head><body>")
    parts.append("<h1>All issues</h1><p>Grouped by publisher, then journal.</p>")
    for pid in publisher_ids:
        journals = grouped_by_publisher[pid]
        # Publisher display name (take first found)
        _any = next(iter(next(iter(journals.values()))), {}) if journals else {}
        ptitle = _any.get("publisher_name", pid)
        parts.append(f"<h2>{ptitle}</h2>")
        for jid in sorted(journals.keys()):
            items = journals[jid]
            if not items:
                continue
            title = items[0].get("journal_title", jid)
            parts.append(f"<h3>{title}</h3>")
            parts.append("<ul>")
            for m in items:
                vol = m.get("volume_raw", "")
                iss = m.get("issue_raw", "")
                pub = m.get("published_utc", "")
                href = m.get("toc_href", "")
                parts.append(f"<li><a href='{href}'>Vol {vol}, Issue {iss}</a> — published {pub}</li>")
            parts.append("</ul>")
    parts.append("</body></html>")
    out = publish_root / index_filename
    out.write_text("\n".join(parts), encoding="utf-8")
    return out
