<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://purl.org/rss/1.0/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:output
    encoding="utf8"
    indent="yes"
    method="xml"
    media-type="application/rss+xml"
    omit-xml-declaration="no"
/>

<xsl:variable name="lang">
    <xsl:choose>
        <xsl:when test="document(concat('../lang/', //@lang, '.xml'))">
            <xsl:value-of select="//@lang" />
        </xsl:when>
        <xsl:otherwise>en</xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<xsl:variable name="site_strings" select="document('../config/frontend.xml')//strings/string" />
<xsl:variable name="lang_strings" select="document(concat('../lang/', $lang, '.xml'))//strings/string" />

<xsl:template match="/">
    <xsl:apply-templates />
</xsl:template>

<xsl:template match="results">

    <rdf:RDF>

        <channel>
            <xsl:attribute name="rdf:about">
                <xsl:value-of select="$site_strings[@id='path_root']" />
                <xsl:value-of select="$site_strings[@id='path_results']" />
                <xsl:value-of select="//results/@query" />&#38;xslt=rss
            </xsl:attribute>
            <title>
                <xsl:value-of select="$site_strings[@id='site_name']" />
                <xsl:value-of select="$lang_strings[@id='rss_separator']" />
                <xsl:value-of select="//results/@query" />
            </title>
            <link>
                <xsl:value-of select="$site_strings[@id='path_root']" />
                <xsl:value-of select="$site_strings[@id='path_results']" />
                <xsl:value-of select="//results/@query" />&#38;
            </link>
            <description>
                <xsl:value-of select="$lang_strings[@id='rss_description_1']" />
                <xsl:value-of select="//results/@query" />
                <xsl:value-of select="$lang_strings[@id='rss_description_2']" />
            </description>
        </channel>

        <xsl:for-each select="result">
             <item>
                <title>
                    <xsl:value-of select="rdf:RDF/cc:Work/dc:title" />
                </title>
                <description>
                    <xsl:value-of select="rdf:RDF/cc:Work/dc:description" />
                </description>
                <link>
                    <xsl:value-of select="rdf:RDF/cc:Work/@rdf:about" />
                </link>
            </item>
        </xsl:for-each>

    </rdf:RDF>

</xsl:template>


</xsl:stylesheet>
