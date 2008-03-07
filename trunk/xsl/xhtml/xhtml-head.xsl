<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="xhtml-head">

        <head>
            <meta http-equiv="Content-Type" content="application/xhtml+xml;charset=utf-8" />

            <xsl:choose>
                <xsl:when test="not(//@embed)">
                    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon.ico" />
                    <link rel="stylesheet" type="text/css">
                        <xsl:attribute name="href">
                            <xsl:value-of select="//@stylesheet" />
                        </xsl:attribute>
                    </link>
                </xsl:when>
                <xsl:when test="//@embed='video'">
<!--
                embedded stylesheet should rather be done through URL like
                "http://localhost/video/4chan%20city/3/embed=true+stylesheet=embedded.css"
-->
                    <link rel="stylesheet" type="text/css">
                        <xsl:attribute name="href">
                            /style/embedded.css
                        </xsl:attribute>
                    </link>
                </xsl:when>
            </xsl:choose>

            <xsl:if test="boolean(//results)">

                <link rel="alternate" type="application/rss+xml">
                    <xsl:attribute name="title">
                        <xsl:value-of select="$locale_strings[@id='rss_title_results_this_page']" />
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$site_strings[@id='path_root']" />
                        <xsl:value-of select="$site_strings[@id='path_results']" />
                        <xsl:value-of select="//results/@query" />
                        &amp;pagesize=<xsl:value-of select="//results/@pagesize" />
                        &amp;page=<xsl:value-of select="//results/@page" />
                        &#38;xslt=rss
                    </xsl:attribute>
                </link>

                <link rel="alternate" type="application/rss+xml">
                    <xsl:attribute name="title">
                        <xsl:value-of select="$locale_strings[@id='rss_title_results_all_pages']" />
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$site_strings[@id='path_root']" />
                        <xsl:value-of select="$site_strings[@id='path_results']" />
                        <xsl:value-of select="//results/@query" />
                        &amp;pagesize=99999
                        &amp;page=1
                        &#38;xslt=rss
                    </xsl:attribute>
                </link>

            </xsl:if>

            <link
                rel="search"
                type="application/opensearchdescription+xml"
            >
                <xsl:attribute name="href">
                    <xsl:value-of select="$site_strings[@id='path_root']" />?xslt=opensearch
                </xsl:attribute>
                <xsl:attribute name="title">
                    <xsl:value-of select="$site_strings[@id='site_name']" />
                </xsl:attribute>
            </link>

            <title>
                <xsl:choose>
                    <xsl:when test="boolean(//frontpage)">
                        <xsl:value-of select="$site_strings[@id='site_name']" />
                        -
                        <xsl:value-of select="$site_strings[@id='site_motto']" />
                    </xsl:when>
                    <xsl:when test="boolean(//resultspage)">
                        <xsl:value-of select="$site_strings[@id='site_name']" />
                        -
                        <xsl:value-of select="$locale_strings[@id='results_for_query']" />
                        "<xsl:value-of select="//resultspage/@query" />"
                    </xsl:when>
                    <xsl:otherwise>
<!--
                    this seems to be fail
                    should be fixed somehow
-->
                        <xsl:value-of select="$site_strings[@id='site_name']" />
                        -
                        <xsl:value-of select="$site_strings[@id='site_motto']" />
                    </xsl:otherwise>
                </xsl:choose>
            </title>
        </head>

</xsl:template>

</xsl:stylesheet>
