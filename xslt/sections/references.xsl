<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" xsl="http://www.w3.org/1999/XSL/Transform" xlink="http://www.w3.org/1999/xlink" mml="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="xlink mml">
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="ref-list" name="ref-list">
    <div class="section ref-list">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="." mode="label"/>
      <xsl:apply-templates select="*[not(self::ref | self::ref-list)]"/>
      <xsl:if test="ref">
        <div class="ref-list table">
          <xsl:apply-templates select="ref"/>
        </div>
      </xsl:if>
      <xsl:apply-templates select="ref-list"/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="citation-alternatives" priority="2">
    <!-- priority bumped to supersede match on ref/* -->
    <!-- may appear in license-p, p, ref, td, th, title  -->
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="ref/* | ref/citation-alternatives/*" priority="0">
    <!-- should match mixed-citation, element-citation, nlm-citation,
         or citation (in 2.3); note and label should be matched below;
         citation-alternatives is handled elsewhere -->
<span class="citation">
<xsl:call-template name="named-anchor"/>
<xsl:apply-templates/>
</span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="       app/related-article |       app-group/related-article | bio/related-article |       body/related-article | boxed-text/related-article |       disp-quote/related-article | glossary/related-article |       gloss-group/related-article |       ref-list/related-article | sec/related-article">
    <xsl:apply-templates select="." mode="metadata"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="       app/related-object |       app-group/related-object | bio/related-object |       body/related-object | boxed-text/related-object |       disp-quote/related-object | glossary/related-object |       gloss-group/related-article |       ref-list/related-object | sec/related-object">
    <xsl:apply-templates select="." mode="metadata"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="       aff/label | corresp/label | chem-struct/label |       element-citation/label | mixed-citation/label | citation/label">
    <!-- these labels appear in line -->
    <!-- <span class="generated">[</span> -->
        <xsl:apply-templates/>
    <!-- <span class="generated">] </span> -->
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="back/ref-list">
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">References</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:call-template name="ref-list"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
</xsl:stylesheet>
