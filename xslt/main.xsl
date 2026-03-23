<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" xsl="http://www.w3.org/1999/XSL/Transform" xlink="http://www.w3.org/1999/xlink" mml="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="xlink mml">

  <!-- Output HTML instead of XML -->
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <!-- Optional: omit XML declaration -->
  <!-- <xsl:output method="html" omit-xml-declaration="yes"/> -->
<xsl:output method="html" omit-xml-declaration="yes"/>


<xsl:param name="object-id" select="''"/>
<xsl:param name="object-kind" select="''"/>

<xsl:param name="xml-basename" select="''"/>

<!-- Core (setup first so keys/params/modes exist) -->
<xsl:include href="core/00-core-setup.xsl"/>
<xsl:include href="core/01-core-commons.xsl"/>

<!-- Site framing -->
<xsl:include href="site/output-frame.xsl"/>
<xsl:include href="site/branding-overrides.xsl"/>

<!-- JATS sections -->
<xsl:include href="sections/front.xsl"/>
<xsl:include href="sections/body.xsl"/>
<xsl:include href="sections/back.xsl"/>
<xsl:include href="sections/floats.xsl"/>
<xsl:include href="sections/references.xsl"/>
<xsl:include href="sections/tables.xsl"/>
<xsl:include href="sections/figures.xsl"/>
<xsl:include href="sections/mathml.xsl"/>
</xsl:stylesheet>
