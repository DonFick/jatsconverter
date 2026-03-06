<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" xsl="http://www.w3.org/1999/XSL/Transform" xlink="http://www.w3.org/1999/xlink" mml="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="xlink mml">
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="front | front-stub" mode="metadata">

    <!-- change context to front/article-meta (again) -->
    <xsl:for-each select="article-meta | self::front-stub">
      
      <xsl:call-template name="cjspdf-link">
        <!-- handles uri xlink -->
      </xsl:call-template>
      <CJSVOLINFO>
      <p class="volinfo">
        <xsl:variable name="journal">
          <xsl:value-of select="/article/front/journal-meta/journal-title-group/journal-title[1]"/>
        </xsl:variable>
        <CJSPUBTITLE><xsl:value-of select="$journal"/></CJSPUBTITLE><br/>
        <xsl:call-template name="cjsvolume-info">
          <!-- handles volume?, volume-id*, volume-series? -->
        </xsl:call-template>
        (<CJSYEAR><xsl:call-template name="safe-year">
            <xsl:with-param name="date" select="pub-date"/>
        </xsl:call-template></CJSYEAR>), <xsl:call-template name="cjsissue-info">
          <!-- handles volume?, volume-id*, volume-series? -->
        </xsl:call-template> (<xsl:call-template name="safe-month-name">
          <xsl:with-param name="date" select="pub-date"/>
        </xsl:call-template>), <CJSPAGES><xsl:call-template name="cjspage-info">
          <!-- handles (fpage, lpage?, page-range?) -->
        </xsl:call-template></CJSPAGES>
        <xsl:call-template name="cjs-doi-link"/>
      </p>
      </CJSVOLINFO>
      
        <!-- we removed this for Sandra Nov 2025
            xsl:call-template name="cjs-conference-block"
        -->
        
      <CJSTITLE>
        <xsl:apply-templates select="title-group" mode="metadata"/>
      </CJSTITLE>
      <!-- contrib-group, aff, aff-alternatives, author-notes -->
      <xsl:apply-templates mode="metadata" select="contrib-group | author-notes"/>
      <!-- Manuscript history (Received/Accepted) below affiliations -->
      <xsl:call-template name="cjs-manuscript-history"/>
    </xsl:for-each>


    <xsl:for-each select="notes">
      <div class="metadata">
        <xsl:apply-templates mode="metadata" select="."/>
      </div>
    </xsl:for-each>

    <!-- end of big front-matter pull -->

    <!-- start AAPG article front matter -->
    <xsl:for-each select="article-meta | self::front-stub">

      <!-- Add abstracts here -->
      <xsl:for-each select="abstract | trans-abstract">
        <xsl:call-template name="make-abstract"/>
      </xsl:for-each>

      <!--
        <p class="header">
            <cjscopyright>Copyright ©2025. The American Association of Petroleum Geologists. All rights reserved.</cjscopyright>
        </p>
        <p>
            DOI: 10.1306/04292522159
        </p>
        <h2 class="ati">
            <cjstitle>Insights on fracture and karst cavern origin and diagenesis from core observations at Tengiz and Korolev fields, Kazakhstan</cjstitle>
        </h2>
        <h3 class="authgrp">
            <cjsauthor>Ted Playton,<sup><a href="#bio1">1</a></sup> Evan Earnest,<sup><a href="#bio2">2</a></sup> Ferm&#x00ED;n Fern&#x00E1;ndez-Ib&#x00E1;&#x00F1;ez,<sup><a href="#bio3">3</a></sup> Assem Bibolova,<sup><a href="#bio4">4</a></sup> Dana Tolessin,<sup><a href="#bio5">5</a></sup> Ilyas Tussupbayev,<sup><a href="#bio6">6</a></sup> and Bagdat Toleubay<sup><a href="#bio7">7</a></sup></cjsauthor>
        </h3>
        <p class="affils">
            <sup>1</sup>Chevron Americas Exploration, Houston, Texas; <a href="mailto:tedplayton@chevron.com">tedplayton@chevron.com</a><br />
            <sup>2</sup>Chevron Technology Center, Houston, Texas; <a href="mailto:evan.earnestheckler@chevron.com">evan.earnestheckler@chevron.com</a><br />
            <sup>3</sup>Subsurface Alliance LLC, Katy, Texas; <a href="mailto:fermin.fernandez.ibanez@subsurfacealliance.com">fermin.fernandez.ibanez@subsurfacealliance.com</a><br />
            <sup>4</sup>Tengizchevroil (TCO), Atyrau, Kazakhstan; <a href="mailto:dzqp@tengizchevroil.com">dzqp@tengizchevroil.com</a><br />
            <sup>5</sup>TCO, Atyrau, Kazakhstan; <a href="mailto:dana.tolessin@tengizchevroil.com">dana.tolessin@tengizchevroil.com</a><br />
            <sup>6</sup>TCO, Atyrau, Kazakhstan; <a href="mailto:ilyas.tussupbayev@chevron.com">ilyas.tussupbayev@chevron.com</a><br />
            <sup>7</sup>TCO, Atyrau, Kazakhstan; <a href="mailto:buyf@tengizchevroil.com">buyf@tengizchevroil.com</a>
        </p>
        <h2 class="abstractti">
            ABSTRACT
        </h2>
        <cjsabstract>
        <p class="abstractnoin">
            Tengiz and Korolev fields are giant, isolated carbonate platform reservoirs located in western Kazakhstan. Oil production in large regions of these fields is dominated by naturally formed fracture and karst cavern networks (i.e., nonmatrix). These networks around the fields are chiefly characterized using static logs, drilling data, and dynamic data from surveillance, as these data sets provide the most complete coverage through the three-dimensional reservoir volume. Core data sets, although significantly less in reservoir coverage, contain valuable ground truth information about the nonmatrix system that can be integrated into log-based interpretations. This study uses the extensive core data set available from Tengiz and Korolev to better understand the genetic origins, spatial distributions, and diagenetic evolution of the fracture–karst networks around the fields.
        </p>
        <p class="abstractnoin">
            Documentation of Tengiz and Korolev natural fractures in core confirms the presence of both diagenetically early (syndepositional) and late (burial) fractures and reveals significant differences in their spatial distributions and attributes. Evidence in cored intervals adjacent to open karst caverns supports both early meteoric and late burial origins of karst cavern networks and supplement the largely log-based characterization. Core also reveals that the lower slope at Tengiz, a historically underperforming reservoir region, has comparable fracture presence to more productive regions, but was preferentially impacted by late-stage burial cementation that degraded fracture and karst network flow properties. These findings, only available from core, allowed for development of conceptual diagenetic models of the nonmatrix system and refinement of dynamic reservoir regions that link to production performance and provide inputs for reservoir modeling.
        </p>
        </cjsabstract> 
        -->
    </xsl:for-each>
  </xsl:template>

<!-- Conference info block printed after CJSVOLINFO -->
<xsl:template name="cjs-conference-block">
  <!-- Collect all <conference> nodes under front/article-meta (namespace-agnostic) -->
  <xsl:variable name="confs"
    select="/*[local-name()='article']/*[local-name()='front']/*[local-name()='article-meta']/*[local-name()='conference']"/>
  <xsl:if test="count($confs) &gt; 0">
    <CJSCONFINFO>
      <p class="confinfo">
        <xsl:for-each select="$confs">
          <!-- line-break between entries, not before the first -->
          <xsl:if test="position() &gt; 1"><br/></xsl:if>
          <xsl:if test="position() &lt; 3">
              <xsl:call-template name="cjs-render-conference-item"/>
          </xsl:if>
        </xsl:for-each>
      </p>
    </CJSCONFINFO>
  </xsl:if>
</xsl:template>

<!-- Render a single <conference> entry on one line -->
<xsl:template name="cjs-render-conference-item">
  <!-- Optional: show the content-type label as a small token -->
  <xsl:if test="@content-type">
<!-- Remove the label based on attribute
    <span class="conftype">
      <xsl:value-of select="@content-type"/>
    </span>
    <xsl:text>: </xsl:text>
 -->
  </xsl:if>

  <!-- Name (required-ish) -->
  <xsl:if test="*[local-name()='conf-name']">
    <span class="confname">
      <xsl:value-of select="normalize-space(*[local-name()='conf-name'][1])"/>
    </span>
  </xsl:if>

  <!-- Acronym in parens, if present -->
  <xsl:if test="*[local-name()='conf-acronym']">
    <xsl:text> (</xsl:text>
    <span class="confacronym">
      <xsl:value-of select="normalize-space(*[local-name()='conf-acronym'][1])"/>
    </span>
    <xsl:text>)</xsl:text>
  </xsl:if>

  <!-- Conference number -->
  <xsl:if test="*[local-name()='conf-num']">
    <xsl:text>; No. </xsl:text>
    <span class="confnum">
      <xsl:value-of select="normalize-space(*[local-name()='conf-num'][1])"/>
    </span>
  </xsl:if>

  <!-- Date (supports structured and unstructured conf-date) -->
  <xsl:variable name="cdate" select="*[local-name()='conf-date'][1]"/>
  <xsl:if test="$cdate">
    <xsl:text>; </xsl:text>
    <span class="confdate">
      <xsl:call-template name="cjs-conf-date">
        <xsl:with-param name="node" select="$cdate"/>
      </xsl:call-template>
    </span>
  </xsl:if>

  <!-- Location -->
  <xsl:if test="*[local-name()='conf-loc']">
    <xsl:text>; </xsl:text>
    <span class="confloc">
      <xsl:value-of select="normalize-space(*[local-name()='conf-loc'][1])"/>
    </span>
  </xsl:if>
</xsl:template>

<!-- Date formatter for <conf-date> -->
<xsl:template name="cjs-conf-date">
  <xsl:param name="node"/>
  <xsl:choose>
    <!-- Structured y/m/d elements -->
    <xsl:when test="$node/*[local-name()='year']">
      <xsl:variable name="y" select="normalize-space($node/*[local-name()='year'][1])"/>
      <xsl:variable name="m" select="normalize-space($node/*[local-name()='month'][1])"/>
      <xsl:variable name="d" select="normalize-space($node/*[local-name()='day'][1])"/>
      <xsl:choose>
        <xsl:when test="$y and $m and $d">
          <xsl:value-of select="$y"/><xsl:text>-</xsl:text><xsl:value-of select="$m"/><xsl:text>-</xsl:text><xsl:value-of select="$d"/>
        </xsl:when>
        <xsl:when test="$y and $m">
          <xsl:value-of select="$y"/><xsl:text>-</xsl:text><xsl:value-of select="$m"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$y"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- Unstructured (text inside <conf-date>) -->
    <xsl:otherwise>
      <xsl:value-of select="normalize-space(string($node))"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="journal-title-group" mode="metadata">
    <xsl:apply-templates mode="metadata"/>
  </xsl:template>



  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="trans-title-group" mode="metadata">
    <xsl:apply-templates mode="metadata"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="pub-date" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Publication date</xsl:text>
        <xsl:call-template name="append-pub-type"/>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:call-template name="format-date"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="pub-date" mode="article-front">
    <xsl:call-template name="cjsmetadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Publication date</xsl:text>
        <xsl:call-template name="append-pub-type"/>
      </xsl:with-param>
      <xsl:with-param name="cjstag">cjsvolume</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:call-template name="format-date"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="title-group" mode="metadata">
    <!-- content model:
    article-title, subtitle*, trans-title-group*, alt-title*, fn-group? -->
    <!-- trans-title and trans-subtitle included for 2.3 -->
    <xsl:apply-templates select="         article-title | subtitle | trans-title-group |         trans-title | trans-subtitle" mode="metadata"/>
    <xsl:if test="alt-title | fn-group">
      <div class="document-title-notes metadata-group">
        <xsl:apply-templates select="alt-title | fn-group" mode="metadata"/>
      </div>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="title-group/article-title" mode="metadata">
    <h1 class="title">
      <xsl:apply-templates/>
      <xsl:if test="../subtitle">:</xsl:if>
    </h1>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="title-group/subtitle | trans-title-group/subtitle" mode="metadata">
    <h2 class="document-title">
      <xsl:apply-templates/>
    </h2>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="title-group/trans-title-group" mode="metadata">
    <!-- content model: (trans-title, trans-subtitle*) -->
    <xsl:apply-templates mode="metadata"/>
  </xsl:template>



  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="title-group/alt-title" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Alternative title</xsl:text>
        <xsl:for-each select="@alt-title-type">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="title-group/fn-group" mode="metadata">
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" mode="metadata" match="journal-meta/contrib-group">
    <xsl:for-each select="contrib">
      <xsl:variable name="contrib-identification">
        <xsl:call-template name="contrib-identify"/>
      </xsl:variable>
      <!-- placing the div only if it has content -->
      <!-- the extra call to string() makes it type-safe in a type-aware
           XSLT 2.0 engine -->
      <xsl:if test="normalize-space(string($contrib-identification))">
        <xsl:copy-of select="$contrib-identification"/>
      </xsl:if>
      <xsl:variable name="contrib-info">
        <xsl:call-template name="contrib-info"/>
      </xsl:variable>
      <!-- placing the div only if it has content -->
      <xsl:if test="normalize-space(string($contrib-info))">
        <xsl:copy-of select="$contrib-info"/>
      </xsl:if>
    </xsl:for-each>

    <xsl:if test="*[not(self::contrib | self::xref)]">

      <xsl:apply-templates mode="metadata" select="*[not(self::contrib | self::xref)]"/>

    </xsl:if>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" mode="metadata" match="article-meta/contrib-group">
    <!-- content model of contrib-group:
        (contrib+, 
        (address | aff | author-comment | bio | email |
        ext-link | on-behalf-of | role | uri | xref)*) -->
    <!-- each contrib makes a row: name at left, details at right -->
    <xsl:for-each select="contrib">
      <!--  content model of contrib:
          ((contrib-id)*,
           (anonymous | collab | collab-alternatives | name | name-alternatives)*,
           (degrees)*,
           (address | aff | aff-alternatives | author-comment | bio | email |
            ext-link | on-behalf-of | role | uri | xref)*)       -->

      <xsl:call-template name="contrib-identify">
              <!-- handles (contrib-id)*,
                (anonymous | collab | collab-alternatives |
                 name | name-alternatives | degrees | xref) -->
            </xsl:call-template>

      <xsl:call-template name="contrib-info">
              <!-- handles
                   (address | aff | author-comment | bio | email |
                    ext-link | on-behalf-of | role | uri) -->
            </xsl:call-template>
    </xsl:for-each>
    <!-- end of contrib -->
    <xsl:variable name="misc-contrib-data" select="*[not(self::contrib | self::xref)]"/>
    <xsl:if test="$misc-contrib-data">
            <xsl:apply-templates mode="metadata" select="$misc-contrib-data"/>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="sec-meta/contrib-group">
    <xsl:apply-templates mode="metadata"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="sec-meta/kwd-group">
    <!-- matches only if contrib-group has only contrib children -->
    <xsl:apply-templates select="." mode="metadata"/>
  </xsl:template>



  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="main-title" match="       abstract/title | body/*/title |       back/title | back[not(title)]/*/title">
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <xsl:if test="normalize-space(string($contents))">
      <!-- coding defensively since empty titles make glitchy HTML -->
      <h2 class="sectiontitle">
        <xsl:copy-of select="$contents"/>
      </h2>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="section-title" match="       abstract/*/title | body/*/*/title |       back[title]/*/title | back[not(title)]/*/*/title">
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <xsl:if test="normalize-space(string($contents))">
      <!-- coding defensively since empty titles make glitchy HTML -->
      <h3 class="section-title">
        <xsl:copy-of select="$contents"/>
      </h3>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="subsection-title" match="       abstract/*/*/title | body/*/*/*/title |       back[title]/*/*/title | back[not(title)]/*/*/*/title">
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <xsl:if test="normalize-space(string($contents))">
      <!-- coding defensively since empty titles make glitchy HTML -->
      <h4 class="subsection-title">
        <xsl:copy-of select="$contents"/>
      </h4>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="block-title" priority="2" match="       list/title | def-list/title | boxed-text/title |       verse-group/title | glossary/title | gloss-group/title | kwd-group/title">
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <xsl:if test="normalize-space(string($contents))">
      <!-- coding defensively since empty titles make glitchy HTML -->
      <h4 class="block-title">
        <xsl:copy-of select="$contents"/>
      </h4>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="front//fn" mode="label-text">
    <xsl:param name="warning" select="boolean(key('xref-by-rid', @id))"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels);
         by default, we get a warning only if we need a label for
         a cross-reference -->
    <!-- auto-number-fn is true only if (1) this fn is cross-referenced, and
         (2) there exists inside the front matter any fn elements with
         cross-references, but not labels or @symbols. -->
    <xsl:param name="auto-number-fn" select="         boolean(key('xref-by-rid', parent::fn/@id)) and         boolean(ancestor::front//fn[key('xref-by-rid', @id)][not(label | @symbol)])"/>
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-number-fn"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:number level="any" count="fn" from="front" format="a"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="pub-date" mode="month-only">
    <xsl:call-template name="safe-month-name">
      <xsl:with-param name="date" select="."/>
    </xsl:call-template>
  </xsl:template>


<!-- Overrides added after modularization -->
<!-- Render the author block like the target CJSAUTHOR -->
<!-- Authors with labels; commas ONLY separate authors (Oxford rules) -->
<xsl:template match="contrib-group" mode="metadata" priority="4">
  <CJSAUTHOR>
    <p class="author">
      <xsl:for-each select="contrib[@contrib-type='author']">
        <span class="nobr">
          <!-- Name -->
          <xsl:call-template name="cjs-render-person-name"/>

          <!-- Affiliation labels (no comma before or between labels) -->
          <xsl:variable name="affx" select="xref[@ref-type='aff']"/>
          <xsl:if test="count($affx) &gt; 0">
            <span class="autref">
              <xsl:for-each select="$affx">
                <xsl:if test="position() &gt; 1">
                  <!-- optional thin separator; no comma -->
                  <xsl:text> </xsl:text>
                </xsl:if>

                <!-- Resolve target <aff> -->
                <xsl:variable name="aff" select="key('element-by-id', @rid)[1]"/>
                <xsl:variable name="lab" select="normalize-space(string($aff/label[1]))"/>

                <a href="#{@rid}">
                  <xsl:choose>
                    <!-- Case 1: explicit <label> in <aff> (e.g., IPA '*') -->
                    <xsl:when test="$lab != ''">
                      <xsl:value-of select="$lab"/>
                    </xsl:when>

                    <!-- Case 2: no <label> → generate a number from <aff> position -->
                    <xsl:otherwise>
                      <!-- Number based on order of <aff> in article-meta -->
                      <xsl:for-each select="$aff">
                        <xsl:number level="any"
                                    from="article-meta"
                                    count="aff"/>
                      </xsl:for-each>
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
              </xsl:for-each>

              <!-- Corresponding-author marker (aligned with affiliation labels) -->
              <xsl:variable name="corx" select="xref[@ref-type='corresp'][1]"/>
              <xsl:if test="@corresp='yes' or $corx">
                <span class="corresp">
                  <xsl:choose>
                    <xsl:when test="$corx">
                      <a href="#{$corx/@rid}">
                        <xsl:value-of select="normalize-space(string($corx))"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>*</xsl:otherwise>
                  </xsl:choose>
                </span>
              </xsl:if>
            </span>
          </xsl:if>
        </span>

        <!-- Author separators (AFTER labels). Commas ONLY here. -->
        <xsl:choose>
          <xsl:when test="position() = last()"/>
          <xsl:when test="position() = last() - 1">
            <xsl:choose>
              <xsl:when test="last() &gt; 2">
                <xsl:text>, and </xsl:text> <!-- Oxford comma -->
              </xsl:when>
              <xsl:otherwise>
                <xsl:text> and </xsl:text>  <!-- exactly two authors -->
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>, </xsl:text>        <!-- early authors -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </p>
  </CJSAUTHOR>

  <!-- After printing authors, render affiliations. Handle both:
       1) <contrib-group><aff>… (IPA)
       2) <contrib-group>…</contrib-group><aff>… (GeoGulf) -->
  <div class="affiliations">
    <xsl:apply-templates select="aff | ../aff" mode="metadata"/>
  </div>

</xsl:template>




<!-- Person-name helper -->
<xsl:template name="cjs-render-person-name">
  <xsl:choose>
    <xsl:when test="name">
      <!-- Given + space + Surname (matches target) -->
      <xsl:value-of select="normalize-space(name/given-names)"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="normalize-space(name/surname)"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- Fallback if <name> is absent -->
      <xsl:value-of select="normalize-space(string(.))"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- Manuscript history block (below affiliations) -->
<xsl:template name="cjs-manuscript-history">
  <!-- history is typically a child of article-meta -->
<xsl:variable name="am" select="ancestor-or-self::article-meta[1]"/>
<xsl:variable name="received" select="$am/history/date[@date-type='received'][1]"/>
<xsl:variable name="accepted" select="$am/history/date[@date-type='accepted'][1]"/>

  <xsl:if test="$received or $accepted">
    <div class="manuscript-history affiliations">
      <xsl:if test="$received">
        <div class="history-received">
          <xsl:text>Received </xsl:text>
          <xsl:call-template name="cjs-format-history-date">
            <xsl:with-param name="d" select="$received"/>
          </xsl:call-template>
          <xsl:text>.</xsl:text>
        </div>
      </xsl:if>

      <xsl:if test="$accepted">
        <div class="history-accepted">
          <xsl:text>Accepted </xsl:text>
          <xsl:call-template name="cjs-format-history-date">
            <xsl:with-param name="d" select="$accepted"/>
          </xsl:call-template>
          <xsl:text>.</xsl:text>
        </div>
      </xsl:if>
    </div>
  </xsl:if>
</xsl:template>

<!-- Format a JATS <date> with <day><month><year> as: Month dd, yyyy -->
<xsl:template name="cjs-format-history-date">
  <xsl:param name="d"/>

  <xsl:call-template name="safe-month-name">
    <xsl:with-param name="date" select="$d"/>
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:value-of select="number($d/day)"/>
  <xsl:text>, </xsl:text>
  <xsl:value-of select="normalize-space($d/year)"/>
</xsl:template>

</xsl:stylesheet>
