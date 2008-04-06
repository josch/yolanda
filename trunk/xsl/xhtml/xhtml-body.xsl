<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="xhtml-body">

    <body>

        <xsl:if test="//video">
            <xsl:attribute name="onload">
                 hide_movie()
            </xsl:attribute>
        </xsl:if>

        <xsl:call-template name="header"/>

        <xsl:choose>
            <xsl:when test="//frontpage">
                <xsl:call-template name="searchbar" />
                <xsl:call-template name="loginbox" />
                <xsl:call-template name="tagcloud" />

                <xsl:if test="//message">
                    <xsl:call-template name="message"/>
                </xsl:if>

                <xsl:call-template name="splashbox" />
            </xsl:when>

            <xsl:when test="//page/video">
                <xsl:call-template name="searchbar" />
<!--
                <xsl:call-template name="tagbar" />
-->

                <xsl:if test="//message">
                    <xsl:call-template name="message"/>
                </xsl:if>

                <xsl:call-template name="video"/>
            </xsl:when>

            <xsl:when test="//page//results">
                <xsl:call-template name="searchbar" />
                <xsl:call-template name="results"/>
            </xsl:when>
        </xsl:choose>

        <xsl:choose>
            <xsl:when test="//registerform">
                <xsl:call-template name="registerform"/>
            </xsl:when>
            <xsl:when test="//loginform">
                <xsl:call-template name="loginform"/>
            </xsl:when>
            <xsl:when test="//uploadform">
                <xsl:call-template name="uploadform"/>
            </xsl:when>
            <xsl:when test="//advancedsearch">
                <xsl:call-template name="advancedsearch"/>
            </xsl:when>
            <xsl:when test="//settings">
                <xsl:call-template name="settings"/>
            </xsl:when>
        </xsl:choose>

        <xsl:call-template name="footer"/>

    </body>

</xsl:template>

</xsl:stylesheet>
