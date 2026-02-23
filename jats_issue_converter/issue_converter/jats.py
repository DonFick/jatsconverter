"""JATS/SCJATS parsing helpers (namespace-tolerant).

We intentionally use local-name() XPath patterns to handle namespaced SCJATS.
"""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Optional

from lxml import etree


@dataclass(frozen=True)
class IssueIdentity:
    publisher_name: str
    publisher_id: str
    journal_title: str
    journal_id: str
    volume_raw: str
    issue_raw: str
    volume_id: str
    issue_id: str
    issue_dir_token: str  # <volume-id><issue-id>


def _xpath_first_text(doc: etree._ElementTree, xpath: str) -> Optional[str]:
    vals = doc.xpath(xpath)
    if not vals:
        return None
    # vals may contain strings or nodes
    v = vals[0]
    if isinstance(v, str):
        return v.strip()
    if hasattr(v, "text") and v.text:
        return v.text.strip()
    return None



def extract_publisher_name(doc: etree._ElementTree) -> str:
    # front/journal-meta/publisher/publisher-name (namespace tolerant via local-name()).
    name = _xpath_first_text(
        doc,
        "//*[local-name()='front']//*[local-name()='journal-meta']//*[local-name()='publisher']//*[local-name()='publisher-name']/text()"
    )
    if not name:
        raise ValueError("Unable to extract publisher name using front/journal-meta/publisher/publisher-name")
    return name

def extract_journal_title(doc: etree._ElementTree) -> str:
    # journal-meta/journal-title-group/journal-title
    # Namespace tolerant via local-name().
    title = _xpath_first_text(
        doc,
        "//*[local-name()='journal-meta']//*[local-name()='journal-title-group']//*[local-name()='journal-title']/text()"
    )
    if not title:
        raise ValueError("Unable to extract journal title using journal-meta/journal-title-group/journal-title")
    return title


def extract_volume_issue(doc: etree._ElementTree) -> tuple[str, str]:
    # Common JATS defaults + fallbacks, namespace tolerant.
    volume = _xpath_first_text(doc, "//*[local-name()='front']//*[local-name()='article-meta']//*[local-name()='volume']/text()")
    issue  = _xpath_first_text(doc, "//*[local-name()='front']//*[local-name()='article-meta']//*[local-name()='issue']/text()")

    # Minimal fallbacks: sometimes volume/issue appear elsewhere; try any volume/issue under front.
    if not volume:
        volume = _xpath_first_text(doc, "//*[local-name()='front']//*[local-name()='volume']/text()")
    if not issue:
        issue = _xpath_first_text(doc, "//*[local-name()='front']//*[local-name()='issue']/text()")

    if not volume or not issue:
        raise ValueError(f"Unable to extract volume/issue (volume={volume!r}, issue={issue!r})")

    return volume, issue


def load_xml_first(xml_dir: Path) -> etree._ElementTree:
    # Pick a deterministic XML file: alphabetically first.
    xml_files = sorted([p for p in xml_dir.glob("*.xml") if p.is_file()])
    if not xml_files:
        raise ValueError(f"No XML files found in {xml_dir}")
    return etree.parse(str(xml_files[0]))
