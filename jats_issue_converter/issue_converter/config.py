"""Configuration loading and validation.

We use TOML for a human-editable config file with sensible defaults.

This project originally validated with DTDs. It now supports validating with XSD
(typically SCJATS-journalpublishing.xsd) while retaining backwards compatibility
with the older [dtd] section.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Any

try:
    import tomllib  # py3.11+
except ModuleNotFoundError:  # pragma: no cover
    import tomli as tomllib  # type: ignore


@dataclass(frozen=True)
class PathsConfig:
    watch_dir: Path
    processing_dir: Path
    staging_dir: Path
    archive_dir: Path
    failed_dir: Path
    log_dir: Path
    publish_root: Path


@dataclass(frozen=True)
class XsltConfig:
    stylesheet_path: Path
    include_dir: Optional[Path] = None

@dataclass(frozen=True)
class ValidationConfig:
    """Validation configuration.

    mode:
      - "xsd": validate XML using a local XSD schema file (auto-selected per XML if xsd_root is set).
      - "dtd": validate XML using declared DOCTYPE + local resolver (legacy).

    For "xsd":
      - Prefer xsd_root (+ optional xsd_filename) to auto-detect per XML.
      - Fall back to xsd_path if provided (legacy behavior).

    For "dtd": dtd_root is required.
    """
    mode: str = "xsd"

    # New: schema discovery/selection
    xsd_root: Optional[Path] = None
    xsd_filename: str = "SCJATS-journalpublishing.xsd"

    # Legacy: fixed schema path
    xsd_path: Optional[Path] = None

    # Legacy DTD support
    dtd_root: Optional[Path] = None

    # Control behavior (you currently want warn-only => False)
    fail_on_error: bool = False


@dataclass(frozen=True)
class ProcessingConfig:
    stability_seconds: int = 90
    rescan_seconds: int = 15
    retention_days: int = 365


@dataclass(frozen=True)
class IndexConfig:
    index_filename: str = "index.html"


@dataclass(frozen=True)
class EmailConfig:
    provider: str
    from_address: str
    to_addresses: List[str]
    aws_region: str = "us-east-1"
    smtp_host: str = "localhost"
    smtp_port: int = 25


@dataclass(frozen=True)
class AppConfig:
    paths: PathsConfig
    xslt: XsltConfig
    validation: ValidationConfig = field(default_factory=ValidationConfig)
    processing: ProcessingConfig = field(default_factory=ProcessingConfig)
    index: IndexConfig = field(default_factory=IndexConfig)
    email: EmailConfig = field(default_factory=lambda: EmailConfig(provider="ses", from_address="", to_addresses=[]))
    journal_id_overrides: Dict[str, str] = field(default_factory=dict)


def _require(d: dict, key: str) -> Any:
    if key not in d:
        raise ValueError(f"Missing required config key: {key}")
    return d[key]


def load_config(path: str | Path) -> AppConfig:
    cfg_path = Path(path)
    raw = tomllib.loads(cfg_path.read_text(encoding="utf-8"))

    paths = raw.get("paths", {})
    xslt = raw.get("xslt", {})
    processing = raw.get("processing", {})
    index = raw.get("index", {})
    email = raw.get("email", {})
    overrides = raw.get("journal_id_overrides", {})

    # Preferred: [validation]
    validation = raw.get("validation", {})

    # Back-compat: [dtd]
    dtd = raw.get("dtd", {})

    paths_cfg = PathsConfig(
        watch_dir=Path(_require(paths, "watch_dir")),
        processing_dir=Path(_require(paths, "processing_dir")),
        staging_dir=Path(_require(paths, "staging_dir")),
        archive_dir=Path(_require(paths, "archive_dir")),
        failed_dir=Path(_require(paths, "failed_dir")),
        log_dir=Path(_require(paths, "log_dir")),
        publish_root=Path(_require(paths, "publish_root")),
    )

    xslt_cfg = XsltConfig(
        stylesheet_path=Path(_require(xslt, "stylesheet_path")),
        include_dir=Path(xslt["include_dir"]) if "include_dir" in xslt else None,
    )

    if validation:
        mode = str(validation.get("mode", "xsd")).lower().strip()
        xsd_path = Path(validation["xsd_path"]) if "xsd_path" in validation else None
        
        dtd_root = Path(validation["dtd_root"]) if "dtd_root" in validation else None
        val_cfg = ValidationConfig(mode=mode, xsd_path=xsd_path, dtd_root=dtd_root)
        fail_on_error = validation.get("fail_on_error", False)
    elif dtd:
        val_cfg = ValidationConfig(mode="dtd", dtd_root=Path(_require(dtd, "dtd_root")))
    else:
        val_cfg = ValidationConfig(mode="xsd", xsd_path=None)

    proc_cfg = ProcessingConfig(
        stability_seconds=int(processing.get("stability_seconds", 90)),
        rescan_seconds=int(processing.get("rescan_seconds", 15)),
        retention_days=int(processing.get("retention_days", 365)),
    )

    idx_cfg = IndexConfig(index_filename=str(index.get("index_filename", "index.html")))

    email_cfg = EmailConfig(
        provider=str(email.get("provider", "ses")),
        from_address=str(_require(email, "from_address")),
        to_addresses=list(_require(email, "to_addresses")),
        aws_region=str(email.get("aws_region", "us-east-1")),
        smtp_host=str(email.get("smtp_host", "localhost")),
        smtp_port=int(email.get("smtp_port", "25")),
    )

    if val_cfg.mode not in ("xsd", "dtd"):
        raise ValueError(f"validation.mode must be 'xsd' or 'dtd' (got {val_cfg.mode!r})")
    if val_cfg.mode == "xsd" and not val_cfg.xsd_path:
        raise ValueError("validation.xsd_path is required when validation.mode='xsd'")
    if val_cfg.mode == "dtd" and not val_cfg.dtd_root:
        raise ValueError("validation.dtd_root is required when validation.mode='dtd'")

    return AppConfig(
        paths=paths_cfg,
        xslt=xslt_cfg,
        validation=val_cfg,
        processing=proc_cfg,
        index=idx_cfg,
        email=email_cfg,
        journal_id_overrides={str(k): str(v) for k, v in overrides.items()},
    )
