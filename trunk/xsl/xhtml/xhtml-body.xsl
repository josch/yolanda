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

        <xsl:if test="not(//@embed)">

            <xsl:call-template name="header"/>

            <xsl:if test="//message">
                <xsl:call-template name="message"/>
            </xsl:if>

            <xsl:if test="//search">
                <xsl:call-template name="searchbar"/>
            </xsl:if>

        </xsl:if>

        <xsl:choose>
            <xsl:when test="//frontpage">
                <xsl:call-template name="frontpage"/>
            </xsl:when>
            <xsl:when test="//registerform">
                <xsl:call-template name="registerform"/>
            </xsl:when>
            <xsl:when test="//loginform">
                <xsl:call-template name="loginform"/>
            </xsl:when>
            <xsl:when test="//uploadform">
                <xsl:call-template name="uploadform"/>
            </xsl:when>
            <xsl:when test="//search">
                <xsl:call-template name="results"/>
            </xsl:when>
            <xsl:when test="//advancedsearch">
                <xsl:call-template name="advancedsearch"/>
            </xsl:when>
            <xsl:when test="//video">
                <xsl:call-template name="video"/>
            </xsl:when>
            <xsl:when test="//settings">
                <xsl:call-template name="settings"/>
            </xsl:when>
        </xsl:choose>

        <xsl:if test="not(//@embed)">

            <xsl:call-template name="footer"/>

        </xsl:if>

    </body>

</xsl:template>

</xsl:stylesheet>
