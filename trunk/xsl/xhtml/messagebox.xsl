<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="message">

    <div class="messagebox">
        <xsl:attribute name="id">
            <xsl:value-of select="/page/message/@type" />
        </xsl:attribute>
        <xsl:choose>
            <xsl:when test="/page/message/@type='error'">
            </xsl:when>
            <xsl:when test="/page/message/@type='information'">
            </xsl:when>
            <xsl:when test="/page/message/@type='warning'">
            </xsl:when>
        </xsl:choose>
        <xsl:variable name="messagetext" select="/page/message/@text" />
        <strong>
            <xsl:value-of select="$locale_strings[@id=$messagetext]" />
            <xsl:value-of select="/page/message/@value" />
            <!-- probably one can do this on one line, dunno how -->
        </strong>
    </div>

</xsl:template>

</xsl:stylesheet>
