<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="frontpage">

    <img class="logo-big" src="/images/logo-big.png" alt="Yolanda logo (320x100)" />

    <div class="search">
        <form method="get" enctype="text/plain">
            <xsl:attribute name="action">
                <xsl:value-of select="$site_strings[@id='path_results']" />
            </xsl:attribute>
            <fieldset>
                <input type="text" name="query" size="40" /><br />
                <input type="submit">
                    <xsl:attribute name="value">
                        <xsl:value-of select="$locale_strings[@id='button_find']" />
                    </xsl:attribute>
                </input>
                <input type="submit" name="lucky">
                    <xsl:attribute name="value">
                        <xsl:value-of select="$locale_strings[@id='button_lucky']" />
                    </xsl:attribute>
                </input>
                <input type="submit" name="advanced">
                    <xsl:attribute name="value">
                        <xsl:value-of select="$locale_strings[@id='button_advanced']" />
                    </xsl:attribute>
                </input>
            </fieldset>
        </form>
    </div>

    <div class="toplists">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="$site_strings[@id='path_query_latestadditions']" />
            </xsl:attribute>
            <xsl:value-of select="$locale_strings[@id='query_latestadditions']" />
        </a>
        <xsl:value-of select="$locale_strings[@id='separator']" />
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="$site_strings[@id='path_query_mostdownloads']" />
            </xsl:attribute>
            <xsl:value-of select="$locale_strings[@id='query_mostdownloads']" />
        </a>
        <xsl:value-of select="$locale_strings[@id='separator']" />
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="$site_strings[@id='path_query_mostviews']" />
            </xsl:attribute>
            <xsl:value-of select="$locale_strings[@id='query_mostviews']" />
        </a>
    </div>

    <xsl:call-template name="tagcloud"/>

</xsl:template>

<xsl:template name="tagcloud">
    <xsl:variable name="max" select="//tagcloud/tag/count[not(//tagcloud/tag/count &gt; .)]" />
    <xsl:variable name="min" select="//tagcloud/tag/count[not(//tagcloud/tag/count &lt; .)]" />
    <div class="tagcloud">
        <xsl:for-each select="//tagcloud/tag">
            <xsl:sort select="text" order="ascending" data-type="text" />
            <a class="tag">
                <xsl:attribute name="style">
<!--
                scale *should* be logarihmic, but that's not widely supportet
-->
                    font-size:<xsl:value-of select="round((32-12)*(number(count)-number($min))div (number($max)-number($min)))+12" />px
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:value-of select="$site_strings[@id='path_results']" />
                    tag:
                    <xsl:value-of select="text" />
                </xsl:attribute>
                
                <xsl:value-of select="text" />
<!--
                unnecessary, except for debug purposes
                (<xsl:value-of select="count" />)
-->
            </a>
            &#8204;
        </xsl:for-each>
    </div>

</xsl:template>

</xsl:stylesheet>
