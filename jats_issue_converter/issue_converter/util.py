"""Small utilities used across the service."""

from __future__ import annotations

import os
import re
import shutil
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Optional


_slug_re = re.compile(r"[^a-z0-9]+")


def slugify(text: str) -> str:
    """Create a stable filesystem/url-safe slug."""
    s = text.strip().lower()
    s = _slug_re.sub("-", s)
    s = s.strip("-")
    return s or "unknown"


def pad3_if_int(value: str) -> str:
    v = value.strip()
    try:
        n = int(v)
        return str(n).zfill(3)
    except Exception:
        return v


def sanitize_token(value: str) -> str:
    """Sanitize for filesystem usage while preserving readability."""
    return slugify(value).replace("-", "") or "unknown"


def ensure_dirs(*paths: Path) -> None:
    for p in paths:
        p.mkdir(parents=True, exist_ok=True)


def atomic_replace_dir(build_dir: Path, live_dir: Path) -> None:
    """Atomically replace live_dir with build_dir using renames.

    Both directories must be on the same filesystem for atomic rename.
    """
    tmp_old = live_dir.with_name(live_dir.name + ".old")
    if tmp_old.exists():
        shutil.rmtree(tmp_old, ignore_errors=True)

    if live_dir.exists():
        live_dir.rename(tmp_old)

    build_dir.rename(live_dir)

    # Best-effort cleanup
    if tmp_old.exists():
        shutil.rmtree(tmp_old, ignore_errors=True)


def safe_rmtree(path: Path) -> None:
    if path.exists():
        shutil.rmtree(path, ignore_errors=True)


def safe_unlink(path: Path) -> None:
    try:
        path.unlink()
    except FileNotFoundError:
        pass


@dataclass
class StableFile:
    path: Path
    mtime: float
    size: int


def is_size_stable(path: Path, stability_seconds: int) -> bool:
    """Return True when file size is unchanged over stability_seconds."""
    if not path.exists():
        return False
    size1 = path.stat().st_size
    t_end = time.time() + stability_seconds
    # Sample periodically; choose a small internal interval to respond promptly.
    while time.time() < t_end:
        time.sleep(min(5.0, stability_seconds))
        if not path.exists():
            return False
        size2 = path.stat().st_size
        if size2 != size1:
            return False
    return True


def zip_slip_safe_members(members: Iterable[str]) -> list[str]:
    """Filter ZIP members to prevent path traversal."""
    safe: list[str] = []
    for name in members:
        # Reject absolute paths and path traversal
        if name.startswith("/") or name.startswith("\\"):
            continue
        norm = os.path.normpath(name)
        if norm.startswith("..") or ".." + os.sep in norm:
            continue
        safe.append(name)
    return safe
