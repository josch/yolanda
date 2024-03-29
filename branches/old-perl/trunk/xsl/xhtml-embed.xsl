<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
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

<xsl:include href="./xhtml/pluginhelp.xsl" />

<xsl:variable name="lang">
    <xsl:choose>
        <xsl:when test="document(concat('../lang/', //@lang, '.xml'))">
            <xsl:value-of select="//@lang" />
        </xsl:when>
        <xsl:otherwise>en</xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<xsl:variable name="lang_strings" select="document(concat('../lang/', $lang, '.xml'))//strings/string" />

<xsl:template match="/">
    <html>

        <head>

            <link
                rel="stylesheet"
                type="text/css"
                media="screen"
                href="/style/embedded.css"
            />

        </head>

        <body onload="hide_movie()">

            <xsl:call-template name="video-script" />

            <xsl:call-template name="video-object" />

        </body>

    </html>
</xsl:template>

<xsl:template name="video-script">

    <script type="text/javascript">

    <!--
    this looks awfully ugly, but nevertheless generates javascript inside _valid_ XHTML
    kudos to toby white who details the solution on http://scispace.net/tow21/weblog/718.html
    -->

        <xsl:text disable-output-escaping="yes">&lt;![CDATA[
        <![CDATA[

        function hide_movie()
            {
            document.getElementById('video').style.display      = 'none';
            document.getElementById('preview').style.display    = 'block';
            }

        function show_movie()
            {
            document.getElementById('video').style.display      = 'block';
            document.getElementById('preview').style.display    = 'none';
            window.setTimeout("hide_movie()",
        ]]>
        </xsl:text>
    <!--
        window.setTimeout is the stupidest hack i could imagine
        it doesn't work reliably because of BUFFERING, but
        3 seconds for initializing should be enough for short video ...
    -->
        <xsl:value-of select="(//video/@duration + 3) * 1000" />
        <xsl:text disable-output-escaping="yes">
        <![CDATA[
            );
            }
        ]]]]></xsl:text>
        <xsl:text disable-output-escaping="yes">></xsl:text>
    </script>

</xsl:template>

<xsl:template name="video-object">

    <object id="video" type="application/ogg">

        <xsl:attribute name="width">
            <xsl:value-of select="//video/@width" />
        </xsl:attribute>
        <xsl:attribute name="height">
            <xsl:value-of select="//video/@height" />
        </xsl:attribute>
        <xsl:attribute name="data">
            <xsl:value-of select="concat(//video/rdf:RDF/cc:Work/@rdf:about,'view=true')" />
        </xsl:attribute>
 
        <xsl:call-template name="pluginhelp" />

    </object>

    <div id="preview" style="display: none;">

        <img>
            <xsl:attribute name="src">
                <xsl:value-of select="//video/@preview" />
            </xsl:attribute>
            <xsl:attribute name="alt">
                <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:title" />
            </xsl:attribute>
            <xsl:attribute name="height">
                <xsl:value-of select="//video/@height" />
            </xsl:attribute>
            <xsl:attribute name="width">
                <xsl:value-of select="//video/@width" />
            </xsl:attribute>
        </img>

        <form>
            <xsl:attribute name="action">
                <xsl:value-of select="//video/rdf:RDF/cc:Work/@rdf:about" />
            </xsl:attribute>
            <button
                name="playback"
                type="button"
                onclick="show_movie()"
            >
                <xsl:attribute name="value">
                    <xsl:value-of select="$lang_strings[@id='video_playback']" />
                </xsl:attribute>
                <img src="/images/tango/128x128/actions/player_play.png">
                    <xsl:attribute name="alt">
                        <xsl:value-of select="$lang_strings[@id='video_playback']" />
                    </xsl:attribute>
                </img>
            </button>
        </form>

    </div>

</xsl:template>

</xsl:stylesheet>
