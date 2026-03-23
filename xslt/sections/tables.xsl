<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" xsl="http://www.w3.org/1999/XSL/Transform" xlink="http://www.w3.org/1999/xlink" mml="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="xlink mml">
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="trans-title" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Translated Title</xsl:text>
        <xsl:for-each select="(../@xml:lang | @xml:lang)[last()]">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="trans-subtitle" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Translated Subtitle</xsl:text>
        <xsl:for-each select="(../@xml:lang | @xml:lang)[last()]">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="conf-theme" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Conference theme</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="contract-num" mode="metadata">
    <!-- only in 2.3 -->
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Contract</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="contract-sponsor" mode="metadata">
    <!-- only in 2.3 -->
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Contract Sponsor</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="       contrib/name |       contrib/name-alternatives/*" mode="metadata-inline">
    <xsl:apply-templates select="."/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="contrib-id" mode="metadata-inline">
    [<xsl:apply-templates select="."/>] 
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="author-comment" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Comment</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="attrib">
    <p class="attrib">
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="boxed-text | chem-struct-wrap | fig | table-wrap | chem-struct-wrapper">
    <!-- chem-struct-wrapper is from NLM 2.3 -->
    <xsl:variable name="gi">
      <xsl:choose>
        <xsl:when test="self::chem-struct-wrapper">chem-struct-wrap</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="local-name(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="{$gi} panel">
      <xsl:if test="not(@position != 'float')">
        <!-- the test respects @position='float' as the default -->
        <xsl:attribute name="style">display: float; clear: both</xsl:attribute>
      </xsl:if>
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="." mode="label"/>
      <xsl:apply-templates/>
      <xsl:apply-templates mode="footnote" select="self::table-wrap//fn[not(ancestor::table-wrap-foot)]"/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="tex-math">
    <span class="tex-math">
      <span class="generated">[TeX:] </span>
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="       app/label | boxed-text/label |       chem-struct-wrap/label | chem-struct-wrapper/label |       disp-formula/label | fig/label | fn/label | ref/label |       statement/label | supplementary-material/label | table-wrap/label" priority="2">
    <!-- suppressed, since acquired by their parents in mode="label" -->
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="       table | thead | tbody | tfoot |       col | colgroup | tr | th | td">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="table-copy"/>
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="array/tbody">
    <table>
      <xsl:copy>
        <xsl:apply-templates select="@*" mode="table-copy"/>
        <xsl:call-template name="named-anchor"/>
        <xsl:apply-templates/>
      </xsl:copy>
    </table>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="abbrev[normalize-space(string(@xlink:href))]">
    <a>
      <xsl:call-template name="assign-href"/>
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="award-id[normalize-space(string(@rid))]">
    <a href="#{@rid}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="inline-formula | chem-struct">
    <span class="{local-name()}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="chem-struct-wrap/chem-struct | chem-struct-wrapper/chem-struct">
    <div class="{local-name()}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="xref[not(normalize-space(string(.)))]">
    <a href="#{@rid}">
      <xsl:apply-templates select="key('element-by-id', @rid)" mode="label-text">
        <xsl:with-param name="warning" select="true()"/>
      </xsl:apply-templates>
    </a>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="strike">
    <span style="text-decoration: line-through">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="chem-struct-wrap | chem-struct-wrapper" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-chem-struct-wrap"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>Formula (chemical) </xsl:text>
        <xsl:number level="any"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="table-wrap//fn" mode="label-text">
    <xsl:param name="warning" select="boolean(key('xref-by-rid', @id))"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels);
         by default, we get a warning only if we need a label for
         a cross-reference -->
    <xsl:param name="auto-number-fn" select="not(ancestor::table-wrap//fn/label | ancestor::table-wrap//fn/@symbol)"/>
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-number-fn"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>[</xsl:text>
        <xsl:number level="any" count="fn" from="table-wrap" format="i"/>
        <xsl:text>]</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'other']" priority="2"/>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="table-wrap" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-table-wrap"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>Table </xsl:text>
        <xsl:number level="any" format="I"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="contrib/name/surname" mode="inline-name">
    <xsl:apply-templates/>
    <xsl:if test="../given-names[../@name-style = 'eastern'] | ../suffix">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="string-name">
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="string-name/*">
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="month" mode="map">
    <!-- maps numeric values to English months -->
    <xsl:choose>
      <xsl:when test="number() = 1">January</xsl:when>
      <xsl:when test="number() = 2">February</xsl:when>
      <xsl:when test="number() = 3">March</xsl:when>
      <xsl:when test="number() = 4">April</xsl:when>
      <xsl:when test="number() = 5">May</xsl:when>
      <xsl:when test="number() = 6">June</xsl:when>
      <xsl:when test="number() = 7">July</xsl:when>
      <xsl:when test="number() = 8">August</xsl:when>
      <xsl:when test="number() = 9">September</xsl:when>
      <xsl:when test="number() = 10">October</xsl:when>
      <xsl:when test="number() = 11">November</xsl:when>
      <xsl:when test="number() = 12">December</xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="processing-instruction()" mode="xpath-step">
    <xsl:text>/processing-instruction()</xsl:text>
    <xsl:if test="count(../processing-instruction()) &gt; 1">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="count(. | preceding-sibling::processing-instruction())"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>


<!-- Added special specialized template for when a graphic alternative is provided for a table. We don't render the table.
instead, we render a thumbnail that links out to a page with full sized image -->
    <xsl:template match="table-wrap[@id][alternatives/*[self::graphic or self::inline-graphic]]" priority="3"
                  xmlns:xlink="http://www.w3.org/1999/xlink">

        <xsl:variable name="table-id" select="@id"/>
        <xsl:variable name="g" select="alternatives/*[self::graphic or self::inline-graphic][1]"/>

        <xsl:variable name="img">
            <xsl:choose>
                <xsl:when test="$g/@xlink:href">
                    <xsl:value-of select="$g/@xlink:href"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$g/@href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="filename">
            <xsl:call-template name="last-segment">
                <xsl:with-param name="path" select="$img"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="basename">
            <xsl:call-template name="strip-last-extension">
                <xsl:with-param name="filename" select="$filename"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="label" select="normalize-space(label)"/>
        <xsl:variable name="caption" select="normalize-space(string(caption))"/>

        <div class="table-wrap panel table-image" id="{$table-id}">
            <xsl:call-template name="named-anchor"/>

            <a href="{concat('../figs/', $xml-basename, '.', $table-id, '.html')}">
                <img src="{concat('../thumbs/', $basename, '.jpg')}"
                     alt="{$caption}"
                     class="thumbnail"
                     width="200"/>
            </a>

            <xsl:if test="$label">
                <div class="fig-label">
                    <xsl:value-of select="$label"/>
                </div>
            </xsl:if>

            <xsl:if test="caption">
                <div class="fig-caption caption">
                    <xsl:apply-templates select="caption/node()"/>
                </div>
            </xsl:if>
        </div>
    </xsl:template>

    <!-- this template provides the equivalent of a figure detail page for graphic alternatives on tables -->
    <xsl:template match="table-wrap[@id][alternatives/*[self::graphic or self::inline-graphic]]"
                  mode="full-table-image"
                  priority="3"
                  xmlns:xlink="http://www.w3.org/1999/xlink">

        <xsl:variable name="table-id" select="@id"/>
        <xsl:variable name="g" select="alternatives/*[self::graphic or self::inline-graphic][1]"/>

        <xsl:variable name="img">
            <xsl:choose>
                <xsl:when test="$g/@xlink:href">
                    <xsl:value-of select="$g/@xlink:href"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$g/@href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="filename">
            <xsl:call-template name="last-segment">
                <xsl:with-param name="path" select="$img"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="basename">
            <xsl:call-template name="strip-last-extension">
                <xsl:with-param name="filename" select="$filename"/>
            </xsl:call-template>
        </xsl:variable>

        <html>
            <head>
                <title>
                    <xsl:value-of select="concat(normalize-space(label), ': ', normalize-space(string(caption)))"/>
                </title>
                <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8" />
                <link rel="stylesheet" type="text/css" href="../../../global.css" />
                <meta name="parent-file" content="../html/.htm" />
                <script type="text/javascript" src="http://archives.datapages.com/data/aapg-scripts/mathjax.js"></script>
            </head>
            <body>
                <h2><xsl:value-of select="label"/></h2>

                <img src="{concat('../figs/', $basename, '.jpg')}"
                     alt="{normalize-space(string(caption))}"
                     style="border: 0; margin: 10px 0; max-width: 100%; height: auto;" />

                <div class="caption">
                    <xsl:apply-templates select="caption"/>
                </div>

                <p>
                    <a href="{concat('../html/', $xml-basename, '.html', '#', $table-id)}">Back to article</a>
                </p>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
