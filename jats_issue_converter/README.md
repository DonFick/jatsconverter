Issue Converter (JATS/SCJATS ZIP → HTML publish pipeline)
=======================================================

Overview
--------
This service watches an incoming directory for ZIP uploads, validates XML against a local SCJATS XSD schema,
runs an issue-level XSLT transform, publishes the resulting HTML/assets under an Apache-served
directory tree, and regenerates a top-level index page after each successful publish.

Key behaviors (as specified)
----------------------------
- Watch: /home/converter/incoming (configurable)
- Upload completion: file size stable for 90 seconds (configurable)
- Processing: serial; eligible ZIPs processed by mtime oldest-first
- ZIP wrapper dir: if there is a single top-level wrapper directory, ignore it
- Optional input dirs: xml/, pdfs/, figs/, images/, eqs/, media/ (all optional, but XML is required to publish)
- Keep figs/ and images/ separate in output
- Issue identity derived from JATS metadata:
  - journal title: journal-meta/journal-title-group/journal-title
  - volume/issue: common JATS defaults + fallbacks
  - numeric volume/issue are left-padded to >=3 digits
- Publish path: /data/<journal-id>/<volume-id>/<volume-id><issue-id>/toc.html
- Replace semantics: republish fully replaces previous output for that issue via atomic swap
- Errors: send SES email + move ZIP to failed directory
- Retention: 365 days for archived ZIPs, failed ZIPs, logs, and staging artifacts

Setup (Ubuntu 22.04+)
---------------------
1) System user + directories
   - Create a dedicated system user `converter` (if you haven't already).
   - Ensure these directories exist and are writable by `converter`:
     - /home/converter/incoming
     - /home/converter/processing
     - /home/converter/staging
     - /home/converter/archive
     - /home/converter/failed
     - /home/converter/logs
   - Ensure Apache can read the publish root:
     - /mnt/volume_nyc3_01_500gb/www/pinetec/review-aapg/data

2) Install Python runtime + dependencies
   - Use Python 3.10+ recommended (Ubuntu 22.04 default is fine).
   - Create a virtualenv owned by converter (example path):
     - /opt/issue-converter/venv

3) Configure XSLT + SCJATS schema
   - Place your issue-level XSLT at the path in config.toml (default):
     - /opt/issue-converter/xslt/issue.xsl
   - Place the SCJATS XSD bundle under:
     - /opt/issue-converter/xsd
     and ensure the configured entry point exists at:
     - /opt/issue-converter/xsd/SilverchairSpecifications1_46_mathml2/SCJATS-journalpublishing.xsd
   Notes:
   - Schema validation does not require XML DOCTYPE declarations.
   - Keep schemas local; do not fetch from the network in production.

4) Configure AWS SES
   - The service uses boto3. Provide credentials via one of:
     - Instance/host IAM role (preferred)
     - ~/.aws/credentials for the converter user
     - Environment variables (AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY)
   - Ensure SES is out of sandbox or recipients are verified.

5) Create config
   - Copy config.example.toml to:
     - /etc/issue-converter/config.toml
   - Update paths, XSLT, schema root, and SES region if needed.

6) Install systemd unit
   - Copy the provided unit files from ./systemd/ to /etc/systemd/system/
   - Enable and start:
     - issue-converter.service

7) Apache mapping
   - Ensure Apache maps URL prefix /data/ to publish_root, e.g. with an Alias directive.
   - The service writes /data/index.html and per-issue trees below it.

Operations
----------
- Logs: per-job logs are stored under log_dir; the daemon also logs to stdout (captured by systemd/journald).
- Failure handling:
  - ZIP moved to failed_dir
  - SES email sent with details and log path
- Retention:
  - A daily cleanup is performed by the daemon (at startup and then every 24h) to prune artifacts older than retention_days.

Administrator operations
------------------------
The browseable list of issues is driven by `manifest.json` files written into each published issue
directory. This means administrators can remove an issue without manually editing generated HTML:
delete the issue directory and regenerate `/data/index.html`.

All admin commands use the same config file used by the daemon.

List published issues
~~~~~~~~~~~~~~~~~~~~~
```bash
python -m issue_converter --config /etc/issue-converter/config.toml list-issues
```

Remove a published issue
~~~~~~~~~~~~~~~~~~~~~~~~
```bash
python -m issue_converter --config /etc/issue-converter/config.toml remove-issue \
  --journal-id <journal-id> --volume <volume> --issue <issue>
```   

Notes:
- `--volume` and `--issue` may be the raw values shown in the TOC/index (e.g., `SP28` and `1`) or the
  normalized/padded values (e.g., `001`).
- After removal, the command regenerates `/data/index.html` so the removed issue disappears from the
  browseable list immediately.

Regenerate index only
~~~~~~~~~~~~~~~~~~~~~
```python -m issue_converter --config /etc/issue-converter/config.toml reindex```  


Example: Removing an Issue
~~~~~~~~~~~~~~~~~~~~~~~~~~
1) Using SSH, log in to SHINY3 using the “converter” username and password.  
   - This will put you in the converter user home directory.

2) Change directory to the issue-converter software directory:  
   ```cd /opt/issue-converter/jats_issue_converter```  

3) Activate a virtual environment for Python.  
	```source ../venv/bin/activate```

4) List the available issues with this command:  
   ```python -m issue_converter --config /etc/issue-converter/config.toml list-issues```

The list will show journal name, volume ID, Issue ID, and directory. Find the entry in the list you want to delete.

For example, an entry for an issue will look like this:   
`permian-basin-section	Vol 55 (id=055)	Issue 01 (id=001)	/mnt/volume_nyc3_01_500gb/www/pinetec/review-aapg/jats/data/permian-basin-section-society-of-economic-paleontologists-and-mineralogists/permian-basin-section/055/055001`

5) Remove an issue with this command:  
```python -m issue_converter --config /etc/issue-converter/config.toml remove-issue --journal-id <journal-id> --volume <volume> --issue <issue>```

So, following the example above:  

```python -m issue_converter --config /etc/issue-converter/config.toml remove-issue --journal-id permian-basin-section --volume 055 --issue 001
 