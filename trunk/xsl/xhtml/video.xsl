<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="video">

    <!--
    <xsl:if test="not(//@embed='true')">        
        <div class="videotitle">
            <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:title" />
            <xsl:variable name="hours" select="floor(//video/@duration div 3600)" />
            <xsl:variable name="minutes" select="floor((//video/@duration - $hours*3600) div 60)" />
            <xsl:variable name="seconds" select="//video/@duration - $minutes*60 - $hours*3600" />
            <xsl:choose>
                <xsl:when test="$hours=0">
                    (<xsl:value-of select="concat(format-number($minutes, '00'), ':', format-number($seconds, '00'))" />)
                </xsl:when>
                <xsl:otherwise>
                    (<xsl:value-of select="concat($hours, ':', format-number($minutes, '00'), ':', format-number($seconds, '00'))" />)
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:if>
-->

    <script type="text/javascript">

<!--
    this looks awfully ugly, but nevertheless generates javascript inside _valid_ XHTML
    kudos to toby white who details the solution on http://scispace.net/tow21/weblog/718.html
-->
    
        <xsl:text disable-output-escaping="yes">&lt;![CDATA[
        <![CDATA[

        function hide_movie()
            {
            document.getElementById('video').style.display = 'none';
            document.getElementById('thumbnail').style.display = 'block';
            document.getElementById('buttons').style.display = 'block';
            }

        function show_movie()
            {
            document.getElementById('video').style.display = 'block';
            document.getElementById('thumbnail').style.display = 'none';
            document.getElementById('buttons').style.display = 'none';
            }

        ]]]]></xsl:text>
        <xsl:text disable-output-escaping="yes">></xsl:text>
    </script>

    <object type="application/ogg" id="video">
        <xsl:attribute name="width">
            <xsl:value-of select="//video/@width" />
        </xsl:attribute>
        <xsl:attribute name="height">
            <xsl:value-of select="//video/@height" />
        </xsl:attribute>
        <xsl:attribute name="data">
            <xsl:value-of select="concat(//video/rdf:RDF/cc:Work/@rdf:about,'view=true')" />
        </xsl:attribute>
        <img src="/images/flash-sucks.png"/><br />
        <img src="/images/vlc.png"/>
        <img src="/images/mplayer.png"/>                    
    </object>

    <img id="thumbnail" style="display: none;">
        <xsl:attribute name="src">
            <xsl:value-of select="//video/@thumbnail" />
        </xsl:attribute>
        <xsl:attribute name="alt">
            <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:title" />
        </xsl:attribute>
        <xsl:attribute name="height">
            <xsl:value-of select="//video/@height" />
        </xsl:attribute>
        <xsl:attribute name="widht">
            <xsl:value-of select="//video/@width" />
        </xsl:attribute>
    </img>

    <form id="buttons" method="get">
        <xsl:attribute name="action">
            <xsl:value-of select="//video/rdf:RDF/cc:Work/@rdf:about" />
        </xsl:attribute>
        <button
            name="playback"
            type="button"
            value="playback"
            onclick="show_movie()">
            <img src="/images/tango/media-playback-start.png" alt="playback" />
            <br />
            <xsl:value-of select="$locale_strings[@id='video_playback']" />
            <br />
            <xsl:variable name="hours" select="floor(//video/@duration div 3600)" />
            <xsl:variable name="minutes" select="floor((//video/@duration - $hours*3600) div 60)" />
            <xsl:variable name="seconds" select="//video/@duration - $minutes*60 - $hours*3600" />
            <xsl:choose>
                <xsl:when test="$hours=0">
                    (<xsl:value-of select="concat(format-number($minutes, '00'), ':', format-number($seconds, '00'))" />)
                </xsl:when>
                <xsl:otherwise>
                    (<xsl:value-of select="concat($hours, ':', format-number($minutes, '00'), ':', format-number($seconds, '00'))" />)
                </xsl:otherwise>
            </xsl:choose>
        </button>
        <button
            name="download"
            type="submit"
            value="download">
            <img src="/images/tango/document-save.png" alt="download" />
            <br />
            <xsl:value-of select="$locale_strings[@id='video_download']" />
            <br />
            (<xsl:value-of select="format-number(number(round(//video/@filesize) div 1048576), '0.0#')" />&#160;<xsl:value-of select="$locale_strings[@id='megabytes']" />)
        </button>
    </form>

    <xsl:if test="not(//@embed='true')">

<!--
        <object type="application/xml" style="float: left">
            <xsl:attribute name="data">
                <xsl:value-of select="concat(//rdf:RDF/cc:Work/dc:identifier, 'embed=video')"/>
            </xsl:attribute>
            <xsl:attribute name="width">
                75%
            </xsl:attribute>
        </object>
-->

        <xsl:call-template name="videometadata"/>
        <br />

        <div class="button-download">
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/@rdf:about" />
                </xsl:attribute>
                <img src="/images/tango/document-save.png" />
            </a>
            <br />
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/@rdf:about" />
                </xsl:attribute>
                <xsl:value-of select="$locale_strings[@id='video_download']" />
            </a>
            <br />
            (<xsl:value-of select="format-number(number(round(//video/@filesize) div 1048576), '0.0#')" />&#160;<xsl:value-of select="$locale_strings[@id='megabytes']" />)
        </div>

        <xsl:call-template name="cclicense"/>

        <div class="videostuff">
            <span class="protip-embed">
                <xsl:value-of select="$locale_strings[@id='protip_embed']" />
                <br />
                <span class="code">
                    &lt;object data="<xsl:value-of select="concat(//rdf:RDF/cc:Work/dc:identifier, 'embed=true')" />"
                        type="application/xml"
                        width=<xsl:value-of select="//video/@width + 24" />
                        height=<xsl:value-of select="//video/@height + 48" />
                    /&gt;
                </span>
            </span>
        </div>

        <xsl:call-template name="commentform"/>
        <xsl:call-template name="comments"/>
    
    </xsl:if>
</xsl:template>

<xsl:template name="comments">

    <div class="comments">
        <xsl:for-each select="//comments/comment">
            <div class="comment">
                <a>
                    <xsl:attribute name="href">
                        /user/<xsl:value-of select="@username" />
                    </xsl:attribute>
                    <xsl:value-of select="@username" />
                </a>:
                <br />
                <xsl:value-of select="." />
            </div>
        </xsl:for-each>
    </div>

</xsl:template>

<xsl:template name="commentform">

    <xsl:choose>
        <xsl:when test="not(//@username='')">
            <div class="commentform">
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
                                <xsl:value-of select="$locale_strings[@id='comment_post']" />
                            </xsl:attribute>
                        </input>
                    </fieldset>
                </form>
            </div>
        </xsl:when>
        <xsl:otherwise>
            <div class="commentform">
                <span class="protip">
                    <xsl:value-of select="$locale_strings[@id='login_to_comment']" />
                </span>
            </div>
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>

<xsl:template name="cclicense">

    <div class="videoccdata">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="//video/rdf:RDF/cc:License/@rdf:about" />
            </xsl:attribute>
            <xsl:value-of select="$locale_strings[@id='license_conditions']" />:
        </a>
        <br />
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="//video/rdf:RDF/cc:License/@rdf:about" />
            </xsl:attribute>
<!--
            unfinished bizness
            <xsl:value-of select="@rdf:about" />
            <xsl:if test="true()">
                <img src="./images/cc/somerights.png" />
            </xsl:if>
-->
            <xsl:for-each select="//video/rdf:RDF/cc:License/cc:permits">
<!--
                since we are talking about digital media here, distribution actually /is/ reproduction
                (also, i was too stupid to figure out how to test for both conditions).
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/Reproduction'">
                    <img src="./images/cc/cc-share.png" />
                </xsl:if>
-->
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/Distribution'">
                    <img src="./images/cc/cc-share.png" />
                </xsl:if>
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/DerivativeWorks'">
                    <img src="./images/cc/cc-remix.png" />
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="rdf:RDF/cc:License/cc:requires">
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/Notice'">
                    <img src="./images/cc/cc-by.png" />
                </xsl:if>
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/ShareAlike'">
                    <img src="./images/cc/cc-sharealike.png" />
                </xsl:if>
<!--
                source code doesn't make much sense in video context.
                still, this is preserved for potential future use.
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/SourceCode'">
                SOURCE
                </xsl:if>
-->
            </xsl:for-each>
            <xsl:for-each select="rdf:RDF/cc:License/cc:prohibits">        
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/CommercialUse'">
                    <img src="./images/cc/cc-noncommercial.png" />
                </xsl:if>
                <xsl:if test="@rdf:resource = 'http://web.resource.org/cc/DerivativeWorks'">
                    <img src="./images/cc/cc-noderivatives.png" />
                </xsl:if>
            </xsl:for-each>
        </a>
    </div>

</xsl:template>

<xsl:template name="videometadata">

    <div class="video-metadata">

        <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:description" />

        <hr />

        <table class="metadata">

            <tr>
                <td class="metadata-title">
                    <xsl:value-of select="$locale_strings[@id='DC.Creator']" />:
                </td>
                <td class="metadata-content">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:creator" />
                </td>
            </tr>

<!--
            dc:contributor is not in upload interface

            <tr>
                <td class="metadata-title">
                    <xsl:value-of select="$locale_strings[@id='DC.Contributor']" />:
                </td>
                <td class="metadata-content">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:contributor" />
                </td>
            </tr>
-->

            <tr>
                <td class="metadata-title">
                    <xsl:value-of select="$locale_strings[@id='DC.Coverage']" />:
                </td>
                <td class="metadata-content">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:coverage" />
                </td>
            </tr>

            <tr>
                <td class="metadata-title">
                    <xsl:value-of select="$locale_strings[@id='DC.Rights']" />:
                </td>
                <td class="metadata-content">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:rights" />
                </td>
            </tr>

        </table>

        <hr />

        <table class="metadata">

            <tr>
                <td class="metadata-title">
                    <xsl:value-of select="$locale_strings[@id='DC.Publisher']" />:
                </td>
                <td class="metadata-content">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:publisher" />
                </td>
            </tr>

            <tr>
                <td class="metadata-title">
                    <xsl:value-of select="$locale_strings[@id='DC.Date']" />:
                </td>
                <td class="metadata-content">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:date" />
                </td>
            </tr>

            <tr>
                <td class="metadata-title">
                    <xsl:value-of select="$locale_strings[@id='DC.Source']" />:
                </td>
                <td class="metadata-content">
                    <xsl:value-of select="//video/rdf:RDF/cc:Work/dc:source" />
                </td>
            </tr>

        </table>
        
    </div>

</xsl:template>

</xsl:stylesheet>
