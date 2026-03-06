"""Core job processing worker."""

from __future__ import annotations

import json
import shutil
import traceback
import zipfile
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional, Tuple, List

from lxml import etree

from .config import AppConfig
# from .emailer import EmailMessage, SesMailer
from .emailer import EmailMessage, SmtpMailer
from .jats import extract_publisher_name, extract_journal_title, extract_volume_issue, load_xml_first, IssueIdentity
from .manifest import write_issue_manifest, render_index_html
from .transformer import copy_optional_dirs, run_xslt_on_issue, ensure_toc
from .util import (
    slugify, pad3_if_int, sanitize_token, ensure_dirs,
    atomic_replace_dir, safe_rmtree, zip_slip_safe_members
)
from .validate import validate_xml_files


STAGES = [
    "claim",
    "unzip",
    "discover_xml",
    "validate",
    "extract_identity",
    "xslt_transform",
    "publish",
    "index",
    "archive",
]


@dataclass
class JobContext:
    zip_path: Path
    zip_name: str
    zip_mtime: float
    stage: str = ""
    publisher_name: Optional[str] = None
    publisher_id: Optional[str] = None
    journal_title: Optional[str] = None
    journal_id: Optional[str] = None
    volume_raw: Optional[str] = None
    issue_raw: Optional[str] = None
    publish_dir: Optional[Path] = None
    log_path: Optional[Path] = None


def _choose_effective_root(unpacked_root: Path) -> Path:
    """If unpacked_root contains a single wrapper directory, return it; otherwise unpacked_root."""
    entries = [p for p in unpacked_root.iterdir() if not p.name.startswith("__MACOSX")]
    dirs = [p for p in entries if p.is_dir()]
    files = [p for p in entries if p.is_file()]
    if len(dirs) == 1 and len(files) == 0:
        return dirs[0]
    return unpacked_root


def _write_log(log_path: Path, text: str) -> None:
    log_path.parent.mkdir(parents=True, exist_ok=True)
    log_path.write_text(text, encoding="utf-8")


def process_zip(cfg: AppConfig, zip_in_processing: Path) -> None:
    """Process a claimed ZIP file located in processing_dir."""
    print("processing file", flush=True)
    ctx = JobContext(
        zip_path=zip_in_processing,
        zip_name=zip_in_processing.name,
        zip_mtime=zip_in_processing.stat().st_mtime,
    )

    # Mailer (SES)
    # mailer = SesMailer(cfg.email.aws_region, cfg.email.from_address, cfg.email.to_addresses)
    # Mailer (SMTP)
    mailer = SmtpMailer(from_address=cfg.email.from_address, to_addresses=cfg.email.to_addresses, host=cfg.email.smtp_host, port=cfg.email.smtp_port)

    # Create a per-job log path
    ts = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    ctx.log_path = cfg.paths.log_dir / f"{ts}__{ctx.zip_name}.log"

    staging_job_root = cfg.paths.staging_dir / f"{ts}__{ctx.zip_name}"
    safe_rmtree(staging_job_root)
    ensure_dirs(staging_job_root)

    try:
        # --- unzip
        ctx.stage = "unzip"
        with zipfile.ZipFile(str(ctx.zip_path), "r") as zf:
            members = zip_slip_safe_members(zf.namelist())
            zf.extractall(path=str(staging_job_root), members=members)

        # wrapper ignore
        print( _choose_effective_root(staging_job_root))
        effective_root = _choose_effective_root(staging_job_root)

        # --- discover xml
        ctx.stage = "discover_xml"
        xml_dir = effective_root / "xml"
        if not xml_dir.exists():
            raise ValueError("Missing required xml/ directory (XML is required to publish)")
        xml_files = sorted([p for p in xml_dir.glob("*.xml") if p.is_file()])
        if not xml_files:
            raise ValueError("No XML files found in xml/ directory")

        # --- dtd validate
        ctx.stage = "validate"
        errors = validate_xml_files(xml_files, cfg.validation)
        # modify here to be permissive instead of erroring out
        if errors:
            raise ValueError("XML validation failed:\n" + "\n".join(errors))

        # --- extract identity
        ctx.stage = "extract_identity"
        # Use first XML (alphabetical) for identity.
        doc = load_xml_first(xml_dir)
        publisher_name = extract_publisher_name(doc)
        publisher_id = slugify(publisher_name)

        journal_title = extract_journal_title(doc)
        volume_raw, issue_raw = extract_volume_issue(doc)

        # journal-id mapping/slugify
        normalized_title = journal_title.strip()
        journal_id = cfg.journal_id_overrides.get(normalized_title) or slugify(journal_title)

        volume_id = pad3_if_int(volume_raw)
        issue_id = pad3_if_int(issue_raw)

        # sanitize tokens for path components
        volume_tok = sanitize_token(volume_id)
        issue_tok = sanitize_token(issue_id)
        issue_dir_token = f"{volume_tok}{issue_tok}"

        ctx.publisher_name = publisher_name
        ctx.publisher_id = publisher_id
        ctx.journal_title = journal_title
        ctx.journal_id = journal_id
        ctx.volume_raw = volume_raw
        ctx.issue_raw = issue_raw

        publish_issue_dir = cfg.paths.publish_root / publisher_id / journal_id / volume_tok / issue_dir_token
        ctx.publish_dir = publish_issue_dir

        # --- xslt transform into build directory
        ctx.stage = "xslt_transform"
        build_dir = publish_issue_dir.with_name(publish_issue_dir.name + ".build_" + ts)
        safe_rmtree(build_dir)
        build_dir.mkdir(parents=True, exist_ok=True)

        # Copy optional dirs (kept separate)
        copy_optional_dirs(effective_root, build_dir)

        # Run XSLT on each XML to generate HTML
        generated_html = run_xslt_on_issue(xml_dir=xml_dir, output_root=build_dir, stylesheet_path=cfg.xslt.stylesheet_path)

        # Ensure toc exists
        toc_path = ensure_toc(build_dir, generated_html)

        # --- publish (atomic swap)
        ctx.stage = "publish"
        build_parent = build_dir.parent
        build_parent.mkdir(parents=True, exist_ok=True)
        # Ensure parent dirs exist
        publish_issue_dir.parent.mkdir(parents=True, exist_ok=True)
        atomic_replace_dir(build_dir, publish_issue_dir)

        # Write manifest in published dir
        ident = IssueIdentity(
            publisher_name=publisher_name,
            publisher_id=publisher_id,
            journal_title=journal_title,
            journal_id=journal_id,
            volume_raw=volume_raw,
            issue_raw=issue_raw,
            volume_id=volume_id,
            issue_id=issue_id,
            issue_dir_token=issue_dir_token,
        )
        write_issue_manifest(publish_issue_dir, ident, publish_issue_dir / toc_path.name, ctx.zip_name, ctx.zip_mtime)

        # --- index regenerate
        ctx.stage = "index"
        render_index_html(cfg.paths.publish_root, cfg.index.index_filename)

        # --- archive ZIP
        ctx.stage = "archive"
        ensure_dirs(cfg.paths.archive_dir)
        dest = cfg.paths.archive_dir / ctx.zip_name
        # If name collision in archive, append timestamp
        if dest.exists():
            dest = cfg.paths.archive_dir / f"{ts}__{ctx.zip_name}"
        shutil.move(str(ctx.zip_path), str(dest))

        # Log success
        _write_log(ctx.log_path, f"SUCCESS\nzip={ctx.zip_name}\npublished={publish_issue_dir}\n")

    except Exception as e:
        # Failure handling: move zip to failed_dir, send email, write logs
        try:
            ensure_dirs(cfg.paths.failed_dir)
            fail_dest = cfg.paths.failed_dir / ctx.zip_name
            if fail_dest.exists():
                fail_dest = cfg.paths.failed_dir / f"{ts}__{ctx.zip_name}"
            if ctx.zip_path.exists():
                shutil.move(str(ctx.zip_path), str(fail_dest))
        except Exception:
            # If even moving fails, continue to email/log.
            pass

        tb = traceback.format_exc()
        details = [
            f"FAILURE",
            f"zip={ctx.zip_name}",
            f"stage={ctx.stage}",
        ]
        if ctx.journal_title:
            details.append(f"journal_title={ctx.journal_title}")
        if ctx.journal_id:
            details.append(f"journal_id={ctx.journal_id}")
        if ctx.volume_raw:
            details.append(f"volume={ctx.volume_raw}")
        if ctx.issue_raw:
            details.append(f"issue={ctx.issue_raw}")
        if ctx.publish_dir:
            details.append(f"publish_dir={ctx.publish_dir}")
        if ctx.log_path:
            details.append(f"log_path={ctx.log_path}")
        details.append("\nException:\n" + str(e))
        details.append("\nTraceback:\n" + tb)
        log_text = "\n".join(details)

        if ctx.log_path:
            _write_log(ctx.log_path, log_text)

        # Send SES email
#         try:
#             subject = f"Issue converter FAILED: {ctx.zip_name} (stage={ctx.stage})"
#             mailer.send(EmailMessage(subject=subject, body_text=log_text))
#         except Exception:
#             # If SES fails, we still keep the local log
#             pass

        # Send SMTP email
        try:
            subject = f"Issue converter NOTICE: {ctx.zip_name} (stage={ctx.stage})"
            mailer.send(EmailMessage(subject=subject, body_text=log_text))
        except Exception:
            # If SES fails, we still keep the local log
            pass

        # Cleanup staging (kept for debugging? remove or keep; we keep and prune via retention)
        # safe_rmtree(staging_job_root)
        return
