
# Modularized JATS HTML XSLT

This folder was generated from the original `scjats-html.xsl` by splitting the stylesheet into topic-based modules.
Run the transform by pointing your processor at `main.xsl`:

- xsltproc: `xsltproc main.xsl article.xml > out.html`
- Saxon 6.5: `java -cp saxon.jar com.icl.saxon.StyleSheet article.xml main.xsl > out.html`

## Layout
- **core/00-core-setup.xsl** — `xsl:output`, `xsl:param`, `xsl:key`, whitespace control.
- **core/01-core-commons.xsl** — shared utilities and any templates that weren’t matched to a specific section.
- **site/output-frame.xsl** — root template (`match="/"`) and header utilities (e.g., `make-html-header` if present).
- **site/branding-overrides.xsl** — a safe place for site-specific changes.
- **sections/front.xsl** — `front`/`journal-meta`/`article-meta`/`title-group`/`contrib-group`/abstracts.
- **sections/body.xsl** — `body`/`sec`/`p`/lists/inlines/general content.
- **sections/back.xsl** — `back`/acknowledgments/notes/appendices (excluding references).
- **sections/references.xsl** — `ref-list`, `element-citation`, `mixed-citation`, etc.
- **sections/tables.xsl** — `table-wrap` and table structures.
- **sections/figures.xsl** — `fig`, `graphic`, `supplementary-material` handling.
- **sections/floats.xsl** — `floats-group` routing (if present).
- **sections/mathml.xsl** — `inline-formula`, `disp-formula`, and MathML-related templates.

> Note: The split uses heuristics based on `xsl:template` `match`/`name` attributes. Review `core/01-core-commons.xsl` for utilities that could be moved into a more specific module if desired.

## Namespaces
We preserved your original namespace prefixes from the root element so any prefixed matches (e.g., `mml:`) continue to work.

## Next steps
- If you add a new section module, just add another `<xsl:include>` to `main.xsl`.
- If you have an external base you want to override, use `<xsl:import>` at the top of `main.xsl`, then keep your modules as includes so they win by precedence.
