<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" xsl="http://www.w3.org/1999/XSL/Transform" xlink="http://www.w3.org/1999/xlink" mml="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="xlink mml">

<!-- Put this in your driver (e.g., main.xsl or site/output-frame.xsl) -->
<!-- Root controller: handles normal article or single figure page -->

<xsl:template match="/">
  <xsl:choose>
    <!-- If figure-id is passed, render that figure page -->
    <xsl:when test="string-length($figure-id) &gt; 0">
      <xsl:variable name="target" select="//fig[@id=$figure-id][1]"/>
      <xsl:choose>
        <xsl:when test="$target">
          <xsl:apply-templates select="$target" mode="full-figure"/>
        </xsl:when>
        <xsl:otherwise>
          <html><body>
            <p>Figure with @id='<xsl:value-of select="$figure-id"/>' not found.</p>
          </body></html>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <!-- Otherwise render the full article as usual -->
    <xsl:otherwise>
        <html>
          <xsl:call-template name="make-html-header"/>
          <body>
            <xsl:apply-templates/>
          </body>
        </html>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- 
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="/">
    <html>
      <xsl:call-template name="make-html-header"/>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>


<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="/">
      <xsl:apply-templates select="//fig[@id=f1]" mode="full-figure"/>
</xsl:template>
 -->
  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="make-html-header">
    <head>
      <title>
        <!-- 
        <xsl:variable name="authors">
          <xsl:call-template name="author-string"/>
        </xsl:variable>
        <xsl:value-of select="normalize-space(string($authors))"/>
        <xsl:if test="normalize-space(string($authors))">: </xsl:if>
 -->
        <xsl:value-of select="/article/front/article-meta/title-group/article-title[1]"/>
      </title>
      <meta http-equiv="content-type" content="text/html;charset=utf-8"/>
      <link rel="stylesheet" type="text/css" href="/data/aapg-styles/global.css"/>
      <link rel="stylesheet" type="text/css" href="/data/aapg-styles/jats-preview.css"/>
      <script type="text/javascript" src="http://archives.datapages.com/data/aapg-scripts/mathjax.js"> <!-- --></script>
      <xsl:variable name="journal">
        <xsl:value-of select="/article/front/journal-meta/journal-title[1]"/>
      </xsl:variable>
      <xsl:if test="string-length($journal)">
        <meta name="citation_journal_title" content="{$journal}"/>
      </xsl:if>
      <link rel="stylesheet" type="text/css" href="{$css}"/>
    </head>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="make-article">
    <!-- Generates a series of (flattened) divs for contents of any
	       article, sub-article or response -->

    <!-- variable to be used in div id's to keep them unique -->
    <xsl:variable name="this-article">
      <xsl:apply-templates select="." mode="id"/>
    </xsl:variable>

    <div id="{$this-article}-front" class="front">
      <xsl:apply-templates select="front | front-stub" mode="metadata"/>
    </div>
 
    
    <!-- body -->
    <CJSTEXT>
    <xsl:for-each select="body">
      <div id="{$this-article}-body" class="body">
        <xsl:apply-templates/>
      </div>
    </xsl:for-each>
    </CJSTEXT>
    
    <xsl:if test="back | $loose-footnotes">
      <!-- $loose-footnotes is defined below as any footnotes outside
           front matter or fn-group -->
      <div id="{$this-article}-back" class="back">
        <xsl:call-template name="make-back"/>
      </div>
    </xsl:if>

    <xsl:for-each select="floats-group | floats-wrap">
      <!-- floats-wrap is from 2.3 -->
      <div id="{$this-article}-floats" class="back">
        <xsl:call-template name="main-title">
          <xsl:with-param name="contents">
            <span class="generated">Floating objects</span>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates/>
      </div>
    </xsl:for-each>

    <!-- more metadata goes in the footer -->
    <div id="{$this-article}-footer" class="article-footer">
    
    <!-- Only show the combined heading if something exists -->
      <xsl:variable name="has-ack" select="boolean(ack[normalize-space(.)!=''])"/>
      <xsl:variable name="has-fn"  select="boolean(fn-group|fn[normalize-space(.)!=''])"/>
      <xsl:variable name="has-notes" select="boolean(notes[normalize-space(.)!=''])"/>
      <xsl:if test="$has-ack or $has-fn or $has-notes">
          <xsl:call-template name="footer-metadata"/>
      </xsl:if>
      <xsl:call-template name="footer-branding"/>
    </div>

    <!-- sub-article or response (recursively calls
		     this template) -->
    <xsl:apply-templates select="sub-article | response"/>

  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="/" mode="xpath"/>


  
</xsl:stylesheet>
