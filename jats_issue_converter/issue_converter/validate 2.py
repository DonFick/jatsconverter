"""XML validation utilities.

Supports validating incoming XML either:
- against a local XSD schema (recommended; works even when XML omits DOCTYPE), or
- against a declared DTD (legacy mode; requires DOCTYPE).

For this project, SCJATS XSD validation is the default.
"""

from __future__ import annotations

from functools import lru_cache
from pathlib import Path
from typing import Iterable, List

from lxml import etree

from .config import ValidationConfig


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


@lru_cache(maxsize=8)
def _load_schema(xsd_path: str) -> etree.XMLSchema:
    """Load and cache the XSD schema from disk."""
    schema_doc = etree.parse(xsd_path)
    return etree.XMLSchema(schema_doc)


def validate_xml_files(xml_files: Iterable[Path], validation: ValidationConfig) -> List[str]:
    """Validate each XML file; return list of error strings (empty => success)."""
    errors: List[str] = []
    if validation.mode == "xsd":
        assert validation.xsd_path is not None
        schema = _load_schema(str(validation.xsd_path))

        # Do not load DTDs; keep network disabled.
        parser = etree.XMLParser(load_dtd=False, resolve_entities=False, no_network=True, huge_tree=True)

        for xf in xml_files:
            try:
                doc = etree.parse(str(xf), parser)
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
