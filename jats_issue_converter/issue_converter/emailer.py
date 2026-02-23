"""Email notifications via AWS SES."""

from __future__ import annotations

import boto3
from dataclasses import dataclass
from typing import List, Optional


@dataclass(frozen=True)
class EmailMessage:
    subject: str
    body_text: str


class SesMailer:
    def __init__(self, region: str, from_address: str, to_addresses: List[str]):
        self.region = region
        self.from_address = from_address
        self.to_addresses = to_addresses
        self.client = boto3.client("ses", region_name=region)

    def send(self, msg: EmailMessage) -> None:
        self.client.send_email(
            Source=self.from_address,
            Destination={"ToAddresses": self.to_addresses},
            Message={
                "Subject": {"Data": msg.subject, "Charset": "UTF-8"},
                "Body": {"Text": {"Data": msg.body_text, "Charset": "UTF-8"}},
            },
        )
