<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:mml="http://www.w3.org/1998/Math/MathML" 
    xsl="http://www.w3.org/1999/XSL/Transform"
    xlink="http://www.w3.org/1999/xlink" 
    mml="http://www.w3.org/1998/Math/MathML"
    exclude-result-prefixes="xlink mml">
    
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="supplementary-material" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Supplementary material</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fig-count" mode="metadata-label">Figures</xsl:template>


  

  <!-- Standalone graphics (not inside <fig>): render as a thumbnail image without a link -->
<xsl:template match="graphic[not(ancestor::fig)] | inline-graphic[not(ancestor::fig)]" priority="3">
  
    <xsl:variable name="img">
      <xsl:choose>
        <xsl:when test="@xlink:href">
          <xsl:value-of select="@xlink:href"/>
        </xsl:when>
        <xsl:when test="@href">
          <xsl:value-of select="@href"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <!-- last-segment + strip-last-extension helpers assumed available -->
    <xsl:variable name="filename">
      <xsl:call-template name="last-segment">
        <xsl:with-param name="path" select="$img"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="basename">
      <xsl:call-template name="strip-last-extension">
        <xsl:with-param name="filename" select="normalize-space($filename)"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="label"   select="normalize-space(label)"/>
    <xsl:variable name="caption" select="normalize-space(caption)"/>

  <div class="figure">
    <img src="{concat('../thumbs/', $basename, '.jpg')}"
           class="thumbnail" width="200">
      <!-- Prefer explicit alt-text; otherwise fall back to @xlink:href -->
      <xsl:choose>
        <xsl:when test="alt-text">
          <xsl:attribute name="alt">
            <xsl:value-of select="normalize-space(string(alt-text[1]))"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="alt"><xsl:value-of select="@xlink:href"/></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </img>
    <xsl:if test="$label">
      <div class="fig-label"><xsl:value-of select="$label"/></div>
    </xsl:if>
    <xsl:if test="caption">
      <div class="fig-caption caption">
        <xsl:apply-templates select="caption/node()"/>
      </div>
    </xsl:if>

  </div>
</xsl:template>

<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="graphic | inline-graphic">
    <xsl:apply-templates/>
    <img alt="{@xlink:href}">
      <xsl:for-each select="alt-text">
        <xsl:attribute name="alt">
          <xsl:value-of select="normalize-space(string(.))"/>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:call-template name="assign-src"/>
    </img>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="supplementary-material">
    <div class="panel">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates select="." mode="label"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="ext-link | uri | inline-supplementary-material">
    <a target="xrefwindow">
      <xsl:attribute name="href">
        <xsl:value-of select="."/>
      </xsl:attribute>
      <!-- if an @href is present, it overrides the href
           just attached -->
      <xsl:call-template name="assign-href"/>
      <xsl:call-template name="assign-id"/>
      <xsl:apply-templates/>
      <xsl:if test="not(normalize-space(string(.)))">
        <xsl:value-of select="@xlink:href"/>
      </xsl:if>
    </a>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fig" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-fig"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>Figure </xsl:text>
        <xsl:number level="any"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>



<!-- Display a thumbnail that links to a full-size figure page -->
<!-- This is the original match="fig" priority="2" -->
<xsl:template match="original-fig" priority="2">
  <div class="figure">
    <xsl:variable name="fig-id" select="@id"/>
    <xsl:variable name="img" select="graphic/@xlink:href"/>
    <xsl:variable name="label" select="normalize-space(label)"/>
    <xsl:variable name="caption" select="normalize-space(caption)"/>

    <!-- Create a thumbnail linking to the figure page -->
    <a href="{concat($fig-id, '.html')}" target="_blank">
      <img src="{$img}" alt="{$caption}" class="thumbnail" width="200"/>
    </a>

    <!-- Optional label below thumbnail -->
    <xsl:if test="$label">
      <div class="fig-label"><xsl:value-of select="$label"/></div>
    </xsl:if>
    
    <xsl:if test="caption">
      <div class="fig-caption caption">
        <!-- render caption *contents* without wrapping it in the global <div class="caption"> -->
        <xsl:apply-templates select="caption/node()"/>
      </div>
    </xsl:if>
  </div>
</xsl:template>

<!-- CHATGPT created this to provide a modified file name for the image which suits our needs -->
<!-- Helper: extract last segment after '/' -->
<xsl:template name="last-segment">
  <xsl:param name="path"/>
  <xsl:choose>
    <xsl:when test="contains($path, '/')">
      <xsl:call-template name="last-segment">
        <xsl:with-param name="path" select="substring-after($path, '/')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$path"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Return the substring after the last occurrence of $sep -->
<xsl:template name="after-last">
  <xsl:param name="s"/>
  <xsl:param name="sep" select="'.'"/>
  <xsl:choose>
    <xsl:when test="contains($s, $sep)">
      <xsl:call-template name="after-last">
        <xsl:with-param name="s" select="substring-after($s, $sep)"/>
        <xsl:with-param name="sep" select="$sep"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$s"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Strip only the final extension (if the dot is not the first char) -->
<xsl:template name="strip-last-extension">
  <xsl:param name="filename"/>

  <!-- Get what's after the last dot -->
  <xsl:variable name="ext">
    <xsl:call-template name="after-last">
      <xsl:with-param name="s" select="$filename"/>
      <xsl:with-param name="sep" select="'.'"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Position of the first dot -->
  <xsl:variable name="firstDot" select="string-length(substring-before($filename, '.')) + 1"/>

  <xsl:choose>
    <!-- No dot at all -->
    <xsl:when test="not(contains($filename, '.'))">
      <xsl:value-of select="$filename"/>
    </xsl:when>

    <!-- Dot is first character (dotfile): keep as-is -->
    <xsl:when test="$firstDot = 1">
      <xsl:value-of select="$filename"/>
    </xsl:when>

    <!-- Normal case: chop off '.' + last ext -->
    <xsl:otherwise>
      <xsl:variable name="cut"
        select="string-length($filename) - string-length($ext) - 1"/>
      <xsl:value-of select="substring($filename, 1, $cut)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Display a thumbnail linking to a full-size figure page -->
<xsl:template match="fig" priority="2"
              xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:variable name="fig-id" select="@id"/>
    <!-- first graphic/inline-graphic 
        count children named 'graphic' (no-ns): <xsl:value-of select="count(graphic)"/>&#10;
    -->

    <xsl:variable name="g" select="graphic[1]"/>

    <!-- prefer xlink:href, fallback to plain href (post-namespace-strip) -->
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
    <!-- img:<xsl:value-of select="$img"/> -->
    <!-- last-segment + strip-last-extension helpers assumed available -->
    <xsl:variable name="filename">
      <xsl:call-template name="last-segment">
        <xsl:with-param name="path" select="$img"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- filename:<xsl:value-of select="$filename"/> -->

    <xsl:variable name="basename">
      <xsl:call-template name="strip-last-extension">
        <xsl:with-param name="filename" select="$filename"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- basename:<xsl:value-of select="$basename"/> -->
    
    <xsl:variable name="label"   select="normalize-space(label)"/>
    <xsl:variable name="caption" select="normalize-space(caption)"/>
    
    <!-- 
    count children named 'graphic' (no-ns): <xsl:value-of select="count(graphic)"/>&#10;
    count by local-name(): <xsl:value-of select="count(*[local-name()='graphic'])"/>&#10;
    name() of the child: <xsl:value-of select="name(*[1])"/>
    fig_id:<xsl:value-of select="$fig-id"/>
    -->
  <div class="figure" id="{$fig-id}">
    <a href="{concat('../figs/',$xml-basename,'.',$fig-id, '.html')}">
      <img src="{concat('../thumbs/', $basename, '.jpg')}"
           alt="{$caption}" class="thumbnail" width="200"/>
    </a>
    <xsl:if test="$label">
      <div class="fig-label"><xsl:value-of select="$label"/></div>
    </xsl:if>

    <xsl:if test="caption">
      <div class="fig-caption caption">
        <xsl:apply-templates select="caption/node()"/>
      </div>
    </xsl:if>
  </div>
</xsl:template>


<!-- CHATGPT solution ends here -->


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn/@fn-type[. = 'supplementary-material']" priority="2">
    <span class="generated"> Supplementary material</span>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="supplementary-material" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-supplementary"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>Supplementary Material </xsl:text>
        <xsl:number level="any" format="A" count="supplementary-material[not(ancestor::front)]"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


<!-- Generate standalone figure pages -->
<xsl:template match="fig" mode="full-figure" priority="2">
    <xsl:variable name="fig-id" select="@id"/>
    <xsl:variable name="g" select="graphic[1]"/>
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
    <xsl:variable name="label"   select="normalize-space(label)"/>
    <xsl:variable name="caption" select="normalize-space(caption)"/>


  <html>
    <head>
      <title>
        <xsl:value-of select="concat(normalize-space(label), ': ', normalize-space(caption))"/>
      </title>
        <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8" />
        <link rel="stylesheet" type="text/css" href="../../../global.css" />
        <meta name="parent-file" content="../html/.htm" />
        <script type="text/javascript" src="http://archives.datapages.com/data/aapg-scripts/mathjax.js">
        </script>
    </head>
    <body>
      <h2><xsl:value-of select="label"/></h2>

      <img src="{concat('../figs/', $basename, '.jpg')}" alt="{caption/p}" style="border: 0; margin: 10px 0; max-width: 100%; height: auto; " />
      <div class="caption">
        <xsl:apply-templates select="caption"/>
      </div>
      <p><a href="{concat('../html/',$xml-basename, '.html','#',$fig-id)}">Back to article</a></p>
    </body>
  </html>
</xsl:template>
  
  
  
</xsl:stylesheet>
