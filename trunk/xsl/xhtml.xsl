<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:output
    doctype-public="-//W3C//DTD XHTML 1.1//EN"
    doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
    encoding="UTF-8"
    indent="yes"
    method="xml"
    media-type="application/xhtml+xml"
    omit-xml-declaration="no"
/>

<xsl:include href="./xhtml/advancedsearch.xsl"/>
<xsl:include href="./xhtml/embedded.xsl"/>
<xsl:include href="./xhtml/footer.xsl"/>
<xsl:include href="./xhtml/frontpage.xsl"/>
<xsl:include href="./xhtml/header.xsl"/>
<xsl:include href="./xhtml/loginform.xsl"/>
<xsl:include href="./xhtml/register.xsl"/>
<xsl:include href="./xhtml/results.xsl"/>
<xsl:include href="./xhtml/settings.xsl"/>
<xsl:include href="./xhtml/upload.xsl"/>
<xsl:include href="./xhtml/video.xsl"/>
<xsl:include href="./xhtml/xhtml-body.xsl"/>
<xsl:include href="./xhtml/xhtml-head.xsl"/>

<xsl:variable name="locale">
    <xsl:choose>
        <xsl:when test="document(concat('../locale/', //@locale, '.xml'))">
            <xsl:value-of select="//@locale" />
        </xsl:when>
        <xsl:otherwise>en-us</xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<xsl:variable name="site_strings" select="document('../site/main.xml')//strings/string" />
<xsl:variable name="locale_strings" select="document(concat('../locale/', $locale, '.xml'))//strings/string" />

<!-- this kills 99% of the processed XML... sorry Tim Bray.... -->
<!-- had to look up Bray in Wikipedia, 2 points off my geek score -->
<xsl:template match="@*|node()">
    <xsl:if test="not(/)">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:if>
</xsl:template>

<xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">

    <xsl:call-template name="xhtml-head" />

    <xsl:call-template name="xhtml-body" />

    </html>
</xsl:template>

<xsl:template name="searchbar">

    <div class="search-small">
        <form method="get" enctype="text/plain">
            <xsl:attribute name="action">
                <xsl:value-of select="$site_strings[@id='path_results']" />
            </xsl:attribute>
            <fieldset>
                <xsl:value-of select="$locale_strings[@id='search']" />:
                <input type="text" name="query" size="15">
                    <xsl:attribute name="value">
                        <xsl:if test="//results/@argument='query'">
                            <xsl:value-of select="//results/@value" />
                        </xsl:if>
                    </xsl:attribute>
                </input>
            </fieldset>
        </form>
    </div>

</xsl:template>

<xsl:template name="message">

    <div class="messagebox">
        <xsl:attribute name="id">
            <xsl:value-of select="/page/message/@type" />
        </xsl:attribute>
        <xsl:choose>
            <xsl:when test="/page/message/@type='error'">
                <img src="/images/tango/dialog-error.png" />
            </xsl:when>
            <xsl:when test="/page/message/@type='information'">
                <img src="/images/tango/dialog-information.png" />
            </xsl:when>
            <xsl:when test="/page/message/@type='warning'">
                <img src="/images/tango/dialog-warning.png" />
            </xsl:when>
        </xsl:choose>
        <xsl:variable name="messagetext" select="/page/message/@text" />
        <xsl:value-of select="$locale_strings[@id=$messagetext]" />
        <xsl:value-of select="/page/message/@value" />
        <!-- probably one can do this on one line, dunno how -->
    </div>

</xsl:template>

</xsl:stylesheet>
