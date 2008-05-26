<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="results">

    <xsl:for-each select="//page/results">

       <fieldset class="results">

            <legend>
                <xsl:value-of select="$lang_strings[@id='fieldset_results']" />
            </legend>

            <h1>
                <xsl:value-of select="$lang_strings[@id='results_heading_1']" />&#160;
                <xsl:value-of select="//results/@pagesize * (//results/@currentpage - 1) + 1" />&#160;
                <xsl:value-of select="$lang_strings[@id='results_heading_2']" />&#160;
                <xsl:choose>
                    <xsl:when test="(//results/@pagesize * //results/@currentpage) &lt; //results/@resultcount">
                        <xsl:value-of select="//results/@pagesize * //results/@currentpage" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="//results/@resultcount" />
                    </xsl:otherwise>
                </xsl:choose>&#160;
                <xsl:value-of select="$lang_strings[@id='results_heading_3']" />&#160;
                <xsl:value-of select="//results/@resultcount" />&#160;
                <xsl:value-of select="$lang_strings[@id='results_heading_4']" />
            </h1>

            <xsl:call-template name="results-listing"/>

            <xsl:call-template name="pagination-arrows"/>

        </fieldset>

    </xsl:for-each>

</xsl:template>


<xsl:template name="results-listing">
    <xsl:for-each select="result">
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
            </a>
            <br />
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="rdf:RDF/cc:Work/dc:identifier" />
                </xsl:attribute>
                <xsl:value-of select="rdf:RDF/cc:Work/dc:title" />
            </a>
            <br />
            <span class="duration">
                <xsl:variable name="hours" select="floor(@duration div 3600)" />
                <xsl:variable name="minutes" select="floor((@duration - $hours*3600) div 60)" />
                <xsl:variable name="seconds" select="@duration - $minutes*60 - $hours*3600" />
                <xsl:choose>
                    <xsl:when test="$hours=0">
                        <xsl:value-of select="concat(format-number($minutes, '00'), ':', format-number($seconds, '00'))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($hours, ':', format-number($minutes, '00'), ':', format-number($seconds, '00'))" />
                    </xsl:otherwise>
                </xsl:choose>
            </span>
        </div>
    </xsl:for-each>
</xsl:template>

<xsl:template name="pagination-arrows">

    <div>

        <form class="pagination" method="get" enctype="application/x-www-form-urlencoded">
            <xsl:attribute name="action">
                <xsl:value-of select="$site_strings[@id='path_search']" />
            </xsl:attribute>

            <fieldset>

                <input type="hidden" name="query">
                    <xsl:attribute name="value">
                        <xsl:value-of select="/page/results/@query" />
                    </xsl:attribute>
                </input>
                <input type="hidden" name="page">
                    <xsl:attribute name="value">1</xsl:attribute>
                </input>
                <input type="hidden" name="pagesize">
                    <xsl:attribute name="value">
                        <xsl:value-of select="/page/results/@pagesize" />
                    </xsl:attribute>
                </input>
                <button>
                    <xsl:if test="//results/@currentpage&lt;=1">
                        <xsl:attribute name="disabled">
                            disabled
                        </xsl:attribute>
                    </xsl:if>
                    <img src="/images/tango/48x48/actions/go-first.png" />
                </button>

            </fieldset>

        </form>

        <form class="pagination" method="get" enctype="application/x-www-form-urlencoded">
            <xsl:attribute name="action">
                <xsl:value-of select="$site_strings[@id='path_search']" />
            </xsl:attribute>

            <fieldset>

                <input type="hidden" name="query">
                    <xsl:attribute name="value">
                        <xsl:value-of select="/page/results/@query" />
                    </xsl:attribute>
                </input>
                <input type="hidden" name="page">
                    <xsl:attribute name="value">
                        <xsl:value-of select="/page/results/@currentpage - 1" />
                    </xsl:attribute>
                </input>
                <input type="hidden" name="pagesize">
                    <xsl:attribute name="value">
                        <xsl:value-of select="/page/results/@pagesize" />
                    </xsl:attribute>
                </input>
                <button>
                    <xsl:if test="//results/@currentpage&lt;=1">
                        <xsl:attribute name="disabled">
                            disabled
                        </xsl:attribute>
                    </xsl:if>
                    <img src="/images/tango/48x48/actions/go-previous.png" />
                </button>

            </fieldset>

        </form>

        <form class="pagination" method="get" enctype="application/x-www-form-urlencoded">
            <xsl:attribute name="action">
                <xsl:value-of select="$site_strings[@id='path_search']" />
            </xsl:attribute>

           <fieldset>

                <input type="hidden" name="query">
                    <xsl:attribute name="value">
                        <xsl:value-of select="/page/results/@query" />
                    </xsl:attribute>
                </input>
                <input type="hidden" name="page">
                    <xsl:attribute name="value">
                        <xsl:value-of select="/page/results/@currentpage + 1" />
                    </xsl:attribute>
                </input>
                <input type="hidden" name="pagesize">
                    <xsl:attribute name="value">
                        <xsl:value-of select="/page/results/@pagesize" />
                    </xsl:attribute>
                </input>
                <button>
                    <xsl:if test="//results/@lastpage&lt;=//results/@currentpage">
                        <xsl:attribute name="disabled">
                            disabled
                        </xsl:attribute>
                    </xsl:if>
                    <img src="/images/tango/48x48/actions/go-next.png" />
                </button>

            </fieldset>

        </form>

        <form class="pagination" method="get" enctype="application/x-www-form-urlencoded">
            <xsl:attribute name="action">
                <xsl:value-of select="$site_strings[@id='path_search']" />
            </xsl:attribute>

           <fieldset>

                <input type="hidden" name="query">
                    <xsl:attribute name="value">
                        <xsl:value-of select="/page/results/@query" />
                    </xsl:attribute>
                </input>
                <input type="hidden" name="page">
                    <xsl:attribute name="value">
                        <xsl:value-of select="/page/results/@lastpage" />
                    </xsl:attribute>
                </input>
                <input type="hidden" name="pagesize">
                    <xsl:attribute name="value">
                        <xsl:value-of select="/page/results/@pagesize" />
                    </xsl:attribute>
                </input>
                <button>
                    <xsl:if test="//results/@lastpage&lt;=//results/@currentpage">
                        <xsl:attribute name="disabled">
                            disabled
                        </xsl:attribute>
                    </xsl:if>
                    <img src="/images/tango/48x48/actions/go-last.png" />
                </button>

            </fieldset>

        </form>

        <br />

        <xsl:value-of select="//results/@currentpage" />

    </div>

</xsl:template>

</xsl:stylesheet>
