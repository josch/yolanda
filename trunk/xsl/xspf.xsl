<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://xspf.org/ns/0/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:output
    encoding="utf8"
    indent="yes"
    method="xml"
    media-type="application/xspf+xml"
    omit-xml-declaration="no"
/>

<xsl:template match="/">
    <xsl:apply-templates />
</xsl:template>

<xsl:template match="results">

    <playlist version="0">
        <trackList>
            <xsl:for-each select="result">
                <track>
                    <location>
                        <xsl:value-of select="rdf:RDF/cc:Work/@rdf:about" />
                    </location>
                    <title>
                        <xsl:value-of select="rdf:RDF/cc:Work/dc:title" />
                    </title>
                    <creator>
                        <xsl:value-of select="rdf:RDF/cc:Work/dc:creator" />
                    </creator>
                    <annotation>
                        <xsl:value-of select="rdf:RDF/cc:Work/dc:description" />
                    </annotation>
                    <info>
                        <xsl:value-of select="rdf:RDF/cc:Work/dc:identifier" />
                    </info>
                    <image>
                        <xsl:value-of select="thumbnail" />
                    </image>
                </track>
            </xsl:for-each>
        </trackList>
    </playlist>

</xsl:template>


</xsl:stylesheet>
