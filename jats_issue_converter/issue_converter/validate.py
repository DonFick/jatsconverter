"""XML validation utilities.

Supports validating incoming XML either:
- against a local XSD schema (recommended; works even when XML omits DOCTYPE), or
- against a declared DTD (legacy mode; requires DOCTYPE).

For this project, SCJATS XSD validation is the default.
"""

from __future__ import annotations

import re
from functools import lru_cache
from pathlib import Path
from typing import Iterable, List, Optional, Tuple

from lxml import etree

from .config import ValidationConfig


XSI_NS = "http://www.w3.org/2001/XMLSchema-instance"
SCJATS_VERSION_RE = re.compile(r"/1/(\d+)/")     # matches .../1/47/... etc


class LocalDtdResolver(etree.Resolver):
    """Resolve external entities/DTDs from a local directory tree.

    The resolver maps the last path segment of the requested system_url into the dtd_root tree.
    This is a pragmatic approach that works well when you mirror DTD resources under dtd_root.

    If your DTD references are more complex, extend this resolver to implement catalog logic.
    """

    def __init__(self, dtd_root: Path):
        super().__init__()
        self.dtd_root = dtd_root

    def resolve(self, system_url, public_id, context):  # type: ignore[override]
        if not system_url:
            return None
        # Use only the filename portion
        name = str(system_url).split("/")[-1]
        candidate = self.dtd_root / name
        if candidate.exists():
            return self.resolve_filename(str(candidate), context)
        # Fallback: attempt to find by walking (bounded) - this can be expensive for huge trees
        for p in self.dtd_root.rglob(name):
            return self.resolve_filename(str(p), context)
        return None


@lru_cache(maxsize=32)
def _load_schema(xsd_path: str) -> etree.XMLSchema:
    """Load and cache the XSD schema from disk."""
    schema_doc = etree.parse(xsd_path)
    return etree.XMLSchema(schema_doc)


def _schema_location_pairs(root: etree._Element) -> List[Tuple[str, str]]:
    """Return (namespaceURI, schemaURL) pairs from xsi:schemaLocation if present."""
    val = root.attrib.get(f"{{{XSI_NS}}}schemaLocation")
    if not val:
        return []
    toks = val.split()
    if len(toks) < 2:
        return []
    pairs: List[Tuple[str, str]] = []
    for i in range(0, len(toks) - 1, 2):
        pairs.append((toks[i], toks[i + 1]))
    return pairs


def _extract_version_from_uri(uri: str) -> Optional[str]:
    """Extract '47' from a URI containing '/1/47/'."""
    m = SCJATS_VERSION_RE.search(uri)
    return m.group(1) if m else None


def _root_namespace_uri(root: etree._Element) -> Optional[str]:
    """Get the Clark-notation namespace URI from the root element."""
    tag = root.tag
    if isinstance(tag, str) and tag.startswith("{"):
        return tag.split("}", 1)[0][1:]
    return root.nsmap.get(None)


def _detect_version_from_xml(root: etree._Element, xsd_filename: str) -> Optional[str]:
    """
    Detect SCJATS version using:
      1) schemaLocation (preferred), matching the configured xsd_filename
      2) root namespace URI (fallback)
    Returns version string like '47' or None.
    """
    # 1) schemaLocation
    for ns_uri, schema_url in _schema_location_pairs(root):
        # Match the schema URL that references the SCJATS entrypoint we care about.
        if schema_url.endswith(xsd_filename) or xsd_filename in schema_url:
            return _extract_version_from_uri(schema_url) or _extract_version_from_uri(ns_uri)

    # 2) root namespace fallback
    root_ns = _root_namespace_uri(root)
    if root_ns:
        return _extract_version_from_uri(root_ns)

    return None


def _find_local_xsd(xsd_root: Path, xsd_filename: str, version: Optional[str]) -> Optional[Path]:
    """
    Locate the appropriate local XSD under xsd_root.

    - If version is known (e.g., '47'), prefer a candidate whose path contains '1_47'.
    - If version is unknown, accept only if a single unambiguous candidate exists.
    """
    if not xsd_root.exists():
        return None

    candidates = sorted(xsd_root.rglob(xsd_filename))
    if not candidates:
        return None

    if version:
        token = f"1_{version}"
        preferred = [p for p in candidates if any(token in part for part in p.parts)]
        if preferred:
            return preferred[0]
        # If we have a version but can't match it, don't guess.
        return None

    # No version: only accept if unambiguous
    if len(candidates) == 1:
        return candidates[0]
    return None


def validate_xml_files(xml_files: Iterable[Path], validation: ValidationConfig) -> List[str]:
    """Validate each XML file; return list of error strings (empty => success)."""
    errors: List[str] = []

    if validation.mode == "xsd":
        # New config: xsd_root + optional xsd_filename
        xsd_root: Optional[Path] = getattr(validation, "xsd_root", None)
        xsd_filename: str = getattr(validation, "xsd_filename", "SCJATS-journalpublishing.xsd")

        # Backward-compatible config: single fixed xsd_path
        fixed_xsd_path: Optional[Path] = getattr(validation, "xsd_path", None)

        # Parse XML without DTD; keep network disabled.
        parser = etree.XMLParser(load_dtd=False, resolve_entities=False, no_network=True, huge_tree=True)

        print("xsd_root: ", xsd_root, flush=True)
        print("xsd_filename: ", xsd_filename, flush=True)
        print("fixed_xsd_path: ", fixed_xsd_path, flush=True)

        for xf in xml_files:
            try:
                doc = etree.parse(str(xf), parser)
                root = doc.getroot()
                schema_loc = root.attrib.get(
                    "{http://www.w3.org/2001/XMLSchema-instance}schemaLocation"
                )
                parts = schema_loc.split()
                pairs = [(parts[i], parts[i + 1]) for i in range(0, len(parts), 2)]

                for namespace, schema in pairs:
                    print("namespace: ", namespace, flush=True)
                    print("schema: ", schema, flush=True)

                # Determine which schema to use for THIS file
                xsd_path: Optional[Path] = None

                if xsd_root is not None:
                    version = _detect_version_from_xml(root, xsd_filename)
                    xsd_path = _find_local_xsd(xsd_root, xsd_filename, version)
                    print("version: ", version, flush=True)
                    print("xsd_path: ", xsd_path, flush=True)

                    if xsd_path is None:
                        if version:
                            errors.append(
                                f"{xf.name}: No matching local XSD found for SCJATS version 1/{version} "
                                f"under {xsd_root} (looking for {xsd_filename})."
                            )
                        else:
                            errors.append(
                                f"{xf.name}: Could not detect SCJATS schema version and local XSD is ambiguous "
                                f"under {xsd_root} (looking for {xsd_filename})."
                            )

                # If detection failed, fall back to fixed schema if provided
                if xsd_path is None and fixed_xsd_path is not None:
                    xsd_path = fixed_xsd_path

                if xsd_path is None:
                    # No schema available -> report (caller treats as warning if desired)
                    errors.append(f"{xf.name}: No XSD available (set validation.xsd_root or validation.xsd_path).")
                    continue

                schema = _load_schema(str(xsd_path))
                ok = schema.validate(doc)
                if not ok:
                    for e in schema.error_log:
                        errors.append(f"{xf.name}: {e.message} (line {e.line})")

            except Exception as e:
                errors.append(f"{xf.name}: XML parse/schema error: {e}")

        return errors

    if validation.mode == "dtd":
        assert validation.dtd_root is not None
        parser = etree.XMLParser(load_dtd=True, resolve_entities=True, no_network=True, dtd_validation=False)
        parser.resolvers.add(LocalDtdResolver(validation.dtd_root))

        for xf in xml_files:
            try:
                doc = etree.parse(str(xf), parser)
                dtd = doc.docinfo.internalDTD
                if dtd is None:
                    errors.append(f"{xf.name}: No DOCTYPE/DTD declaration found; cannot validate")
                    continue
                ok = dtd.validate(doc)
                if not ok:
                    for e in dtd.error_log:
                        errors.append(f"{xf.name}: {e.message} (line {e.line})")
            except Exception as e:
                errors.append(f"{xf.name}: XML parse/DTD error: {e}")
        return errors

    errors.append(f"Unknown validation.mode: {validation.mode}")
    return errors