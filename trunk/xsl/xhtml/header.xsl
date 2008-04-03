<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="header">

    <ul id="header" role="navigation">

        <xsl:choose>
            <xsl:when test="string-length(//@username)=0">

                <li>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$site_strings[@id='path_register']" />
                        </xsl:attribute>
                        <xsl:value-of select="$locale_strings[@id='register']" />
                    </a>
                </li>

<!--
                "login with openid" is obsolete and will be removed in future iterations
-->

                <li>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$site_strings[@id='path_login']" />
                        </xsl:attribute>

                        <xsl:value-of select="$locale_strings[@id='login']" />
                    </a>
                </li>

            </xsl:when>
            <xsl:otherwise>

                <li>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$site_strings[@id='path_upload']" />
                        </xsl:attribute>
                        <xsl:value-of select="$locale_strings[@id='header_upload-video']" />
                    </a>
                </li>

                <li>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$site_strings[@id='path_settings']" />
                        </xsl:attribute>
                        <xsl:value-of select="$locale_strings[@id='settings_details']" />
                    </a>
                </li>

<!--
                <xsl:value-of select="$locale_strings[@id='logged_in_as']" />

                <li>
                    <a>
                        <xsl:attribute name="href">
                            user/<xsl:value-of select="//@username" />
                        </xsl:attribute>
                        <xsl:value-of select="//@username" />
                    </a>
                </li>
-->

                <li>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="$site_strings[@id='path_logout']" />
                        </xsl:attribute>
                        <xsl:value-of select="$locale_strings[@id='logout']" />
                    </a>
                </li>

            </xsl:otherwise>
        </xsl:choose>

    </ul>

</xsl:template>

</xsl:stylesheet>
