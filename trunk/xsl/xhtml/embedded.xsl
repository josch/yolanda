<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="embedded">

    <h1>embedded stuff here</h1>

    <div class="embedded-backlink">
        <a target="_blank">
            <xsl:attribute name="href">
                <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:identifier" />
            </xsl:attribute>
            <xsl:value-of select="$lang_strings[@id='backlink']" />
        </a>
    </div>

</xsl:template>

</xsl:stylesheet>
