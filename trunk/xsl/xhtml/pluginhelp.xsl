<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:cc="http://web.resource.org/cc/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template name="pluginhelp">

        <div class="pluginhelp" style="margin-right:22em;">

            <h1>Common Questions</h1>

         <h2>Why Not Use Flash ?</h2>
            <p>
                Many video sharing sites use the <a href="http://www.adobe.com/de/products/flashplayer/"><em>Adobe Flash Plugin</em></a> to play embedded video.
                We disapprove of that because <em>Flash</em> is <em>proprietary</em> (not <a href="http://www.gnu.org/philosophy/free-sw.html"><em>free software</em></a>).
            </p>
            <p>
                Additionally, well-known video formats like <a href="http://en.wikipedia.org/wiki/Divx"><em>DivX</em></a> or <a href="http://en.wikipedia.org/wiki/H264"><em>H.264</em></a> are <a href="http://en.wikipedia.org/wiki/H264#Patent_licensing">patent-encumbered</a> in many countries.
                Because license fees have to be paid for usage, it might be a legal risk to include them in free software:
                <a href="http://www.gnu.org/"><em>GNU</em></a>/<a href="http://kernel.org/"><em>Linux</em></a> distributions like <a href="http://www.debian.org/"><em>Debian</em></a> or <a href="http://www.ubuntu.com/"><em>Ubuntu</em></a> do not include them in their default installation.
            </p>
            <p>
                Therefore, Yolanda uses the <a href="http://en.wikipedia.org/wiki/Ogg"><em>Ogg</em></a> container format containing the codecs <a href="http://www.theora.org/"><em>Theora</em></a> and <a href="http://www.vorbis.com/"><em>Vorbis</em></a>, which are maintained by <a href="http://www.xiph.org/"><em>Xiph.org</em></a>.
                As of 2008, <em>Ogg</em> and <em>Vorbis</em> are free of patent claims and all known patents regarding <em>Theora</em> have been donated to the public.
            </p>

            <h2>Which Plugins Do I Have to Download ?</h2>
            <p>
            Each media player plugin that can play <em>Ogg Theora + Vorbis</em> can be used.
            While there are several plugins that qualify, this section will only focus on three of them, that are also <em>free software</em>.
            </p>

            <h3>VLC Media Player</h3>
            <p>
                <img class="icon-mediaplayer" src="/images/vlc.png"/>
                The <em>VLC Media Player</em>, started by students of <em>École Centrale Paris</em> plays almost any video format on a wide range of platforms.
                Be sure to install the <em>Mozilla</em> plugin or you will die a horrible, agonizing death.
            </p>
            <p>
                Downloads can be found on the <a href="http://www.videolan.org/vlc/">Videolan web page</a>.
                Be sure to check your operating systems software repository before downloading untrusted binaries from questionable sources.
            </p>

            <h3>Mplayer</h3>
            <p>
                <img class="icon-mediaplayer" src="/images/mplayer.png"/>
                <em>Mplayer</em>, the media player for <em>EXPERT PROGRAMMERS</em>, is only available for <em>real</em> operating systems.
                It does work with both <em>Mozilla</em> and <em>Konqueror</em>.
            </p>
            <p>
                Downloads can be found on the <a href="http://www.mplayerhq.hu/design7/dload.html">Mplayer web page</a>.
                Be sure to check your operating systems software repository before downloading untrusted binaries from questionable sources.
            </p>

            <h3>Totem</h3>
            <p>
                <img class="icon-mediaplayer" src="/images/totem.png"/>
                <em>Totem</em> is the default media player in <a href="http://www.gnome.org/"><em>GNOME</em></a> and therefore only used by <em>SPIDER EXPERTS</em> like <em>Miguel de Icaza</em>.
            </p>
            <p>
                Downloads can and should not be found, go ask <em>Miguel</em> for the <em>OOXML</em> specification instead.
            </p>

        </div>

</xsl:template>

</xsl:stylesheet>
