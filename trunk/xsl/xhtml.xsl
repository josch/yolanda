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

<!-- each xsl:template should have it's own file -->
<xsl:include href="./xhtml/advancedsearch.xsl" />
<xsl:include href="./xhtml/embedded.xsl" />
<xsl:include href="./xhtml/footer.xsl" />
<xsl:include href="./xhtml/header.xsl" />
<xsl:include href="./xhtml/messagebox.xsl" />
<xsl:include href="./xhtml/loginbox.xsl" />
<xsl:include href="./xhtml/register.xsl" />
<xsl:include href="./xhtml/results.xsl" />
<xsl:include href="./xhtml/settings.xsl" />
<xsl:include href="./xhtml/splash.xsl" />
<xsl:include href="./xhtml/searchbar.xsl" />
<xsl:include href="./xhtml/tagcloud.xsl" />
<xsl:include href="./xhtml/upload.xsl" />
<xsl:include href="./xhtml/video.xsl" />
<xsl:include href="./xhtml/xhtml-body.xsl" />
<xsl:include href="./xhtml/xhtml-head.xsl" />

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

<!--
this kills 99% of the processed XML
we have to do this because XHTML + CSS presentation is dependant on the order of XHTML elements
hopefully, CSS 3 will fix this
-->
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

</xsl:stylesheet>
