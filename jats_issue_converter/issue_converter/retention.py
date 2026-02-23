"""Retention cleanup utilities."""

from __future__ import annotations

import time
from pathlib import Path
from typing import Iterable


def prune_older_than(root: Path, days: int) -> int:
    """Delete files/directories under root older than days. Returns count deleted."""
    if not root.exists():
        return 0
    cutoff = time.time() - days * 86400
    deleted = 0
    for p in sorted(root.iterdir()):
        try:
            st = p.stat()
            if st.st_mtime < cutoff:
                if p.is_dir():
                    # best-effort recursive delete
                    import shutil
                    shutil.rmtree(p, ignore_errors=True)
                else:
                    p.unlink(missing_ok=True)  # py3.8+ supports missing_ok
                deleted += 1
        except Exception:
            continue
    return deleted
