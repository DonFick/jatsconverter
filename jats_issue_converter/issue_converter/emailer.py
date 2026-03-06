"""Email notifications via AWS SES or local SMTP."""

from __future__ import annotations

import boto3
import smtplib

from email.message import EmailMessage as _EmailMessage
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


class SmtpMailer:
    """
    Simple SMTP mailer that sends messages through a local SMTP server.
    Assumes localhost SMTP relay (e.g., Postfix) on port 25.
    """

    def __init__(self, from_address: str, to_addresses: List[str], host: str = "localhost", port: int = 25):
        self.from_address = from_address
        self.to_addresses = to_addresses
        self.host = host
        self.port = port

    def send(self, msg: EmailMessage) -> None:
        email = _EmailMessage()
        email["Subject"] = msg.subject
        email["From"] = self.from_address
        email["To"] = ", ".join(self.to_addresses)
        email.set_content(msg.body_text)

        with smtplib.SMTP(self.host, self.port) as smtp:
            smtp.send_message(email)