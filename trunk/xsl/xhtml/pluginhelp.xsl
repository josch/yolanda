<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="pluginhelp">

    <fieldset class="messagebox" id="error">
        <span class="message">
            <xsl:copy-of select="$lang_strings[@id='error_no_ogg_plugin']/node()" />
        </span>
    </fieldset>

    <fieldset class="pluginhelp">

        <legend>
            <xsl:value-of select="$lang_strings[@id='fieldset_pluginhelp']" />
        </legend>

        <xsl:copy-of select="$lang_strings[@id='video_plugin_help']/node()" />

    </fieldset>

</xsl:template>

</xsl:stylesheet>
