<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="video">

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

    <xsl:call-template name="video-description" />

    <xsl:call-template name="video-cclicense"/>

    <xsl:call-template name="video-metadata" />

    <xsl:call-template name="video-object" />

    <xsl:call-template name="video-protip-embed" />

<!--
    comment system is broken (similar to the german online petition system)
    if a video ever gets OVER NEIN THOUSAND comments, the shit hits the fan
-->
    <xsl:call-template name="comments"/>


</xsl:template>

<xsl:template name="comments">

    <xsl:call-template name="commentform"/>

    <fieldset id="comments">

        <legend>
            <xsl:value-of select="$lang_strings[@id='fieldset_comments']" />
        </legend>

        <xsl:for-each select="//comments/comment">
            <fieldset class="comment">
                <legend>
                    <a>
                        <xsl:attribute name="href">
                            /user/<xsl:value-of select="@username" />
                        </xsl:attribute>
                        <xsl:value-of select="@username" />
                    </a>
                </legend>
                <!-- TODO: somehow use <xsl:element name="{local-name()}"> to remove the xhtml namespace prefix -->
                <xsl:copy-of select="node()" />
            </fieldset>
        </xsl:for-each>
    </fieldset>

</xsl:template>

<xsl:template name="commentform">

    <xsl:choose>
        <xsl:when test="not(//@username='')">
            <form method="post">
                <xsl:attribute name="action">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:identifier" />
                </xsl:attribute>
                <fieldset>
                    <br />
                    <textarea name="comment" cols="30" rows="3" />
                    <br />
                    <input type="submit" name="send">
                        <xsl:attribute name="value">
                            <xsl:value-of select="$lang_strings[@id='comment_post']" />
                        </xsl:attribute>
                    </input>
                </fieldset>
            </form>
        </xsl:when>
        <xsl:otherwise>
            <fieldset id="commentform">
                <span class="protip">
                    <xsl:value-of select="$lang_strings[@id='login_to_comment']" />
                </span>
            </fieldset>
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>

<xsl:template name="video-cclicense">

    <fieldset id="license">

        <legend>
            <xsl:value-of select="$lang_strings[@id='fieldset_license']" />
        </legend>

<!--
    TODO: make image paths relative
    TODO: internationalized alt attributes

        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="//video/rdf:RDF/cc:License/@rdf:about" />
            </xsl:attribute>
            <xsl:value-of select="$lang_strings[@id='license_conditions']" />:
        </a>
        <br />
-->
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="//video/rdf:RDF/cc:License/@rdf:about" />
            </xsl:attribute>
<!--
            unfinished bizness
            <xsl:value-of select="@rdf:about" />
            <xsl:if test="true()">
                <img src="/images/cc/somerights.png" />
            </xsl:if>
-->
            <xsl:for-each select="//video/rdf:RDF/cc:License/cc:permits">
<!--
                since we are talking about digital media here, distribution actually /is/ reproduction.
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/Reproduction'">
                    <img src="./images/cc/32x32/cc-share.png" />
                </xsl:if>
-->
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/Distribution'">
                    <img alt="share" src="/images/cc/32x32/cc-share.png" />
                </xsl:if>
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/DerivativeWorks'">
                    <img alt="remix" src="/images/cc/32x32/cc-remix.png" />
                </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="//video/rdf:RDF/cc:License/cc:requires">
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/Notice'">
                    <img alt="by" src="/images/cc/32x32/cc-by.png" />
                </xsl:if>
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/ShareAlike'">
                    <img alt="sharealike" src="/images/cc/32x32/cc-sharealike.png" />
                </xsl:if>
<!--
                source code doesn't make much sense in video context
                (the blender people probably would like it)
                still, this is preserved for potential future use.
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/SourceCode'">
                    <img src="/images/cc/32x32/cc-source-code.png" />
                </xsl:if>
-->            </xsl:for-each>

            <xsl:for-each select="//video/rdf:RDF/cc:License/cc:prohibits">        
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/CommercialUse'">
                    <img alt="noncommercial" src="/images/cc/32x32/cc-noncommercial.png" />
                </xsl:if>
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/DerivativeWorks'">
                    <img alt="noderivatives" src="/images/cc/32x32/cc-noderivatives.png" />
                </xsl:if>
            </xsl:for-each>
        </a>
    </fieldset>

</xsl:template>

<!--
filesize

<xsl:value-of select="format-number(number(round(//video/@filesize) div 1048576), '0.0#')" />&#160;<xsl:value-of select="$lang_strings[@id='unit_megabytes']" />)
-->

<xsl:template name="video-description">

    <fieldset id="description">

        <legend>
            <xsl:value-of select="$lang_strings[@id='fieldset_description']" />
        </legend>

        <h1>
            <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:title" />&#160;
            <span class="duration">
                <xsl:variable name="hours" select="floor(//video/@duration div 3600)" />
                <xsl:variable name="minutes" select="floor((//video/@duration - $hours*3600) div 60)" />
                <xsl:variable name="seconds" select="//video/@duration - $minutes*60 - $hours*3600" />
                <xsl:choose>
                    <xsl:when test="$hours=0">
                        <xsl:value-of select="concat(format-number($minutes, '00'), ':', format-number($seconds, '00'))" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($hours, ':', format-number($minutes, '00'), ':', format-number($seconds, '00'))" />
                    </xsl:otherwise>
                </xsl:choose>
            </span>
        </h1>
        <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:description" />
    </fieldset>

</xsl:template>

<xsl:template name="video-metadata">

    <fieldset id="metadata">

        <legend>
            <xsl:value-of select="$lang_strings[@id='fieldset_metadata']" />
        </legend>

        <table class="metadata">

            <tr>
                <td class="metadata-title">
                    <xsl:value-of select="$lang_strings[@id='DC.Creator']" />:
                </td>
                <td class="metadata-content">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:creator" />
                </td>
            </tr>

<!--
            dc:contributor is not in upload interface

            <tr>
                <td class="metadata-title">
                    <xsl:value-of select="$lang_strings[@id='DC.Contributor']" />:
                </td>
                <td class="metadata-content">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:contributor" />
                </td>
            </tr>
-->

            <tr>
                <td class="metadata-title">
                    <xsl:value-of select="$lang_strings[@id='DC.Coverage']" />:
                </td>
                <td class="metadata-content">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:coverage" />
                </td>
            </tr>

            <tr>
                <td class="metadata-title">
                    <xsl:value-of select="$lang_strings[@id='DC.Rights']" />:
                </td>
                <td class="metadata-content">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:rights" />
                </td>
            </tr>

<!--
            <tr>
                <td class="metadata-title">
                    <xsl:value-of select="$lang_strings[@id='DC.Publisher']" />:
                </td>
                <td class="metadata-content">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:publisher" />
                </td>
            </tr>

            <tr>
                <td class="metadata-title">
                    <xsl:value-of select="$lang_strings[@id='DC.Date']" />:
                </td>
                <td class="metadata-content">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:date" />
                </td>
            </tr>
-->

            <tr>
                <td class="metadata-title">
                    <xsl:value-of select="$lang_strings[@id='DC.Source']" />:
                </td>
                <td class="metadata-content">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:source" />
                </td>
            </tr>

        </table>
        
    </fieldset>

</xsl:template>

<xsl:template name="video-object">

    <fieldset id="video">

        <legend>
            <xsl:value-of select="$lang_strings[@id='fieldset_video']" />
        </legend>

        <object type="application/ogg">

            <xsl:attribute name="width">
                <xsl:value-of select="//video/@width" />
            </xsl:attribute>
            <xsl:attribute name="height">
                <xsl:value-of select="//video/@height" />
            </xsl:attribute>
            <xsl:attribute name="data">
                <xsl:value-of select="concat(//video/rdf:RDF/cc:Work/@rdf:about,'view=true')" />
            </xsl:attribute>

            <fieldset class="messagebox" id="error">

                <span class="message">
                    <xsl:value-of select="$lang_strings[@id='error_no_ogg_plugin']" />
                </span>
            </fieldset>

            <xsl:call-template name="pluginhelp" />

        </object>

    </fieldset>

    <fieldset id="preview" style="display: none;">

        <legend>
            <xsl:value-of select="$lang_strings[@id='fieldset_preview']" />
        </legend>

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
            <button
                name="download"
                type="submit"
            >
                <xsl:attribute name="value">
                    <xsl:value-of select="$lang_strings[@id='video_download']" />
                </xsl:attribute>
                <img src="/images/tango/128x128/actions/document-save.png">
                    <xsl:attribute name="alt">
                        <xsl:value-of select="$lang_strings[@id='video_download']" />
                    </xsl:attribute>
                </img>
            </button>
        </form>

    </fieldset>

</xsl:template>

<xsl:template name="video-protip-embed">

    <fieldset id="protip-embed">

        <legend>
            <xsl:value-of select="$lang_strings[@id='fieldset_embed']" />
        </legend>

        <xsl:value-of select="$lang_strings[@id='protip_embed']" />
        <br />
        <code>
            &lt;object data="<xsl:value-of select="concat(//rdf:RDF/cc:Work/dc:identifier, 'xslt=xhtml-embed')" />"
                type="application/xml"
                width="<xsl:value-of select="//video/@width" />"
                height="<xsl:value-of select="//video/@height + 16" />"
            /&gt;
        </code>
    </fieldset>

</xsl:template>

</xsl:stylesheet>
