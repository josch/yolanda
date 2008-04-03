<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="searchbar">

    <div class="searchbar">

        <form method="get" enctype="text/plain">
            <xsl:attribute name="action">
                <xsl:value-of select="$site_strings[@id='path_search']" />
            </xsl:attribute>
            <fieldset>
                <label for="query">
                    <xsl:value-of select="$locale_strings[@id='search']" />:<br />
                </label>
                <input type="text" name="query">
                    <xsl:attribute name="value">
                        <xsl:if test="//results/@argument='query'">
                            <xsl:value-of select="//results/@value" />
                        </xsl:if>
                    </xsl:attribute>
                </input>
                <input type="submit">
                    <xsl:attribute name="value">
                        <xsl:value-of select="$locale_strings[@id='button_find']" />
                    </xsl:attribute>
                </input>
            </fieldset>
        </form>

        <ul id="queries" role="navigation">

            <li id="latestadditions">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$site_strings[@id='path_query_latestadditions']" />
                    </xsl:attribute>
                    <xsl:value-of select="$locale_strings[@id='query_latestadditions']" />
                </a>
            </li>

            <li id="mostviews">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$site_strings[@id='path_query_mostviews']" />
                    </xsl:attribute>
                    <xsl:value-of select="$locale_strings[@id='query_mostviews']" />
                </a>
            </li>

            <li id="mostdownloads">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$site_strings[@id='path_query_mostdownloads']" />
                    </xsl:attribute>
                    <xsl:value-of select="$locale_strings[@id='query_mostdownloads']" />
                </a>
            </li>

        </ul>

    </div>

</xsl:template>

</xsl:stylesheet>
