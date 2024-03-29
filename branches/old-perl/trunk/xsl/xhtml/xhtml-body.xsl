<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:xforms="http://www.w3.org/2002/xforms"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
>

<xsl:template name="xhtml-body">

    <body>

        <xsl:if test="/page/video">
            <xsl:attribute name="onload">
                 hide_movie()
            </xsl:attribute>
        </xsl:if>

        <xsl:if test="/page/xforms:instance">
            <xsl:attribute name="onload">
                 show_page_1()
            </xsl:attribute>
        </xsl:if>

        <xsl:call-template name="header"/>

        <xsl:call-template name="searchbar" />

        <xsl:if test="string-length(//@username)=0">
            <xsl:call-template name="loginbox" />
        </xsl:if>

        <xsl:if test="//message">
            <xsl:call-template name="message"/>
        </xsl:if>

        <xsl:choose>

            <xsl:when test="//frontpage">
                <xsl:call-template name="tagcloud" />

                <xsl:call-template name="splashbox" />

                <xsl:call-template name="results"/>
            </xsl:when>

            <xsl:when test="/page/video">
                <xsl:call-template name="video"/>
            </xsl:when>

            <xsl:when test="/page/results">
                <xsl:call-template name="results"/>
            </xsl:when>

            <xsl:when test="/page/xforms:instance">
                <xsl:call-template name="uploadform"/>
            </xsl:when>

        </xsl:choose>

        <xsl:choose>
            <xsl:when test="//registerform">
                <xsl:call-template name="registerform"/>
            </xsl:when>
            <xsl:when test="//loginform">
                <xsl:call-template name="loginform"/>
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
