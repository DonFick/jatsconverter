"""Administrator utilities.

This service publishes static HTML for each issue under:

  <publish_root>/<journal-id>/<volume-token>/<volume-token><issue-token>/

To remove an issue cleanly without editing generated HTML pages, an administrator
deletes the published issue directory and regenerates the top-level index.

The CLI wires these helpers into a convenient command:

  python -m issue_converter --config /etc/issue-converter/config.toml remove-issue \
    --journal-id <jid> --volume <volume> --issue <issue>

"""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, List, Optional

from .manifest import load_all_manifests, render_index_html
from .util import pad3_if_int, sanitize_token, safe_rmtree


@dataclass(frozen=True)
class PublishedIssue:
    """A published issue discovered from manifest.json."""

    journal_id: str
    journal_title: str
    volume_raw: str
    issue_raw: str
    volume_id: str
    issue_id: str
    volume_token: str
    issue_token: str
    issue_dir_token: str
    issue_dir: Path


def _coerce_tokens(volume_value: str, issue_value: str) -> tuple[str, str, str, str, str]:
    """Return normalized (volume_id, issue_id, volume_token, issue_token, issue_dir_token)."""
    volume_id = pad3_if_int(volume_value)
    issue_id = pad3_if_int(issue_value)
    volume_tok = sanitize_token(volume_id)
    issue_tok = sanitize_token(issue_id)
    issue_dir_token = f"{volume_tok}{issue_tok}"
    return volume_id, issue_id, volume_tok, issue_tok, issue_dir_token


def list_published_issues(publish_root: Path) -> List[PublishedIssue]:
    """Enumerate published issues by scanning manifest.json files."""
    issues: List[PublishedIssue] = []
    for m in load_all_manifests(publish_root):
        try:
            jid = str(m.get("journal_id", ""))
            jtitle = str(m.get("journal_title", jid))
            volume_raw = str(m.get("volume_raw", ""))
            issue_raw = str(m.get("issue_raw", ""))
            volume_id = str(m.get("volume_id", ""))
            issue_id = str(m.get("issue_id", ""))
            volume_tok = sanitize_token(volume_id)
            issue_tok = sanitize_token(issue_id)
            issue_dir_token = str(m.get("issue_dir_token", f"{volume_tok}{issue_tok}"))

            mp = Path(m.get("_manifest_path", ""))
            issue_dir = mp.parent
            if not issue_dir.exists():
                continue

            issues.append(
                PublishedIssue(
                    journal_id=jid,
                    journal_title=jtitle,
                    volume_raw=volume_raw,
                    issue_raw=issue_raw,
                    volume_id=volume_id,
                    issue_id=issue_id,
                    volume_token=volume_tok,
                    issue_token=issue_tok,
                    issue_dir_token=issue_dir_token,
                    issue_dir=issue_dir,
                )
            )
        except Exception:
            continue
    return issues


def find_issue(
    publish_root: Path,
    journal_id: str,
    volume_value: str,
    issue_value: str,
) -> Optional[PublishedIssue]:
    """Find a published issue.

    Matching strategy (deterministic and forgiving):
    - journal_id must match exactly
    - volume_value and issue_value are matched against BOTH:
      - the raw values (volume_raw/issue_raw)
      - the normalized IDs (volume_id/issue_id)
      - and the derived tokens (volume_token/issue_token)

    This lets admins use the natural on-screen values (e.g., "SP28" and "1")
    or the padded values (e.g., "001").
    """
    target_volume_id, target_issue_id, target_volume_tok, target_issue_tok, _ = _coerce_tokens(volume_value, issue_value)
    v_candidates = {volume_value, target_volume_id, target_volume_tok}
    i_candidates = {issue_value, target_issue_id, target_issue_tok}

    for it in list_published_issues(publish_root):
        if it.journal_id != journal_id:
            continue
        if it.volume_raw in v_candidates or it.volume_id in v_candidates or it.volume_token in v_candidates:
            if it.issue_raw in i_candidates or it.issue_id in i_candidates or it.issue_token in i_candidates:
                return it
    return None


def remove_issue(
    publish_root: Path,
    journal_id: str,
    volume_value: str,
    issue_value: str,
    index_filename: str = "index.html",
) -> Path:
    """Remove a published issue directory and regenerate the top-level index.

    Returns the path to the regenerated index.
    Raises ValueError if the issue cannot be found.
    """
    it = find_issue(publish_root, journal_id, volume_value, issue_value)
    if not it:
        raise ValueError(
            "Issue not found. Use 'list-issues' to see available issues and confirm journal-id/volume/issue."
        )

    # Delete the published issue directory.
    safe_rmtree(it.issue_dir)

    # Clean up empty parent directories (volume dir and journal dir) for tidiness.
    try:
        vol_dir = publish_root / it.journal_id / it.volume_token
        if vol_dir.exists() and not any(vol_dir.iterdir()):
            vol_dir.rmdir()
        jour_dir = publish_root / it.journal_id
        if jour_dir.exists() and not any(jour_dir.iterdir()):
            jour_dir.rmdir()
    except Exception:
        # Best-effort cleanup only.
        pass

    # Regenerate the index page so the removed issue disappears from the browseable list.
    return render_index_html(publish_root, index_filename=index_filename)
