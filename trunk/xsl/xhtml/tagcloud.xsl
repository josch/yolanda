<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="tagcloud">

    <xsl:variable name="max" select="//tagcloud/tag/count[not(//tagcloud/tag/count &gt; .)]" />
    <xsl:variable name="min" select="//tagcloud/tag/count[not(//tagcloud/tag/count &lt; .)]" />
    <div class="tagcloud">
        <xsl:for-each select="//tagcloud/tag">
            <xsl:sort select="text" order="ascending" data-type="text" />
            <a class="tag">
                <xsl:attribute name="style">
<!--
                scale /should/ be logarithmic, but that's not widely supported
-->
                    font-size:<xsl:value-of select="round((32-12)*(number(count)-number($min))div (number($max)-number($min)))+12" />px
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:value-of select="concat($site_strings[@id='path_results'],'tag:',text)" />
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
