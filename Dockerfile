FROM python:3.11-slim

# OS deps for lxml/libxml2/libxslt runtime + build
RUN apt-get update && apt-get install -y --no-install-recommends \
    libxml2 libxslt1.1 \
    && rm -rf /var/lib/apt/lists/*

# Create a user that matches your production intent (no need to match UID for dev)
RUN useradd -m -d /home/converter -s /bin/bash converter

WORKDIR /app

# Copy only requirements first for better caching
COPY jats_issue_converter/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy the package
COPY jats_issue_converter /app/jats_issue_converter

# Make the "issue_converter" package importable as a top-level module
ENV PYTHONPATH=/app/jats_issue_converter

USER converter

# Default: run the daemon (watchdog + periodic rescan)
CMD ["python", "-m", "issue_converter", "--config", "/config/config.toml", "run"]
