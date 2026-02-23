<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" xsl="http://www.w3.org/1999/XSL/Transform" xlink="http://www.w3.org/1999/xlink" mml="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="xlink mml">
<!-- 

  <xsl:output doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd" encoding="UTF-8"/>
 -->

<!-- 

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1 plus MathML 2.0//EN" "http://www.w3.org/Math/DTD/mathml2/xhtml-math11-f.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 -->

  
<!-- Space is preserved in all elements allowing #PCDATA -->
  
<!-- <xsl:param name="css" select="'jats-preview.css'"/> -->
  
<xsl:variable xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="verbose" select="$report-warnings = 'yes'"/>

  
<!-- Keys -->

  
<!-- To reduce dependency on a DTD for processing, we declare
       a key to use instead of the id() function. -->
  
<!-- Enabling retrieval of cross-references to objects -->
  
<!-- ============================================================= -->
  
<!--  ROOT TEMPLATE - HANDLES HTML FRAMEWORK                       -->
  
<!-- ============================================================= -->

  
<!-- ============================================================= -->
  
<!--  TOP LEVEL                                                    -->
  
<!-- ============================================================= -->

  
<!--
      content model for article:
         (front,body?,back?,floats-group?,(sub-article*|response*))
      
      content model for sub-article:
         ((front|front-stub),body?,back?,floats-group?,
          (sub-article*|response*))
      
      content model for response:
         ((front|front-stub),body?,back?,floats-group?) 
  -->


<!-- 
  <div id="{$this-article}-abstract" class="abstract">
    <xsl:apply-templates select="front | front-stub" mode="abstract"/>
  </div>

  
  <xsl:template match="front | front-stub" mode="abstract">
    <xsl:call-template name="make-abstract"/>
  </xsl:template>

  
  <xsl:template match="/article/front/article-meta">
    <xsl:for-each select="abstract | trans-abstract">
      xxx-
      <xsl:value-of select="title"/>
      <xsl:call-template name="make-abstract" />
    </xsl:for-each>
  </xsl:template>
 --> 

  
<!-- ============================================================= -->
  
<!--  "make-article" for the document architecture                 -->
  
<!-- ============================================================= -->

  
<!-- ============================================================= -->
  
<!--  "front" and "front-stub" for metadata                        -->
  
<!-- ============================================================= -->

  
<!-- ============================================================= -->

  
<!-- ============================================================= -->
  
<!--  METADATA PROCESSING                                          -->
  
<!-- ============================================================= -->

  
<!--  Includes mode "metadata" for front matter, along with 
      "metadata-inline" for metadata elements collapsed into 
      inline sequences, plus associated named templates            -->

  
<!-- WAS journal-meta content:
       journal-id+, journal-title-group*, issn+, isbn*, publisher?,
       notes? -->
  
<!-- (journal-id+, journal-title-group*, (contrib-group | aff | aff-alternatives)*,
       issn+, issn-l?, isbn*, publisher?, notes*, self-uri*) -->
  
<!-- journal-title-group content:
       (journal-title*, journal-subtitle*, trans-title-group*,
       abbrev-journal-title*) -->

  
<!-- trans-title-group content: (trans-title, trans-subtitle*) -->

  
<!-- article-meta content:
    (article-id*, article-categories?, title-group,
     (contrib-group | aff)*, author-notes?, pub-date+, volume?,
     volume-id*, volume-series?, issue?, issue-id*, 
     issue-title*, issue-sponsor*, issue-part?, isbn*, 
     supplement?, ((fpage, lpage?, page-range?) | elocation-id)?, 
     (email | ext-link | uri | product | supplementary-material)*, 
     history?, permissions?, self-uri*, related-article*,
     abstract*, trans-abstract*, 
     kwd-group*, funding-group*, conference*, counts?, 
     custom-meta-group?) -->

  
<!-- In order of appearance... -->

  
<!-- isbn is already matched in mode 'metadata' above -->

  
<!-- ============================================================= -->
  
<!--  REGULAR (DEFAULT) MODE                                       -->
  
<!-- ============================================================= -->

  
<!-- abstract(s) -->
  
<!-- end of dealing with abstracts -->
  
  
  
<!-- ============================================================= -->
  
<!--  Titles                                                       -->
  
<!-- ============================================================= -->

  
<!-- default: any other titles found -->
  
<!-- ============================================================= -->
  
<!--  Figures, lists and block-level objectS                       -->
  
<!-- ============================================================= -->


  
<!-- ============================================================= -->
  
<!--  TABLES                                                       -->
  
<!-- ============================================================= -->
  
<!--  Tables are already in XHTML, and can simply be copied
        through                                                      -->


  
<!-- ============================================================= -->
  
<!--  INLINE MISCELLANEOUS                                         -->
  
<!-- ============================================================= -->
  
<!--  Templates strictly for formatting follow; these are templates
        to handle various inline structures -->


  
<!-- inline-graphic is handled above, with graphic -->


  
<!-- preformat is handled above -->

  
<!-- ============================================================= -->
  
<!--  Formatting elements                                          -->
  
<!-- ============================================================= -->


  
<!-- ============================================================= -->
  
<!--  BACK MATTER                                                  -->
  
<!-- ============================================================= -->


  
<xsl:variable xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="loose-footnotes" select="//fn[not(ancestor::front | parent::fn-group | ancestor::table-wrap)]"/>


  
<!-- ============================================================= -->
  
<!--  FOOTNOTES                                                    -->
  
<!-- ============================================================= -->

  
<!-- ============================================================= -->
  
<!--  MODE 'label-text'
	      Generates label text for elements and their cross-references -->
  
<!-- ============================================================= -->
  
<!--  This mode is to support auto-numbering and generating of
        labels for certain elements by the stylesheet.
  
        The logic is as follows: for any such element type, if a
        'label' element is ever present, it is expected always to be 
        present; automatic numbering is not performed on any elements
        of that type. For example, the presence of a 'label' element 
        in any 'fig' is taken to indicate that all figs should likewise
        be labeled, and any 'fig' without a label is supposed to be 
        unlabelled (and unnumbered). But if no 'fig' elements have 
        'label' children, labels with numbers are generated for all 
        figs in display.
        
        This logic applies to:
          app, boxed-text, chem-struct-wrap, disp-formula, fig, fn, 
          note, ref, statement, table-wrap.
        
        There is one exception in the case of fn elements, where
        the checking for labels (or for @symbol attributes in the
        case of this element) is performed only within its parent
        fn-group, or in the scope of all fn elements not in an
        fn-group, for fn elements appearing outside fn-group.
        
        In all cases, this logic can be altered simply by overwriting 
        templates in "label" mode for any of these elements.
        
        For other elements, a label is simply displayed if present,
        and auto-numbering is never performed.
        These elements include:
          (label appearing in line) aff, corresp, chem-struct, 
          element-citation, mixed-citation
          
          (label appearing as a block) abstract, ack, app-group, 
          author-notes, back, bio, def-list, disp-formula-group, 
          disp-quote, fn-group, glossary, graphic, kwd-group, 
          list, list-item, media, notes, ref-list, sec, 
          supplementary-material, table-wrap-group, 
          trans-abstract, verse-group -->


  
<xsl:variable xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="auto-label-app" select="false()"/>
  
<xsl:variable xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="auto-label-boxed-text" select="false()"/>
  
<xsl:variable xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="auto-label-chem-struct-wrap" select="false()"/>
  
<xsl:variable xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="auto-label-disp-formula" select="false()"/>
  
<xsl:variable xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="auto-label-fig" select="false()"/>
  
<!-- <xsl:variable name="auto-label-ref" select="not(//ref[label])"/> -->
  
<!-- ref elements are labeled unless any ref already has a label -->
  
<xsl:variable xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="auto-label-ref" select="true()"/>
  
  
<xsl:variable xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="auto-label-statement" select="false()"/>
  
<xsl:variable xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="auto-label-supplementary" select="false()"/>
  
<xsl:variable xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="auto-label-table-wrap" select="false()"/>

  
<!--
  These variables assignments show how autolabeling can be 
  configured conditionally.
  For example: "label figures if no figures have labels" translates to
    "not(//fig[label])", which will resolve to Boolean true() when the set of
    all fig elements with labels is empty.
  
  <xsl:variable name="auto-label-app" select="not(//app[label])"/>
  <xsl:variable name="auto-label-boxed-text" select="not(//boxed-text[label])"/>
  <xsl:variable name="auto-label-chem-struct-wrap" select="not(//chem-struct-wrap[label])"/>
  <xsl:variable name="auto-label-disp-formula" select="not(//disp-formula[label])"/>
  <xsl:variable name="auto-label-fig" select="not(//fig[label])"/>
  <xsl:variable name="auto-label-ref" select="not(//ref[label])"/>
  <xsl:variable name="auto-label-statement" select="not(//statement[label])"/>
  <xsl:variable name="auto-label-supplementary"
    select="not(//supplementary-material[not(ancestor::front)][label])"/>
  <xsl:variable name="auto-label-table-wrap" select="not(//table-wrap[label])"/>
-->

  
<!-- Provide a label for <bio> targets so empty <xref> links have text -->
  
<!-- ============================================================= -->
  
<!--  Writing a name                                               -->
  
<!-- ============================================================= -->

  
<!-- Called when displaying structured names in metadata         -->

  
<!-- string-name elements are written as is -->

  
<!-- ============================================================= -->
  
<!--  UTILITY TEMPLATES                                           -->
  
<!-- ============================================================= -->


  
<!-- ============================================================= -->
  
<!--  Process warnings                                             -->
  
<!-- ============================================================= -->
  
<!-- Generates a list of warnings to be reported due to processing
     anomalies. -->

  
<!-- ============================================================= -->
  
<!--  id mode                                                      -->
  
<!-- ============================================================= -->
  
<!-- An id can be derived for any element. If an @id is given,
     it is presumed unique and copied. If not, one is generated.   -->

  
<!-- ============================================================= -->
  
<!--  "format-date"                                                -->
  
<!-- ============================================================= -->
  
<!-- Maps a structured date element to a string -->

  
<!-- Call the existing formatter with only the month -->
  
<!-- A safer way to obtain the month name                            -->
  
<!-- Helper: tries <month>, then <season>, then parses <string-date> -->
  
<!-- A safer way to obtain the year                            -->
  
<!-- Helper: tries <month>, then <season>, then parses <string-date> -->
  
<!-- ============================================================= -->
  
<!--  "author-string" writes authors' names in sequence            -->
  
<!-- ============================================================= -->

  
<!-- ============================================================= -->
  
<!--  Footer branding                                              -->
  
<!-- ============================================================= -->

  
<!-- ============================================================= -->
  
<!--  Utility templates for generating warnings and reports        -->
  
<!-- ============================================================= -->

  
<!--  <xsl:template name="report-warning">
    <xsl:param name="when" select="false()"/>
    <xsl:param name="msg"/>
    <xsl:if test="$verbose and $when">
      <xsl:message>
        <xsl:copy-of select="$msg"/>
      </xsl:message>
    </xsl:if>
  </xsl:template>-->


  
<!--<xsl:template name="list-elements">
    <xsl:param name="elements" select="/.."/>
    <xsl:if test="$elements">
      <ol>
        <xsl:for-each select="*">
          <li>
            <xsl:apply-templates select="." mode="element-pattern"/>
          </li>
        </xsl:for-each>
      </ol>
    </xsl:if>
  </xsl:template>-->


  
<!-- ============================================================= -->
  
<!--  End stylesheet                                               -->
  
<!-- ============================================================= -->


<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="article">
    <xsl:call-template name="make-article"/>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="footer-metadata">
    <!-- handles: article-categories, kwd-group, counts, 
           supplementary-material, custom-meta-group
         Plus also generates a sheet of processing warnings
         -->
    <CJSACKNOW>
    <div class="ack">
    <h2 id="ack" class="acknow">Acknowledgments and Associated Footnotes</h2>
    <xsl:for-each select="front/article-meta | front-stub">
      <p class="affils">
        <xsl:if test="aff | aff-alternatives | author-notes">
          <xsl:apply-templates mode="metadata" select="aff | aff-alternatives | author-notes"/>
        </xsl:if>
      </p>  
    </xsl:for-each>
    </div>
    </CJSACKNOW>
    <xsl:for-each select="front/article-meta | front-stub">
      <xsl:if test="           article-categories | kwd-group | counts |           supplementary-material | custom-meta-group |           custom-meta-wrap">
      </xsl:if>
    </xsl:for-each>

    <xsl:variable name="process-warnings">
      <xsl:call-template name="process-warnings"/>
    </xsl:variable>

    <xsl:if test="normalize-space(string($process-warnings))">
      <hr class="part-rule"/>
      <div class="metadata one-column table">
        <!--<div class="row">
          <div class="cell spanning">
            
          </div>
        </div>-->
        <div class="row">
          <div class="cell spanning">
            <h4 class="generated">
              <xsl:text>Process warnings</xsl:text>
            </h4>
            <p>Warnings reported by the processor due to problematic markup follow:</p>
            <div class="metadata-group">
              <xsl:copy-of select="$process-warnings"/>
            </div>
          </div>
        </div>
      </div>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="journal-id" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Journal ID</xsl:text>
        <xsl:for-each select="@journal-id-type">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="journal-title" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Title</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="journal-subtitle" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Subtitle</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="abbrev-journal-title" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Abbreviated Title</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="email" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Email</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="uri" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">URI</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="self-uri" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Self URI</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <a href="{@xlink:href}">
          <xsl:choose>
            <xsl:when test="normalize-space(string(.))">
              <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@xlink:href"/>
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="cjspdf-link">
    <xsl:call-template name="display-xlink">
      <xsl:with-param name="uri">
        <xsl:value-of select="self-uri[1]/@href"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="display-xlink">
    <xsl:param name="uri"/>
    <CJSPDF>
        <p class="pdf">
          <a href="../pdfs/{$uri}">
            <img src="https://archives.datapages.com/data/misc/pdficon.gif" style="border: 0; margin: 3px 6px;" width="28" height="31" alt="pdf" align="bottom"/>
            Click to view page images in PDF format.
          </a>
        <hr/>
        </p>
    </CJSPDF>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="volume-info">
    <!-- handles volume?, volume-id*, volume-series? -->
    <xsl:if test="volume | volume-id | volume-series">
      <xsl:choose>
        <xsl:when test="not(volume-id[2]) or not(volume)">
          <!-- if there are no multiple volume-id, or no volume, we make one line only -->
          <xsl:call-template name="metadata-labeled-entry">
            <xsl:with-param name="label">Volume</xsl:with-param>
            <xsl:with-param name="contents">
              <xsl:apply-templates select="volume | volume-series" mode="metadata-inline"/>
              <xsl:apply-templates select="volume-id" mode="metadata-inline"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="volume | volume-id | volume-series" mode="metadata"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="cjsvolume-info">
    <!-- handles volume?, volume-id*, volume-series? -->
    <xsl:if test="volume | volume-id | volume-series">
      <xsl:choose>
        <xsl:when test="not(volume-id[2]) or not(volume)">
          <!-- if there are no multiple volume-id, or no volume, we make one line only -->
          <xsl:call-template name="cjsmetadata-labeled-entry">
            <xsl:with-param name="label">Vol. </xsl:with-param>
            <xsl:with-param name="cjstag">CJSVOLUME</xsl:with-param>
            <xsl:with-param name="contents">
              <xsl:apply-templates select="volume | volume-series" mode="metadata-inline"/>
              <xsl:apply-templates select="volume-id" mode="metadata-inline"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="volume | volume-id | volume-series" mode="metadata"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="volume | issue" mode="metadata-inline">
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="volume-id | issue-id" mode="metadata-inline">
    <span class="generated">
      <xsl:text> (</xsl:text>
      <xsl:for-each select="@pub-id-type">
        <span class="data">
          <xsl:value-of select="."/>
        </span>
        <xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:text>ID: </xsl:text>
    </span>
    <xsl:apply-templates/>
    <span class="generated">)</span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="volume-series" mode="metadata-inline">
    <xsl:if test="preceding-sibling::volume">
      <span class="generated">,</span>
    </xsl:if>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="volume" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Volume</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="volume-id" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Volume ID</xsl:text>
        <xsl:for-each select="@pub-id-type">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="volume-series" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Series</xsl:with-param>
    </xsl:call-template>
  </xsl:template>




  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="issue-info">
    <!-- handles issue?, issue-id*, issue-title*, issue-sponsor*, issue-part?, supplement? -->
    <xsl:variable name="issue-info" select="         issue | issue-id | issue-title |         issue-sponsor | issue-part"/>
    <xsl:choose>
      <xsl:when test="$issue-info and not(issue-id[2] | issue-title[2] | issue-sponsor | issue-part)">
        <!-- if there are only one issue, issue-id and issue-title and nothing else, we make one line only -->
        <xsl:call-template name="metadata-labeled-entry">
          <xsl:with-param name="label">Issue</xsl:with-param>
          <xsl:with-param name="contents">
            <xsl:apply-templates select="issue | issue-title" mode="metadata-inline"/>
            <xsl:apply-templates select="issue-id" mode="metadata-inline"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$issue-info" mode="metadata"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="cjsissue-info">
    <!-- handles issue?, issue-id*, issue-title*, issue-sponsor*, issue-part?, supplement? -->
    <xsl:variable name="issue-info" select="         issue | issue-id | issue-title |         issue-sponsor | issue-part"/>
    <xsl:choose>
      <xsl:when test="$issue-info and not(issue-id[2] | issue-title[2] | issue-sponsor | issue-part)">
        <!-- if there are only one issue, issue-id and issue-title and nothing else, we make one line only -->
        <xsl:call-template name="cjsmetadata-labeled-entry">
          <xsl:with-param name="label">No. </xsl:with-param>
          <xsl:with-param name="cjstag">CJSISSUE</xsl:with-param>
          <xsl:with-param name="contents">
            <xsl:apply-templates select="issue | issue-title" mode="metadata-inline"/>
            <xsl:apply-templates select="issue-id" mode="metadata-inline"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$issue-info" mode="metadata"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="issue-title" mode="metadata-inline">
    <span class="generated">
      <xsl:if test="preceding-sibling::issue">,</xsl:if>
    </span>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="issue" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Issue</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="issue-id" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Issue ID</xsl:text>
        <xsl:for-each select="@pub-id-type">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="."/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="issue-title" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Issue title</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="page-info">
    <!-- handles (fpage, lpage?, page-range?) -->
    <xsl:if test="fpage | lpage | page-range">
      <xsl:call-template name="metadata-labeled-entry">
        <xsl:with-param name="label">
          <xsl:text>Page</xsl:text>
          <xsl:if test="               normalize-space(string(lpage[not(. = ../fpage)]))               or normalize-space(string(page-range))">
            <!-- we have multiple pages if lpage exists and is not equal fpage,
               or if we have a page-range -->
            <xsl:text>s</xsl:text>
          </xsl:if>
        </xsl:with-param>
        <xsl:with-param name="contents">
          <xsl:value-of select="fpage"/>
          <xsl:if test="normalize-space(string(lpage[not(. = ../fpage)]))">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="lpage"/>
          </xsl:if>
          <xsl:for-each select="page-range">
            <xsl:text> (pp. </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>)</xsl:text>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="cjspage-info">
    <!-- handles (fpage, lpage?, page-range?) -->
    <xsl:if test="fpage | lpage | page-range">
      <xsl:call-template name="metadata-labeled-entry">
        <xsl:with-param name="label">
          <xsl:choose>
              <xsl:when test="normalize-space(string(lpage[not(. = ../fpage)])) or normalize-space(string(page-range))">
                <!-- we have multiple pages if lpage exists and is not equal fpage,
                   or if we have a page-range -->
                <xsl:text>Pages </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>Page </xsl:text>
              </xsl:otherwise>  
            </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="contents">
          <xsl:element name="CJSFIRSTPAGE">
            <xsl:value-of select="fpage"/>
          </xsl:element>
          <xsl:if test="normalize-space(string(lpage[not(. = ../fpage)]))">
            <xsl:text>-</xsl:text>
            <xsl:element name="CJSASTPAGE">
              <xsl:value-of select="lpage"/>
            </xsl:element>
          </xsl:if>
          <xsl:for-each select="page-range">
            <xsl:text> (pp. </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>)</xsl:text>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


<!-- Insert a DOI hyperlink as shown in the target CJSVOLINFO block -->
<xsl:template name="cjs-doi-link">
  <!-- Pull the first article-level DOI -->
  <xsl:variable name="doi" select="normalize-space(/article/front/article-meta/article-id[@pub-id-type='doi'][1])"/>
  <xsl:if test="$doi">
    <!-- Compute the final href; if already absolute, use it; else prepend https://doi.org/ -->
    <xsl:choose>
      <xsl:when test="starts-with($doi,'http://') or starts-with($doi,'https://')">
        <br/>
        <a href="{$doi}" class="uri" target="_blank">
          <xsl:value-of select="$doi"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <br/>
        <a href="{concat('https://doi.org/',$doi)}" class="uri" target="_blank">
          <xsl:value-of select="concat('https://doi.org/',$doi)"/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="elocation-id" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Electronic Location Identifier</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="related-article | related-object" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:text>Related </xsl:text>
        <xsl:choose>
          <xsl:when test="self::related-object">object</xsl:when>
          <xsl:otherwise>article</xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="@related-article-type | @object-type">
          <xsl:text> (</xsl:text>
          <span class="data">
            <xsl:value-of select="translate(., '-', ' ')"/>
          </span>
          <xsl:text>)</xsl:text>
        </xsl:for-each>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:choose>
          <xsl:when test="normalize-space(string(@xlink:href))">
            <a>
              <xsl:call-template name="assign-href"/>
              <xsl:apply-templates/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="conference" mode="metadata">
    <!-- content model:
      (conf-date, 
       (conf-name | conf-acronym)+, 
       conf-num?, conf-loc?, conf-sponsor*, conf-theme?) -->
    <xsl:choose>
      <xsl:when test="           not(conf-name[2] | conf-acronym[2] | conf-sponsor |           conf-theme)">
        <!-- if there is no second name or acronym, and no sponsor
             or theme, we make one line only -->
        <xsl:call-template name="metadata-labeled-entry">
          <xsl:with-param name="label">Conference</xsl:with-param>
          <xsl:with-param name="contents">
            <xsl:apply-templates select="conf-acronym | conf-name" mode="metadata-inline"/>
            <xsl:apply-templates select="conf-num" mode="metadata-inline"/>
            <xsl:if test="conf-date | conf-loc">
              <span class="generated"> (</span>
              <xsl:for-each select="conf-date | conf-loc">
                <xsl:if test="position() = 2">, </xsl:if>
                <xsl:apply-templates select="." mode="metadata-inline"/>
              </xsl:for-each>
              <span class="generated">)</span>
            </xsl:if>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="metadata"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="conf-date" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Conference date</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="conf-name" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Conference</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="conf-acronym" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Conference</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="conf-num" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Conference number</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="conf-loc" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Conference location</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="conf-name | conf-acronym" mode="metadata-inline">
    <!-- we only hit this template if there is at most one of each -->
    <xsl:variable name="following" select="preceding-sibling::conf-name | preceding-sibling::conf-acronym"/>
    <!-- if we come after the other, we go in parentheses -->
    <xsl:if test="$following">
      <span class="generated"> (</span>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:if test="$following">
      <span class="generated">)</span>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="conf-num" mode="metadata-inline">
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="conf-date | conf-loc" mode="metadata-inline">
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="article-id" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <xsl:choose>
          <xsl:when test="@pub-id-type = 'art-access-id'">Accession ID</xsl:when>
          <xsl:when test="@pub-id-type = 'coden'">Coden</xsl:when>
          <xsl:when test="@pub-id-type = 'doi'">DOI</xsl:when>
          <xsl:when test="@pub-id-type = 'manuscript'">Manuscript ID</xsl:when>
          <xsl:when test="@pub-id-type = 'medline'">Medline ID</xsl:when>
          <xsl:when test="@pub-id-type = 'pii'">Publisher Item ID</xsl:when>
          <xsl:when test="@pub-id-type = 'pmid'">PubMed ID</xsl:when>
          <xsl:when test="@pub-id-type = 'publisher-id'">Publisher ID</xsl:when>
          <xsl:when test="@pub-id-type = 'sici'">Serial Item and Contribution ID</xsl:when>
          <xsl:when test="@pub-id-type = 'doaj'">DOAJ ID</xsl:when>
          <xsl:when test="@pub-id-type = 'arXiv'">arXiv.org ID</xsl:when>
          <xsl:otherwise>
            <xsl:text>Article Id</xsl:text>
            <xsl:for-each select="@pub-id-type">
              <xsl:text> (</xsl:text>
              <span class="data">
                <xsl:value-of select="."/>
              </span>
              <xsl:text>)</xsl:text>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="grant-num" mode="metadata">
    <!-- only in 2.3 -->
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Grant Number</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="funding-source" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Funded by</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="award-id" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Award ID</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="funding-statement" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">Funding</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="contrib-identify">
    <!-- Placed in a left-hand pane  -->
    <!--handles
    (anonymous | collab | collab-alternatives |
    name | name-alternatives | degrees | xref)
    and @equal-contrib -->
    <div class="metadata-group">
      <xsl:for-each select="           anonymous |           collab | collab-alternatives/* | name | name-alternatives/*">
        <xsl:call-template name="metadata-entry">
          <xsl:with-param name="contents">
            <xsl:if test="position() = 1">
              <!-- a named anchor for the contrib goes with its
              first member -->
              <xsl:call-template name="named-anchor"/>
              <!-- so do any contrib-ids -->
              <xsl:apply-templates mode="metadata-inline" select="../contrib-id"/>
            </xsl:if>
            <xsl:apply-templates select="." mode="metadata-inline"/>
            <xsl:if test="position() = last()">
              <xsl:apply-templates mode="metadata-inline" select="degrees | xref"/>
              <!-- xrefs in the parent contrib-group go with the last member
              of *each* contrib in the group -->
              <xsl:apply-templates mode="metadata-inline" select="following-sibling::xref"/>
            </xsl:if>

          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:if test="@equal-contrib = 'yes'">
        <xsl:call-template name="metadata-entry">
          <xsl:with-param name="contents">
            (Equal contributor)
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="anonymous" mode="metadata-inline">
    <xsl:text>Anonymous</xsl:text>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="       collab |       collab-alternatives/*" mode="metadata-inline">
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="degrees" mode="metadata-inline">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="contrib-info">
    <!-- Placed in a right-hand pane -->
    <div class="metadata-group">
      <xsl:apply-templates mode="metadata" select="           address | aff | author-comment | bio | email |           ext-link | on-behalf-of | role | uri"/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" mode="metadata" match="address[not(addr-line) or not(*[2])]">
    <!-- when we have no addr-line or a single child, we generate
         a single unlabelled line -->
    <xsl:call-template name="metadata-entry">
      <xsl:with-param name="contents">
        <xsl:call-template name="address-line"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="address" mode="metadata">
    <!-- when we have an addr-line we generate an unlabelled block -->
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="contents">
        <xsl:apply-templates mode="metadata"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" mode="metadata" priority="2" match="address/*">
    <!-- being sure to override other templates for these
         element types -->
    <xsl:call-template name="metadata-entry"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="aff" mode="metadata">
    <xsl:call-template name="metadata-entry">
      <xsl:with-param name="contents">
        <xsl:call-template name="named-anchor"/>
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
    <br/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="bio" mode="metadata">
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Bio</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="on-behalf-of" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">On behalf of</xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="role" mode="metadata">
    <xsl:call-template name="metadata-entry"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="title" mode="metadata">
    <xsl:apply-templates select="."/>
  </xsl:template>




  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="counts" mode="metadata">
    <!-- fig-count?, table-count?, equation-count?, ref-count?,
         page-count?, word-count? -->
    <xsl:call-template name="metadata-area">
      <xsl:with-param name="label">Counts</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates mode="metadata"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="count" mode="metadata-label">
    <xsl:text>Count</xsl:text>
    <xsl:for-each select="@count-type">
      <xsl:text> (</xsl:text>
      <span class="data">
        <xsl:value-of select="."/>
      </span>
      <xsl:text>)</xsl:text>
    </xsl:for-each>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="table-count" mode="metadata-label">Tables</xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="equation-count" mode="metadata-label">Equations</xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="ref-count" mode="metadata-label">References</xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="word-count" mode="metadata-label">Words</xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="custom-meta" mode="metadata">
    <xsl:call-template name="metadata-labeled-entry">
      <xsl:with-param name="label">
        <span class="data">
          <xsl:apply-templates select="meta-name" mode="metadata-inline"/>
        </span>
      </xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates select="meta-value" mode="metadata-inline"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="meta-name | meta-value" mode="metadata-inline">
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="make-abstract">

         <CJSABSTRACT>
             <h2 class="abstract">
               <xsl:apply-templates select="title/node()"/>
               <xsl:if test="not(normalize-space(string(title)))">
                   <xsl:if test="self::trans-abstract">TRANSLATED </xsl:if>
                   <xsl:text>ABSTRACT</xsl:text>
               </xsl:if>
             </h2>
           <xsl:apply-templates select="*[not(self::title)]"/>
         </CJSABSTRACT>

  </xsl:template>
  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="*" mode="drop-title">
    <xsl:apply-templates select="."/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="title">
    <xsl:if test="normalize-space(string(.))">
      <h3 class="title">
        <xsl:apply-templates/>
      </h3>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="subtitle">
    <xsl:if test="normalize-space(string(.))">
      <h5 class="subtitle">
        <xsl:apply-templates/>
      </h5>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="address">
    <xsl:choose>
      <!-- address appears as a sequence of inline elements if
           it has no addr-line and the parent may contain text -->
      <xsl:when test="           not(addr-line) and           (parent::collab | parent::p | parent::license-p |           parent::named-content | parent::styled-content)">
        <xsl:call-template name="address-line"/>
      </xsl:when>
      <xsl:otherwise>
        <div class="address">
          <xsl:apply-templates/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="address-line">
    <!-- emits element children in a simple comma-delimited sequence -->
    <xsl:for-each select="*">
      <xsl:if test="position() &gt; 1">, </xsl:if>
      <xsl:apply-templates/>
    </xsl:for-each>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="address/*">
    <p class="address-line">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="textual-form">
    <p class="textual-form">
      <span class="generated">[Textual form] </span>
      <xsl:apply-templates/>
    </p>
  </xsl:template>



  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="alt-text">
    <!-- handled with graphic or inline-graphic -->
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="media">
    <a>
      <xsl:call-template name="assign-id"/>
      <xsl:call-template name="assign-href"/>
      <xsl:apply-templates/>
    </a>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="def-item">
    <div class="def-item row">
      <xsl:call-template name="assign-id"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="term">
    <div class="def-term cell">
      <xsl:call-template name="assign-id"/>
      <p>
        <xsl:apply-templates/>
      </p>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="def">
    <div class="def-def cell">
      <xsl:call-template name="assign-id"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="alternatives | name-alternatives | collab-alternatives | aff-alternatives">
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="ref">
    <p class="row">
      <div class="ref-label cell">
        <span class="ref-label">
          <xsl:apply-templates select="." mode="label"/>
          <xsl:text> </xsl:text>
          <!-- space forces vertical alignment of the paragraph -->
          <xsl:call-template name="named-anchor"/>
        </span>
<!-- 
      </div>
      <div class="ref-content cell">
 -->
        <xsl:apply-templates/>
      </div>
    </p>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="ref/note" priority="2">
    <xsl:param name="label" select="''"/>
    <xsl:if test="         normalize-space(string($label))         and not(preceding-sibling::*[not(self::label)])">
      <p class="label">
        <xsl:copy-of select="$label"/>
      </p>
    </xsl:if>
    <div class="note">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="verse-line">
    <p class="verse-line">
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="label" name="label">
    <!-- other labels are displayed as blocks -->
    <h5 class="label">
      <xsl:apply-templates/>
    </h5>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="@*" mode="table-copy">
    <xsl:copy-of select="."/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="abbrev">
    <xsl:apply-templates/>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="abbrev/def">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="address/*" mode="inline">
    <xsl:if test="preceding-sibling::*">
      <span class="generated">, </span>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="award-id">
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="break">
    <br class="br"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="email">
    <a href="mailto:{.}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="funding-source">
    <span class="funding-source">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="hr">
    <hr class="hr"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="milestone-start | milestone-end">
    <span class="{substring-after(local-name(),'milestone-')}">
      <xsl:comment>
        <xsl:value-of select="@rationale"/>
      </xsl:comment>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="object-id">
    <span class="{local-name()}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="sig">
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="target">
    <xsl:call-template name="named-anchor"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="styled-content">
    <span>
      <xsl:copy-of select="@style"/>
      <xsl:for-each select="@style-type">
        <xsl:attribute name="class">
          <xsl:value-of select="."/>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="named-content">
    <span>
      <xsl:for-each select="@content-type">
        <xsl:attribute name="class">
          <xsl:value-of select="translate(., ' ', '-')"/>
        </xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="related-article">
    <span class="generated">[Related article:] </span>
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="related-object">
    <span class="generated">[Related object:] </span>
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="overline">
    <span style="text-decoration: overline">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="roman">
    <span style="font-style: normal">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="sans-serif">
    <span style="font-family: sans-serif; font-size: 80%">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="sc">
    <span style="font-variant: small-caps">
      <xsl:apply-templates/>
    </span>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="sub">
    <sub>
      <xsl:apply-templates/>
    </sub>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="make-back">
    <xsl:apply-templates select="back"/>
    <xsl:if test="$loose-footnotes and not(back)">
      <!-- autogenerating a section for footnotes only if there is no
           back element, and if footnotes exist for it -->
      <xsl:call-template name="footnotes"/>
    </xsl:if>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="footnotes">
    <xsl:call-template name="backmatter-section">
      <xsl:with-param name="generated-title">Notes</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates select="$loose-footnotes" mode="footnote"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="backmatter-section">
    <xsl:param name="generated-title"/>
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <div class="back-section">
      <xsl:call-template name="named-anchor"/>
      <xsl:if test="not(title) and $generated-title">
        <xsl:choose>
          <!-- The level of title depends on whether the back matter itself
               has a title -->
          <xsl:when test="ancestor::back/title">
            <xsl:call-template name="section-title">
              <xsl:with-param name="contents" select="$generated-title"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="main-title">
              <xsl:with-param name="contents" select="$generated-title"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:copy-of select="$contents"/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn">
    <!-- Footnotes appearing outside fn-group
       generate cross-references to the footnote,
       which is displayed elsewhere -->
    <!-- Note the rules for displayed content: if any fn elements
       not inside an fn-group (the matched fn or any other) includes
       a label child, all footnotes are expected to have a label
       child. -->
    <xsl:variable name="id">
      <xsl:apply-templates select="." mode="id"/>
    </xsl:variable>
    <a href="#{$id}">
      <xsl:apply-templates select="." mode="label-text">
        <xsl:with-param name="warning" select="true()"/>
      </xsl:apply-templates>
    </a>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn" mode="footnote">
    <div class="footnote">
      <xsl:call-template name="named-anchor"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" mode="label" match="*" name="block-label">
    <xsl:param name="contents">
      <xsl:apply-templates select="." mode="label-text">
        <!-- we place a warning for missing labels if this element is ever
             cross-referenced with an empty xref -->
        <xsl:with-param name="warning" select="boolean(key('xref-by-rid', @id)[not(normalize-space(string(.)))])"/>
      </xsl:apply-templates>
    </xsl:param>
    <xsl:if test="normalize-space(string($contents))">
      <!-- not to create an h5 for nothing -->
      <h5 class="label">
        <xsl:copy-of select="$contents"/>
      </h5>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" mode="label" match="ref">
    <xsl:param name="contents">
      <xsl:apply-templates select="." mode="label-text"/>
    </xsl:param>
    <xsl:if test="normalize-space(string($contents))">
      <!-- we're already in a p -->
      <span class="label">
        <xsl:copy-of select="$contents"/>
      </span>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="boxed-text" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-boxed-text"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>Box </xsl:text>
        <xsl:number level="any"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="fn" mode="label-text">
    <xsl:param name="warning" select="boolean(key('xref-by-rid', @id))"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels);
         by default, we get a warning only if we need a label for
         a cross-reference -->
    <!-- autonumber all fn elements outside fn-group,
         front matter and table-wrap only if none of them 
         have labels or @symbols (to keep numbering
         orderly) -->
    <xsl:variable name="in-scope-notes" select="         ancestor::article//fn[not(parent::fn-group         | ancestor::front         | ancestor::table-wrap)]"/>
    <xsl:variable name="auto-number-fn" select="         not($in-scope-notes/label |         $in-scope-notes/@symbol)"/>
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-number-fn"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>[</xsl:text>
        <xsl:number level="any" count="fn[not(ancestor::front)]" from="article | sub-article | response"/>
        <xsl:text>]</xsl:text>
        <xsl:apply-templates select="@fn-type"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="bio" mode="label-text">
    <!-- don’t warn: we’re supplying a default -->
    <xsl:param name="warning" select="false()"/>
    <xsl:choose>
      <!-- If a label exists, use the standard machinery -->
      <xsl:when test="label">
        <xsl:call-template name="make-label-text"/>
      </xsl:when>
      <!-- Otherwise try a title if present -->
      <xsl:when test="title">
        <xsl:value-of select="normalize-space(title[1])"/>
      </xsl:when>
      <!-- Fallback default -->
      <xsl:otherwise>
        <xsl:call-template name="make-label-text">
          <xsl:with-param name="auto" select="true()"/>
          <xsl:with-param name="auto-text">
            <xsl:text>Biography</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="ref" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-ref"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:number level="any"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="statement" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="auto" select="$auto-label-statement"/>
      <xsl:with-param name="warning" select="$warning"/>
      <xsl:with-param name="auto-text">
        <xsl:text>Statement </xsl:text>
        <xsl:number level="any"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="*" mode="label-text">
    <xsl:param name="warning" select="true()"/>
    <!-- pass $warning in as false() if a warning string is not wanted
         (for example, if generating autonumbered labels) -->
    <xsl:call-template name="make-label-text">
      <xsl:with-param name="warning" select="$warning"/>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="label" mode="label-text">
    <xsl:apply-templates mode="inline-label-text"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="text()" mode="inline-label-text">
    <!-- when displaying labels, space characters become non-breaking spaces -->
    <xsl:value-of select="translate(normalize-space(string(.)), ' &#10;&#9;', '   ')"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="name">
    <xsl:apply-templates select="prefix" mode="inline-name"/>
    <xsl:apply-templates select="surname[../@name-style = 'eastern']" mode="inline-name"/>
    <xsl:apply-templates select="given-names" mode="inline-name"/>
    <xsl:apply-templates select="surname[not(../@name-style = 'eastern')]" mode="inline-name"/>
    <xsl:apply-templates select="suffix" mode="inline-name"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="given-names" mode="inline-name">
    <xsl:apply-templates/>
    <xsl:if test="../surname[not(../@name-style = 'eastern')] | ../suffix">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="surname" mode="inline-name">
    <xsl:apply-templates/>
    <xsl:if test="../given-names[../@name-style = 'eastern'] | ../suffix">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="suffix" mode="inline-name">
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="append-pub-type">
    <!-- adds a value mapped for @pub-type, enclosed in parenthesis,
         to a string -->
    <xsl:for-each select="@pub-type">
      <xsl:text> (</xsl:text>
      <span class="data">
        <xsl:choose>
          <xsl:when test=". = 'epub'">electronic</xsl:when>
          <xsl:when test=". = 'ppub'">print</xsl:when>
          <xsl:when test=". = 'epub-ppub'">print and electronic</xsl:when>
          <xsl:when test=". = 'epreprint'">electronic preprint</xsl:when>
          <xsl:when test=". = 'ppreprint'">print preprint</xsl:when>
          <xsl:when test=". = 'ecorrected'">corrected, electronic</xsl:when>
          <xsl:when test=". = 'pcorrected'">corrected, print</xsl:when>
          <xsl:when test=". = 'eretracted'">retracted, electronic</xsl:when>
          <xsl:when test=". = 'pretracted'">retracted, print</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="."/>
          </xsl:otherwise>
        </xsl:choose>
      </span>
      <xsl:text>)</xsl:text>
    </xsl:for-each>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="metadata-labeled-entry">
    <xsl:param name="label"/>
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <xsl:call-template name="metadata-entry">
      <xsl:with-param name="contents">
        <xsl:if test="normalize-space(string($label))">
          <xsl:copy-of select="$label"/>
          <xsl:text></xsl:text>
        </xsl:if>
        <xsl:copy-of select="$contents"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="cjsmetadata-labeled-entry">
    <xsl:param name="label"/>
    <xsl:param name="cjstag"/>
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <xsl:call-template name="cjsmetadata-entry">
      <xsl:with-param name="contents">
        <xsl:if test="normalize-space(string($label))">
          <xsl:copy-of select="$label"/>
          <xsl:element name="{$cjstag}">
            <xsl:copy-of select="$contents"/>
          </xsl:element></xsl:if>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="metadata-entry">
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <xsl:copy-of select="$contents"/>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="cjsmetadata-entry">
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <xsl:copy-of select="$contents"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="metadata-area">
    <xsl:param name="label"/>
    <xsl:param name="contents">
      <xsl:apply-templates/>
    </xsl:param>
    <div class="affiliations metadata-area">
      <xsl:if test="normalize-space(string($label))">
        <xsl:call-template name="metadata-labeled-entry">
          <xsl:with-param name="label">
            <xsl:copy-of select="$label"/>
          </xsl:with-param>
          <xsl:with-param name="contents"/>
        </xsl:call-template>
      </xsl:if>
      <div class="metadata-chunk">
        <xsl:copy-of select="$contents"/>
      </div>
    </div>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="make-label-text">
    <xsl:param name="auto" select="false()"/>
    <xsl:param name="warning" select="false()"/>
    <xsl:param name="auto-text"/>
    <xsl:choose>
      <xsl:when test="$auto">
          <xsl:copy-of select="$auto-text"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="label-text" select="label | @symbol"/>
        <xsl:if test="$warning and not(label | @symbol)">
          <span class="warning">
            <xsl:text>{ label</xsl:text>
            <xsl:if test="self::fn"> (or @symbol)</xsl:if>
            <xsl:text> needed for </xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:for-each select="@id">
              <xsl:text>[@id='</xsl:text>
              <xsl:value-of select="."/>
              <xsl:text>']</xsl:text>
            </xsl:for-each>
            <xsl:text> }</xsl:text>
          </span>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="assign-id">
    <xsl:variable name="id">
      <xsl:apply-templates select="." mode="id"/>
    </xsl:variable>
    <xsl:attribute name="id">
      <xsl:value-of select="$id"/>
    </xsl:attribute>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="assign-src">
    <xsl:for-each select="@xlink:href">
      <xsl:attribute name="src">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:for-each>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="assign-href">
    <xsl:for-each select="@xlink:href">
      <xsl:attribute name="href">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:for-each>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="named-anchor">
    <!-- generates an HTML named anchor -->
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="@id">
          <!-- if we have an @id, we use it -->
          <xsl:value-of select="@id"/>
        </xsl:when>
        <xsl:when test="             not(preceding-sibling::*) and             (parent::alternatives | parent::name-alternatives |             parent::citation-alternatives | parent::collab-alternatives |             parent::aff-alternatives)/@id">
          <!-- if not, and we are first among our siblings inside one of
               several 'alternatives' wrappers, we use its @id if available -->
          <xsl:value-of select="               (parent::alternatives | parent::name-alternatives |               parent::citation-alternatives | parent::collab-alternatives |               parent::aff-alternatives)/@id"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- otherwise we simply generate an ID -->
          <xsl:value-of select="generate-id(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <a id="{$id}">
      <xsl:comment> named anchor </xsl:comment>
    </a>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="process-warnings">
    <!-- Only generate the warnings if set to $verbose -->
    <xsl:if test="$verbose">
      <!-- returns an RTF containing all the warnings -->
      <xsl:variable name="xref-warnings">
        <xsl:for-each select="//xref[not(normalize-space(string(.)))]">
          <xsl:variable name="target-label">
            <xsl:apply-templates select="key('element-by-id', @rid)" mode="label-text">
              <xsl:with-param name="warning" select="false()"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:if test="               not(normalize-space(string($target-label))) and               generate-id(.) = generate-id(key('xref-by-rid', @rid)[1])">
            <!-- if we failed to get a label with no warning, and
               this is the first cross-reference to this target
               we ask again to get the warning -->
            <li>
              <xsl:apply-templates select="key('element-by-id', @rid)" mode="label-text">
                <xsl:with-param name="warning" select="true()"/>
              </xsl:apply-templates>
            </li>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>

      <xsl:if test="normalize-space(string($xref-warnings))">
        <h4>Elements are cross-referenced without labels.</h4>
        <p>Either the element should be provided a label, or their cross-reference(s) should have
          literal text content.</p>
        <ul>
          <xsl:copy-of select="$xref-warnings"/>
        </ul>
      </xsl:if>


      <xsl:variable name="alternatives-warnings">
        <!-- for reporting any element with a @specific-use different
           from a sibling -->
        <xsl:for-each select="//*[@specific-use != ../*/@specific-use]/..">
          <li>
            <xsl:text>In </xsl:text>
            <xsl:apply-templates select="." mode="xpath"/>
            <ul>
              <xsl:for-each select="*[@specific-use != ../*/@specific-use]">
                <li>
                  <xsl:apply-templates select="." mode="pattern"/>
                </li>
              </xsl:for-each>
            </ul>
            <!--<xsl:text>: </xsl:text>
          <xsl:call-template name="list-elements">
            <xsl:with-param name="elements" select="*[@specific-use]"/>
          </xsl:call-template>-->
          </li>
        </xsl:for-each>
      </xsl:variable>

      <xsl:if test="normalize-space(string($alternatives-warnings))">
        <h4>Elements with different 'specific-use' assignments appearing together</h4>
        <ul>
          <xsl:copy-of select="$alternatives-warnings"/>
        </ul>
      </xsl:if>
    </xsl:if>

  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="*" mode="id">
    <xsl:value-of select="@id"/>
    <xsl:if test="not(@id)">
      <xsl:value-of select="generate-id(.)"/>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="format-date">
    <!-- formats date in DD Month YYYY format -->
    <!-- context must be 'date', with content model:
         (((day?, month?) | season)?, year) -->
    <xsl:for-each select="day | month | season">
      <xsl:apply-templates select="." mode="map"/>
      <xsl:text> </xsl:text>
    </xsl:for-each>
    <xsl:apply-templates select="year" mode="map"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="day | season | year" mode="map">
    <xsl:apply-templates/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="month-name">
    <xsl:param name="month"/>
    <xsl:choose>
      <xsl:when test="$month = '01' or $month = '1'">January</xsl:when>
      <xsl:when test="$month = '02' or $month = '2'">February</xsl:when>
      <xsl:when test="$month = '03' or $month = '3'">March</xsl:when>
      <xsl:when test="$month = '04' or $month = '4'">April</xsl:when>
      <xsl:when test="$month = '05' or $month = '5'">May</xsl:when>
      <xsl:when test="$month = '06' or $month = '6'">June</xsl:when>
      <xsl:when test="$month = '07' or $month = '7'">July</xsl:when>
      <xsl:when test="$month = '08' or $month = '8'">August</xsl:when>
      <xsl:when test="$month = '09' or $month = '9'">September</xsl:when>
      <xsl:when test="$month = '10'">October</xsl:when>
      <xsl:when test="$month = '11'">November</xsl:when>
      <xsl:when test="$month = '12'">December</xsl:when>
    </xsl:choose>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="year-digits">
    <xsl:param name="year"/>
    <xsl:value-of select="normalize-space($year)"/>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="safe-month-name">
    <xsl:param name="date" select="."/>
    <xsl:choose>
      <!-- 1) Standard numeric month -->
      <xsl:when test="normalize-space($date/month)">
        <xsl:call-template name="month-name">
          <xsl:with-param name="month" select="$date/month"/>
        </xsl:call-template>
      </xsl:when>

      <!-- 2) Seasonal label present (e.g., 'Spring') -->
      <xsl:when test="normalize-space($date/season)">
        <xsl:value-of select="normalize-space($date/season)"/>
      </xsl:when>

      <!-- 3) Try to extract a numeric month from string-date (YYYY-MM or YYYY-MM-DD) -->
      <xsl:when test="normalize-space($date/string-date) and contains($date/string-date, '-')">
        <xsl:variable name="sd" select="normalize-space($date/string-date)"/>
        <!-- Take the middle token after first '-' -->
        <xsl:variable name="m" select="substring-before(substring-after($sd, '-'), '-')"/>
        <xsl:choose>
          <xsl:when test="string-length($m) &gt; 0">
            <xsl:call-template name="month-name">
              <xsl:with-param name="month" select="$m"/>
            </xsl:call-template>
          </xsl:when>
          <!-- If it was only YYYY-MM (no second '-') -->
          <xsl:otherwise>
            <xsl:variable name="m2" select="substring-after($sd, '-')"/>
            <xsl:call-template name="month-name">
              <xsl:with-param name="month" select="$m2"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- 4) Last resort: if string-date is a free-form month name, just print it -->
      <xsl:when test="normalize-space($date/string-date)">
        <xsl:value-of select="normalize-space($date/string-date)"/>
      </xsl:when>

      <!-- 5) Nothing available -->
      <xsl:otherwise>
        <!-- emit nothing (or put a placeholder like 'Unknown') -->
        <xsl:text/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="safe-year">
    <xsl:param name="date" select="."/>
    <xsl:choose>
      <!-- 1) Standard numeric year -->
      <xsl:when test="normalize-space($date/year)">
        <xsl:call-template name="year-digits">
          <xsl:with-param name="year" select="$date/year"/>
        </xsl:call-template>
      </xsl:when>

      <!-- 3) Try to extract a numeric year from string-date (YYYY-MM or YYYY-MM-DD) -->
      <xsl:when test="normalize-space($date/string-date) and contains($date/string-date, '-')">
        <xsl:variable name="sd" select="normalize-space($date/string-date)"/>
        <!-- Take the middle token after first '-' -->
        <xsl:variable name="y" select="substring-before(substring-before($sd, '-'), '-')"/>
        <xsl:choose>
          <xsl:when test="string-length($m) &gt; 0">
            <xsl:call-template name="year-digits">
              <xsl:with-param name="year" select="$y"/>
            </xsl:call-template>
          </xsl:when>
          <!-- If it was only YYYY-MM (no second '-') -->
          <xsl:otherwise>
            <xsl:variable name="y2" select="substring-after($sd, '-')"/>
            <xsl:call-template name="year-digits">
              <xsl:with-param name="year" select="$y2"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <!-- 4) Last resort: if string-date is a free-form , just skip it -->
      <xsl:when test="normalize-space($date/string-date)"> </xsl:when>

      <!-- 5) Nothing available -->
      <xsl:otherwise>
        <!-- emit nothing (or put a placeholder like 'Unknown') -->
        <xsl:text/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="author-string">
    <xsl:variable name="all-contribs" select="         /article/front/article-meta/contrib-group/contrib/name/surname |         /article/front/article-meta/contrib-group/contrib/collab"/>
    <xsl:for-each select="$all-contribs">
      <xsl:if test="count($all-contribs) &gt; 1">
        <xsl:if test="position() &gt; 1">
          <xsl:if test="count($all-contribs) &gt; 2">,</xsl:if>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="position() = count($all-contribs)">and </xsl:if>
      </xsl:if>
      <xsl:value-of select="."/>
    </xsl:for-each>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="footer-branding">
<!-- 
    <hr class="part-rule"/>
    <div class="branding">
      <p>
        <xsl:text>This display is generated from </xsl:text>
        <xsl:text>NISO JATS XML with </xsl:text>
        <b>
          <xsl:value-of select="$transform"/>
        </b>
        <xsl:text>. The XSLT engine is </xsl:text>
        <xsl:value-of select="system-property('xsl:vendor')"/>
        <xsl:text>.</xsl:text>
      </p>
    </div>
 -->
  <footer class="footer-branding">
    <hr/>
    <p class="copyright">
      <xsl:variable name="cstmt"
        select="normalize-space(/article/front/article-meta/permissions/copyright-statement)"/>
      <xsl:choose>
        <xsl:when test="$cstmt">
          <xsl:value-of select="$cstmt"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- Fallback if no copyright-statement present -->
        </xsl:otherwise>
      </xsl:choose>
    </p>
  </footer>
 
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="*" mode="pattern">
    <xsl:value-of select="name(.)"/>
    <xsl:for-each select="@*">
      <xsl:text>[@</xsl:text>
      <xsl:value-of select="name()"/>
      <xsl:text>='</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>']</xsl:text>
    </xsl:for-each>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="node()" mode="xpath">
    <xsl:apply-templates mode="xpath" select=".."/>
    <xsl:apply-templates mode="xpath-step" select="."/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="*" mode="xpath-step">
    <xsl:variable name="name" select="name(.)"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:if test="count(../*[name(.) = $name]) &gt; 1">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="count(. | preceding-sibling::*[name(.) = $name])"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="@*" mode="xpath-step">
    <xsl:text>/@</xsl:text>
    <xsl:value-of select="name(.)"/>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="comment()" mode="xpath-step">
    <xsl:text>/comment()</xsl:text>
    <xsl:if test="count(../comment()) &gt; 1">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="count(. | preceding-sibling::comment())"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>


  
<xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" match="text()" mode="xpath-step">
    <xsl:text>/text()</xsl:text>
    <xsl:if test="count(../text()) &gt; 1">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="count(. | preceding-sibling::text())"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
  </xsl:template>


  
<!-- Remove all leading "../" (and optional leading "./") from a relative path -->
<xsl:template name="cjs-strip-leading-dotdot">
  <xsl:param name="path" select="''"/>
  <xsl:choose>
    <xsl:when test="starts-with($path, '../')">
      <xsl:call-template name="cjs-strip-leading-dotdot">
        <xsl:with-param name="path" select="substring($path, 4)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="starts-with($path, './')">
      <xsl:call-template name="cjs-strip-leading-dotdot">
        <xsl:with-param name="path" select="substring($path, 3)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$path"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- formatting affiliations with city and state setoff with commas as needed -->
<xsl:template match="aff" mode="metadata">
  <span id="{@id}"><!-- named anchor --></span>

  <!-- Determine the marker: existing <label> OR generated number -->
  <xsl:variable name="explicit-label" select="normalize-space(string(label[1]))"/>

  <xsl:choose>
    <!-- Case 1: explicit <label> in the source (e.g., IPA '*') -->
    <xsl:when test="$explicit-label != ''">
      <xsl:value-of select="$explicit-label"/>
    </xsl:when>

    <!-- Case 2: no <label> → generate a number based on <aff> position -->
    <xsl:otherwise>
      <xsl:number level="any"
                  from="article-meta"
                  count="aff"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text> </xsl:text>

  <!-- The main components of the affiliation, comma-separated -->
  <xsl:for-each
      select="
        institution-wrap/institution |
        institution |
        addr-line |
        city |
        state |
        country |
        text()[normalize-space() != '']
      ">
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:for-each>

  <br/>
</xsl:template>


</xsl:stylesheet>
