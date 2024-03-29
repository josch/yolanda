<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="searchbar">

    <form method="get" enctype="application/x-www-form-urlencoded">

        <xsl:attribute name="action">
            <xsl:value-of select="$site_strings[@id='path_search']" />
        </xsl:attribute>

        <fieldset id="searchbar">

            <legend>
                <xsl:value-of select="$lang_strings[@id='search']" />
            </legend>

            <input type="text" name="query">
                <xsl:attribute name="value">
                    <xsl:if test="/page/results/@query">
                        <xsl:value-of select="/page/results/@query" />
                    </xsl:if>
                </xsl:attribute>
            </input>
            <input type="submit">
                <xsl:attribute name="value">
                    <xsl:value-of select="$lang_strings[@id='button_find']" />
                </xsl:attribute>
            </input>

            <ul id="queries" role="navigation">

                <li id="search_custom_one">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$site_strings[@id='path_query_custom_one']" />
                        </xsl:attribute>
                        <xsl:value-of select="$lang_strings[@id='search_custom_one']" />
                    </a>
                </li>

                <li id="search_custom_two">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$site_strings[@id='path_query_custom_two']" />
                        </xsl:attribute>
                        <xsl:value-of select="$lang_strings[@id='search_custom_two']" />
                    </a>
                </li>

                <li id="search_custom_three">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$site_strings[@id='path_query_custom_three']" />
                        </xsl:attribute>
                        <xsl:value-of select="$lang_strings[@id='search_custom_three']" />
                    </a>
                </li>

            </ul>

        </fieldset>
    </form>

</xsl:template>

</xsl:stylesheet>
