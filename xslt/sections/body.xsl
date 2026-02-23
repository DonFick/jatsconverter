<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" xsl="http://www.w3.org/1999/XSL/Transform" xlink="http://www.w3.org/1999/xlink" mml="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="xlink mml">
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="sub-article | response">
    <hr class="part-rule"/>
    <xsl:call-template name="make-article"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="publisher" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Publisher</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates select="publisher-name" mode="metadata-inline"/>
        <xsl:apply-templates select="publisher-loc" mode="metadata-inline"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="publisher-name" mode="metadata-inline">
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="publisher-loc" mode="metadata-inline">
    <span class="generated"> (</span>
    <xsl:apply-templates/>
    <span class="generated">)</span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="ext-link" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>External link</xsl:text>
        <xsl:for-each select="ext-link-type">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="copyright-statement" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Copyright statement</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="copyright-year" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Copyright</xsl:with-param>
    </xsl:call-template>
  </xsl:template>




  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="issue-sponsor" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Issue sponsor</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="issue-part" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Issue part</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="supplement" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Supplement Info</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="conf-sponsor" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Conference sponsor</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="grant-sponsor" mode="metadata">
    <!-- only in 2.3 -->
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Grant Sponsor</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="award-group" mode="metadata">
    <!-- includes (funding-source*, award-id*, principal-award-recipient*, principal-investigator*) -->
    <xsl:apply-templates mode="metadata"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="principal-award-recipient" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Award Recipient</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="principal-investigator" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Principal Investigator</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="open-access" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Open Access</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="xref" mode="metadata-inline">
    <!-- These are not expected to appear in mixed content, so
      brackets are provided -->
    [<xsl:apply-templates select="."/>]
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" mode="metadata" match="       count | fig-count | table-count | equation-count |       ref-count | page-count | word-count">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:apply-templates select="." mode="metadata-label"/>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:value-of select="@count"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="page-count" mode="metadata-label">Pages</xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" mode="metadata" match="custom-meta-group | custom-meta-wrap">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Custom metadata</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates mode="metadata"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="sec">
    <div class="section">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="title"/>
      <xsl:apply-templates select="sec-meta"/>
      <xsl:apply-templates mode="drop-title"/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="title | sec-meta" mode="drop-title"/>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="app">
    <div class="section app">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="." mode="label"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="sec-meta">
    <div class="section-metadata">
      <!-- includes contrib-group | permissions | kwd-group -->
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="caption">
    <div class="caption">
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="glossary | gloss-group">
    <!-- gloss-group is from 2.3 -->
    <div class="glossary">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="label | title"/>
      <xsl:if test="not(normalize-space(string(title)))">
        <xsl:call-template name="block-title">
          <xsl:with-param name="contents">
            <span class="generated">Glossary</span>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates select="*[not(self::label | self::title)]"/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="glossary/glossary | gloss-group/gloss-group">
    <!-- the same document shouldn't have both types -->
    <div class="glossary">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>



  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="list">
    <div class="list">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="label | title"/>
      <xsl:apply-templates select="." mode="list"/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" priority="2" mode="list" match="list[@list-type = 'simple' or list-item/label]">
    <ul style="list-style-type: none">
      <xsl:apply-templates select="list-item"/>
    </ul>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="list[@list-type = 'bullet' or not(@list-type)]" mode="list">
    <ul>
      <xsl:apply-templates select="list-item"/>
    </ul>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="list" mode="list">
    <xsl:variable name="style">
      <xsl:choose>
        <xsl:when test="@list-type = 'alpha-lower'">lower-alpha</xsl:when>
        <xsl:when test="@list-type = 'alpha-upper'">upper-alpha</xsl:when>
        <xsl:when test="@list-type = 'roman-lower'">lower-roman</xsl:when>
        <xsl:when test="@list-type = 'roman-upper'">upper-roman</xsl:when>
        <xsl:otherwise>decimal</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <ol style="list-style-type: {$style}">
      <xsl:apply-templates select="list-item"/>
    </ol>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="list-item">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="list-item/label">
    <!-- if the next sibling is a p, the label will be called as
	       a run-in -->
    <xsl:if test="following-sibling::*[1][not(self::p)]">
      <xsl:call-template name="label"/>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="p | license-p">
    <p>
      <xsl:if test="not(preceding-sibling::*)">
        <xsl:attribute name="class">first</xsl:attribute>
      </xsl:if>
      <xsl:call-template name="assign-id"/>
      <xsl:apply-templates select="@content-type"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="@content-type">
    <!-- <span class="generated">[</span>
    <xsl:value-of select="."/>
    <span class="generated">] </span> -->
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="list-item/p[not(preceding-sibling::*[not(self::label)])]">
    <p>
      <xsl:call-template name="assign-id"/>
      <xsl:for-each select="preceding-sibling::label">
        <span class="label">
          <xsl:apply-templates/>
        </span>
        <xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:apply-templates select="@content-type"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="product">
    <p class="product">
      <xsl:call-template name="assign-id"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="permissions">
    <div class="permissions">
      <xsl:apply-templates select="copyright-statement"/>
      <xsl:if test="copyright-year | copyright-holder">
        <p class="copyright">
          <span class="generated">Copyright</span>
          <xsl:for-each select="copyright-year | copyright-holder">
            <xsl:apply-templates/>
            <xsl:if test="not(position() = last())">
              <span class="generated">, </span>
            </xsl:if>
          </xsl:for-each>
        </p>
      </xsl:if>
      <xsl:apply-templates select="license"/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="copyright-statement">
    <p class="copyright">
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="def-list">
    <div class="def-list">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="label | title"/>
      <div class="def-list table">
        <xsl:if test="term-head | def-head">
          <div class="row">
            <div class="cell def-list-head">
              <xsl:apply-templates select="term-head"/>
            </div>
            <div class="cell def-list-head">
              <xsl:apply-templates select="def-head"/>
            </div>
          </div>
        </xsl:if>
        <xsl:apply-templates select="def-item"/>
      </div>
      <xsl:apply-templates select="def-list"/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="disp-quote">
    <div class="blockquote">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="preformat">
    <pre class="preformat">
      <xsl:apply-templates/>
    </pre>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="speech">
    <div class="speech">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates mode="speech"/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="speech/speaker" mode="speech"/>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="speech/p" mode="speech">
    <p>
      <xsl:apply-templates select="self::p[not(preceding-sibling::p)]/../speaker"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="speech/speaker">
    <b>
      <xsl:apply-templates/>
    </b>
    <span class="generated">: </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="verse-group">
    <div class="verse">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="p/label">
    <span class="label">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="@content-type" mode="table-copy"/>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="       p/address | license-p/address |       named-content/p | styled-content/p">
    <xsl:apply-templates mode="inline"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="private-char">
    <span>
      <xsl:for-each select="@description">
        <xsl:attribute name="title">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:for-each>
      <span class="generated">[Private character </span>
      <xsl:for-each select="@name">
        <xsl:text> </xsl:text>
        <xsl:value-of select="."/>
      </xsl:for-each>
      <span class="generated">]</span>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="glyph-data | glyph-ref">
    <span class="generated">(Glyph not rendered)</span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="xref">
    <a href="#{@rid}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>



  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="bold">
    <b>
      <xsl:apply-templates/>
    </b>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="italic">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="monospace">
    <tt>
      <xsl:apply-templates/>
    </tt>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="price">
    <span class="price">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="sup">
    <sup>
      <xsl:apply-templates/>
    </sup>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="underline">
    <span style="text-decoration: underline">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/p">
    <p>
      <xsl:call-template name="assign-id"/>
      <xsl:if test="not(preceding-sibling::p)">
        <!-- drop an inline label text into the first p -->
        <xsl:apply-templates select="parent::fn" mode="label-text"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="app" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-app"/>
      <xsl:with-param name="warning" select="$warning"/>
      <!--
      Pass in the desired label if a label is to be autogenerated  
      <xsl:with-param name="auto-text">
        <xsl:text>Appendix </xsl:text>
        <xsl:number format="A"/>
      </xsl:with-param>-->
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'abbr']" priority="2">
    <span class="generated"> Abbreviation</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'com']" priority="2">
    <span class="generated"> Communicated by</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'con']" priority="2">
    <span class="generated"> Contributed by</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'conflict']" priority="2">
    <span class="generated"> Conflicts of interest</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'corresp']" priority="2">
    <span class="generated"> Corresponding author</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'current-aff']" priority="2">
    <span class="generated"> Current affiliation</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'deceased']" priority="2">
    <span class="generated"> Deceased</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'edited-by']" priority="2">
    <span class="generated"> Edited by</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'equal']" priority="2">
    <span class="generated"> Equal contributor</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'financial-disclosure']" priority="2">
    <span class="generated"> Financial disclosure</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'on-leave']" priority="2">
    <span class="generated"> On leave</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'participating-researchers']" priority="2">
    <span class="generated"> Participating researcher</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'present-address']" priority="2">
    <span class="generated"> Current address</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'presented-at']" priority="2">
    <span class="generated"> Presented at</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'presented-by']" priority="2">
    <span class="generated"> Presented by</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'previously-at']" priority="2">
    <span class="generated"> Previously at</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'study-group-members']" priority="2">
    <span class="generated"> Study group member</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'supported-by']" priority="2">
    <span class="generated"> Supported by</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type"/>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="prefix" mode="inline-name">
    <xsl:apply-templates/>
    <xsl:if test="../surname | ../given-names | ../suffix">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="article | sub-article | response" mode="id">
    <xsl:value-of select="@id"/>
    <xsl:if test="not(@id)">
      <xsl:value-of select="local-name()"/>
      <xsl:number from="article" level="multiple" count="article | sub-article | response" format="1-1"/>
    </xsl:if>
  </xsl:template>


  
</xsl:stylesheet>
