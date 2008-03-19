<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="innerresults">

    <xsl:for-each select="//results/result">
        <div class="result">
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="rdf:RDF/cc:Work/dc:identifier" />
                </xsl:attribute>
                <img>
                    <xsl:attribute name="src">
                        <xsl:value-of select="@thumbnail" />
                    </xsl:attribute>
                    <xsl:attribute name="alt">
                        <xsl:value-of select="rdf:RDF/cc:Work/dc:title" />
                    </xsl:attribute>
                </img>
<!--
                postponed - css positioning fails it in firefox and konqueror

                <img class="flag">
                    <xsl:attribute name="src">
                        <xsl:value-of select="concat('/images/flags/', $locale, '.png')" />
                    </xsl:attribute>
                    <xsl:attribute name="alt">
                        <xsl:value-of select="$locale" />
                    </xsl:attribute>
                </img>
-->
            </a>
            <br />
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="rdf:RDF/cc:Work/dc:identifier" />
                </xsl:attribute>
                <xsl:value-of select="rdf:RDF/cc:Work/dc:title" />
            </a>
            <br />
            <xsl:variable name="hours" select="floor(@duration div 3600)" />
            <xsl:variable name="minutes" select="floor((@duration - $hours*3600) div 60)" />
            <xsl:variable name="seconds" select="@duration - $minutes*60 - $hours*3600" />
            <xsl:choose>
                <xsl:when test="$hours=0">
                    (<xsl:value-of select="concat(format-number($minutes, '00'), ':', format-number($seconds, '00'))" />)
                </xsl:when>
                <xsl:otherwise>
                    (<xsl:value-of select="concat($hours, ':', format-number($minutes, '00'), ':', format-number($seconds, '00'))" />)
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:for-each>
</xsl:template>


<xsl:template name="results">

    <div>
        <span class="heading">
            <xsl:value-of select="$locale_strings[@id='results_heading_1']" />&#160;
            <xsl:value-of select="//results/@pagesize * (//results/@currentpage - 1) + 1" />&#160;
            <xsl:value-of select="$locale_strings[@id='results_heading_2']" />&#160;
            <xsl:choose>
                <xsl:when test="(//results/@pagesize * //results/@currentpage) &lt; //results/@resultcount">
                    <xsl:value-of select="//results/@pagesize * //results/@currentpage" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="//results/@resultcount" />
                </xsl:otherwise>
            </xsl:choose>&#160;
            <xsl:value-of select="$locale_strings[@id='results_heading_3']" />&#160;
            <xsl:value-of select="//results/@resultcount" />&#160;
            <xsl:value-of select="$locale_strings[@id='results_heading_4']" />
        </span>
    </div>

    <xsl:call-template name="innerresults"/>

    <xsl:if test="//results/@lastpage &gt; 1">
        <xsl:call-template name="pagination-arrows"/>
    </xsl:if>

</xsl:template>

<xsl:template name="pagination-arrows">
    <xsl:variable name="query_string" select="concat($site_strings[@id='path_results'], //results/@query, '&amp;pagesize=', //results/@pagesize)" />
    <div>
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="concat($query_string, '&amp;page=1')" />
            </xsl:attribute>
            <xsl:if test="//results/@currentpage&lt;=1">
                <xsl:attribute name="style">
                    visibility: hidden;
                </xsl:attribute>
            </xsl:if>
            <img src="./images/tango/go-first.png" />
        </a>
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="concat($query_string, '&amp;page=', //results/@currentpage - 1)" />
            </xsl:attribute>
            <xsl:if test="//results/@currentpage&lt;=1">
                <xsl:attribute name="style">
                    visibility: hidden;
                </xsl:attribute>
            </xsl:if>
            <img src="./images/tango/go-previous.png" />
        </a>

        <div class="page-number">
            <xsl:value-of select="//results/@currentpage" />
        </div>

        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="concat($query_string, '&amp;page=', //results/@currentpage + 1)" />
            </xsl:attribute>
            <xsl:if test="//results/@lastpage&lt;=//results/@currentpage">
                <xsl:attribute name="style">
                    visibility: hidden;
                </xsl:attribute>
            </xsl:if>
            <img src="./images/tango/go-next.png" />
        </a>
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="concat($query_string, '&amp;page=', //results/@lastpage)" />
            </xsl:attribute>
            <xsl:if test="//results/@lastpage&lt;=//results/@currentpage">
                <xsl:attribute name="style">
                    visibility: hidden;
                </xsl:attribute>
            </xsl:if>
            <img src="./images/tango/go-last.png" />
        </a>
    </div>
</xsl:template>

</xsl:stylesheet>
