<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:mml="http://www.w3.org/1998/Math/MathML"
    exclude-result-prefixes="xlink mml">

  <xsl:template match="disp-formula | statement">
    <div class="{local-name()} panel">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="." mode="label"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="mml:*">
    <xsl:element name="{local-name()}"
                 namespace="http://www.w3.org/1998/Math/MathML">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template
      match="disp-formula[.//mml:math]/alternatives[graphic or inline-graphic]"
      priority="5">
    <xsl:apply-templates select="*[not(self::graphic or self::inline-graphic)]"/>
  </xsl:template>

  <xsl:template match="disp-formula" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-disp-formula"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>Formula </xsl:text>
        <xsl:number level="any"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>