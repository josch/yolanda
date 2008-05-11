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
                <xsl:value-of select="$lang_strings[@id='footer_license']" />
            </a>
        </li>

        <li>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="$site_strings[@id='path_source-code']" />
                </xsl:attribute>
            <xsl:value-of select="$lang_strings[@id='footer_source_code']" />
            </a>
        </li>

        <li>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="$site_strings[@id='path_report_bug']" />
                </xsl:attribute>
                <xsl:value-of select="$lang_strings[@id='footer_report_bug']" />
            </a>
        </li>

    </ul>

<!--
    <br />
    <xsl:value-of select="$lang_strings[@id='footer_copyright']" />
-->

    <a href="http://validator.w3.org/">
        <img alt="XHTML 1.1" class="antipixel" src="/images/badges/xhtml 1.1.png" />
    </a>

    <a href="http://jigsaw.w3.org/css-validator/">
        <img alt="CSS" class="antipixel" src="/images/badges/css.png" />
    </a>

    <a href="http://www.theora.org/">
        <img alt="Ogg Theora" class="antipixel" src="/images/badges/ogg theora.png" />
    </a>

    <a href="http://www.opensource.org/">
        <img alt="Open Source" class="antipixel" src="/images/badges/open source.png" />
    </a>

    <br />

    <span class="protip">
        <xsl:value-of select="$lang_strings[@id='footer_warranty']" />
    </span>

</xsl:template>

</xsl:stylesheet>
