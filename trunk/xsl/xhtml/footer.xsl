<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="footer">

    <ul id="footer" role="navigation">

        <li>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="$site_strings[@id='path_license']" />
                </xsl:attribute>
                <xsl:value-of select="$locale_strings[@id='footer_license']" />
            </a>
        </li>

        <li>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="$site_strings[@id='path_source-code']" />
                </xsl:attribute>
            <xsl:value-of select="$locale_strings[@id='footer_source_code']" />
            </a>
        </li>

        <li>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="$site_strings[@id='path_report_bug']" />
                </xsl:attribute>
                <xsl:value-of select="$locale_strings[@id='footer_report_bug']" />
            </a>
        </li>

    </ul>

<!--
    <br />
    <xsl:value-of select="$locale_strings[@id='footer_copyright']" />
-->

    <span class="protip">
        <xsl:value-of select="$locale_strings[@id='footer_warranty']" />
    </span>
    <br />
    <img alt="AGPL 3 Free Software">
        <xsl:attribute name="src">
            <xsl:value-of select="$site_strings[@id='path_root']" />/images/agplv3-155x51.png
        </xsl:attribute>
    </img>

</xsl:template>

</xsl:stylesheet>
