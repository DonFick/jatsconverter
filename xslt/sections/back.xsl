<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" xsl="http://www.w3.org/1999/XSL/Transform" xlink="http://www.w3.org/1999/xlink" mml="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="xlink mml">
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="notes" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Notes</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="author-notes" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label"></xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:call-template name="named-anchor"/>
        <xsl:apply-templates mode="metadata"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="author-notes/corresp" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:call-template name="named-anchor"/>
        <xsl:text></xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="author-notes/fn | author-notes/p" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:apply-templates select="@fn-type"/>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:call-template name="named-anchor"/>
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="       array | disp-formula-group | fig-group |       fn-group | license | long-desc | open-access | sig-block |       table-wrap-foot | table-wrap-group">
    <div class="{local-name()}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="back">
    <!-- content model for back: 
          (label?, title*, 
          (ack | app-group | bio | fn-group | glossary | ref-list |
           notes | sec)*) -->
    <xsl:if test="not(fn-group) and $loose-footnotes">
      <xsl:call-template name="footnotes"/>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="ack">
    <CJSACKNOW>
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">Acknowledgements</xsl:with-param>
    </xsl:call-template>
    </CJSACKNOW>
    </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="app-group">
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">Appendices</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="back/bio">
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">Biography</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="back/fn-group">
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">Notes</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="back/glossary | back/gloss-group">
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">Glossary</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="back/notes">
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">Notes</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="       fn-group/fn | table-wrap-foot/fn |       table-wrap-foot/fn-group/fn">
    <xsl:apply-templates select="." mode="footnote"/>
  </xsl:template>


  
</xsl:stylesheet>
