issue-converter/                          # Git repo root
├── README.md
├── LICENSE                               # if you have one
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── config.example.toml                   # safe defaults, no secrets
├── config.dev.toml                       # OPTIONAL, usually .gitignored
├── requirements.txt                      # OPTIONAL at repo root (see note below)
│
├── jats_issue_converter/                 # Python package / application
│   ├── pyproject.toml                    # if you’re packaging properly (recommended)
│   ├── requirements.txt                  # app deps (if not using pyproject)
│   ├── issue_converter/                  # importable module (your “-m issue_converter” entry)
│   │   ├── __init__.py
│   │   ├── __main__.py                   # CLI: run, list-issues, remove-issue, reindex
│   │   ├── config.py                     # TOML load + validation
│   │   ├── watcher.py                    # watchdog wiring + rescan trigger
│   │   ├── scheduler.py                  # eligible selection, mtime sort, stability check
│   │   ├── worker.py                     # unzip, validate, extract ids, transform, publish
│   │   ├── jats_extract.py               # journal/volume/issue extraction + fallbacks
│   │   ├── normalize.py                  # slugify + pad logic + safe path helpers
│   │   ├── dtd_validate.py               # DTD validation (local resolver)
│   │   ├── transform.py                  # XSLT invocation (your existing logic wrapped)
│   │   ├── manifest.py                   # manifest read/write
│   │   ├── indexgen.py                   # /data/index.html generation (group A sorting)
│   │   ├── retention.py                  # 365d cleanup
│   │   ├── notify.py                     # SES email alerts
│   │   └── logging_utils.py              # structured logging helpers
│   └── README.md                         # dev notes specific to the app package
│
├── systemd/                              # production service units
│   └── issue-converter.service
│
├── apache/                               # production apache config snippets
│   └── APACHE_ALIAS_SNIPPET.txt
│
├── xslt/                                 # recommended to version if it’s yours
│   └── issue.xsl                         # your issue-level stylesheet
│
├── dtd/                                  # optional: only if you vendor DTDs
│   └── ...                               # often excluded from Git; supplied separately
│
├── devdata/                              # local runtime dirs for Docker dev (GITIGNORED)
│   ├── incoming/
│   ├── processing/
│   ├── staging/
│   ├── archive/
│   ├── failed/
│   ├── logs/
│   └── publish/                          # maps to /publish in container, your /data equivalent
│
└── docs/                                 # optional longer documentation
    ├── setup-ubuntu.md
    ├── setup-docker-mac.md
    └── operations.md
