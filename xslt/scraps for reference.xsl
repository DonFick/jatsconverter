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

                <!-- Resolve target <aff> and grab its <label> -->
                <xsl:variable name="aff" select="key('element-by-id', @rid)[1]"/>
                <xsl:variable name="lab" select="normalize-space(string($aff/label[1]))"/>

                <a href="#{@rid}">
                  <xsl:choose>
                    <xsl:when test="$lab != ''">
                      <xsl:value-of select="$lab"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- Fallback: show id suffix without punctuation -->
                      <xsl:value-of select="substring-after(@rid,'aff')"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </a>
              </xsl:for-each>
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
    <!-- After printing authors, render the affiliations that live under contrib-group -->
    <div class="affiliations">
      <xsl:apply-templates select="aff | ../aff" mode="metadata"/>
    </div>
</xsl:template>


<!-- formatting affiliations with city and state setoff with commas as needed -->
<xsl:template match="aff" mode="metadata">
  <span id="{@id}"><!-- named anchor --></span>

  <!-- Output components with commas -->
  <xsl:for-each select="institution-wrap/institution | city | state">
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:if test="position() != last()">, </xsl:if>
  </xsl:for-each>

  <br/>
</xsl:template>




<!-- removed from front, issue metadata -->

(<xsl:call-template name="safe-month-name">
          <xsl:with-param name="date" select="pub-date"/>
        </xsl:call-template>)