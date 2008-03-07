<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="header">

    <div class="header">

        <a class="header latest-additions">
            <xsl:attribute name="href">
                <xsl:value-of select="$site_strings[@id='path_query_latestadditions']" />
            </xsl:attribute>
            <xsl:value-of select="$locale_strings[@id='query_latestadditions']" />
        </a>

        <a class="header most-views">
            <xsl:attribute name="href">
                <xsl:value-of select="$site_strings[@id='path_query_mostviews']" />
            </xsl:attribute>
            <xsl:value-of select="$locale_strings[@id='query_mostviews']" />
        </a>

        <a class="header most-downloads">
            <xsl:attribute name="href">
                <xsl:value-of select="$site_strings[@id='path_query_mostdownloads']" />
            </xsl:attribute>
            <xsl:value-of select="$locale_strings[@id='query_mostdownloads']" />
        </a>

        <xsl:choose>
            <xsl:when test="string-length(//@username)=0">

<!--
                <a class="header">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$site_strings[@id='path_login']" />
                    </xsl:attribute>
                    <xsl:value-of select="$locale_strings[@id='header_login-to-upload']" />
                </a>
-->
                <a class="header register">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$site_strings[@id='path_register']" />
                    </xsl:attribute>
                    <xsl:value-of select="$locale_strings[@id='register']" />
                </a>

                <a class="header login">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$site_strings[@id='path_login']" />
                    </xsl:attribute>
                    <xsl:value-of select="$locale_strings[@id='login']" />
                </a>

                <a class="header login-openid">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$site_strings[@id='path_login-openid']" />
                    </xsl:attribute>

                    <xsl:value-of select="$locale_strings[@id='login_openid']" />
                </a>

            </xsl:when>
            <xsl:otherwise>

                <a class="header upload-video">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$site_strings[@id='path_upload']" />
                    </xsl:attribute>
                    <xsl:value-of select="$locale_strings[@id='header_upload-video']" />
                </a>

                <a class="header preferences">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$site_strings[@id='path_settings']" />
                    </xsl:attribute>
                    <xsl:value-of select="$locale_strings[@id='settings_details']" />
                </a>

<!--
                <xsl:value-of select="$locale_strings[@id='logged_in_as']" />

                <a class="header">
                    <xsl:attribute name="href">
                        user/<xsl:value-of select="//@username" />
                    </xsl:attribute>
                    <xsl:value-of select="//@username" />
                </a>
-->

                <a class="header logout">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$site_strings[@id='path_logout']" />
                    </xsl:attribute>
                    <xsl:value-of select="$locale_strings[@id='logout']" />
                </a>

            </xsl:otherwise>
        </xsl:choose>

    </div>

</xsl:template>

</xsl:stylesheet>
