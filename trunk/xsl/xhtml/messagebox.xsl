<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="message">

    <fieldset class="messagebox">

        <xsl:attribute name="id">
            <xsl:value-of select="/page/message/@type" />
        </xsl:attribute>

        <span class="message">
            <xsl:variable name="messagetext" select="/page/message/@text" />
            <xsl:value-of select="$lang_strings[@id=$messagetext]" />

            <xsl:choose>

                <xsl:when test="starts-with(/page/message/@value,'http')">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="/page/message/@value" />
                        </xsl:attribute>
                        <xsl:value-of select="/page/message/@value" />
                    </a>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="/page/message/@value" />
                </xsl:otherwise>

            </xsl:choose>

        </span>

    </fieldset>

</xsl:template>

</xsl:stylesheet>
