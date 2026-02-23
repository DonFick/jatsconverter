<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" xsl="http://www.w3.org/1999/XSL/Transform" xlink="http://www.w3.org/1999/xlink" mml="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="xlink mml">
<xsl:param xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="localpdfpath" select="''"/>


<xsl:output xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" method="html" version="5.0" encoding="UTF-8" indent="no"/>
<xsl:strip-space xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" elements="*"/>

  <xsl:preserve-space xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML"
   elements="abbrev abbrev-journal-title access-date addr-line
                 aff alt-text alt-title article-id article-title
                 attrib award-id bold chapter-title chem-struct
                 collab comment compound-kwd-part compound-subject-part
                 conf-acronym conf-date conf-loc conf-name conf-num
                 conf-sponsor conf-theme contrib-id copyright-holder
                 copyright-statement copyright-year corresp country
                 date-in-citation day def-head degrees disp-formula
                 edition elocation-id email etal ext-link fax fpage
                 funding-source funding-statement given-names glyph-data
                 gov inline-formula inline-supplementary-material
                 institution isbn issn-l issn issue issue-id issue-part
                 issue-sponsor issue-title italic journal-id
                 journal-subtitle journal-title kwd label license-p
                 long-desc lpage meta-name meta-value mixed-citation
                 monospace month named-content object-id on-behalf-of
                 overline p page-range part-title patent person-group
                 phone prefix preformat price principal-award-recipient
                 principal-investigator product pub-id publisher-loc
                 publisher-name related-article related-object role
                 roman sans-serif sc season self-uri series series-text
                 series-title sig sig-block size source speaker std
                 strike string-name styled-content std-organization
                 sub subject subtitle suffix sup supplement surname
                 target td term term-head tex-math textual-form th
                 time-stamp title trans-source trans-subtitle trans-title
                 underline uri verse-line volume volume-id volume-series
                 xref year
                 mml:annotation mml:ci mml:cn mml:csymbol mml:mi mml:mn
                 mml:mo mml:ms mml:mtext"/>


  <xsl:param xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="transform" select="'scjats-html.xsl'"/>

  <xsl:param xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="css" select="'aapg-preview.css'"/>
  
  <xsl:param xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="report-warnings" select="'yes'"/>

  <xsl:key xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="element-by-id" match="*[@id]" use="@id"/>

  <xsl:key xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mml="http://www.w3.org/1998/Math/MathML" name="xref-by-rid" match="xref" use="@rid"/>

  
</xsl:stylesheet>
