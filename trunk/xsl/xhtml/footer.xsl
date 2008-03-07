<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="footer">

    <div class="footer">

        <a class="footer view-license">
            <xsl:attribute name="href">
                <xsl:value-of select="$site_strings[@id='path_license']" />
            </xsl:attribute>
            <xsl:value-of select="$locale_strings[@id='footer_license']" />
        </a>

        <a class="footer view-source-code">
            <xsl:attribute name="href">
                <xsl:value-of select="$site_strings[@id='path_source-code']" />
            </xsl:attribute>
        <xsl:value-of select="$locale_strings[@id='footer_source_code']" />
        </a>

        <a class="footer report-bug">
            <xsl:attribute name="href">
                <xsl:value-of select="$site_strings[@id='path_report_bug']" />
            </xsl:attribute>
            <xsl:value-of select="$locale_strings[@id='footer_report_bug']" />
        </a>

        <a class="footer view-xml">
            <xsl:attribute name="href">
<!--
        caveat: this currently does not work on root level
        apache magic wanted
-->
                ?xslt=null
            </xsl:attribute>
            <xsl:value-of select="$locale_strings[@id='footer_view_xml']" />
        </a>

    </div>

<!--
    <br />
    <xsl:value-of select="$locale_strings[@id='footer_copyright']" />
-->

    <br />

    <span class="protip">
        <xsl:value-of select="$locale_strings[@id='footer_warranty']" />
    </span>

</xsl:template>

</xsl:stylesheet>
