<%inherit file="base.mako"/>

<%def name="title()">
    front page
</%def>

<%def name="heading()">
    This Video is lulz.
</%def>

<video
    id="video"
    controls="true"
    poster="${h.url_for('/dummy/poster.png')}"
    src="${h.url_for('http://127.0.0.1:5000/dummy/video.ogv')}"
>

    <div id="messagebox" class="error">
        <h1>Message (error)</h1>
        <span id="message">
            Your browser does not support the &lt;video&gt; element.
<!--
<a href="http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/">Firefox 3.1 nightly builds</a>, <a href="http://labs.opera.com/news/2008/07/18/">Opera experimental builds</a> and <a href="http://www.apple.com/safari/">Safari</a> with <a href="http://xiph.org/quicktime/">XiphQT</a> installed can playback videos with varying degrees of success.
-->
        </span>
    </div>

</video>

<div id="downloads">
    <h1>Downloads</h1>
    <a href="">Download (http)</a>
    <a href="">Download (bittorrent)</a>
</div>

<h1>Embedding</h1>

<table id="embed">
    <tr>
        <td>
            HTML 4.01
        </td>
        <td>
            <code>&lt;object data="http://example.org/download/foobar/" type="video/ogg"&gt;&lt;/object&gt;</code>
        </td>
    </tr>
    <tr>
        <td>
            XHTML 1.1
        </td>
        <td>
            <code>&lt;object data="http://example.org/download/foobar/" type="video/ogg"/&gt;</code>
        </td>
    </tr>
    <tr>
        <td>
            HTML 5
        </td>
        <td>
            <code>&lt;video src="http://example.org/download/foobar/"&gt;&lt;/video&gt;</code>
        </td>
    </tr>
    <tr>
        <td>
            XHTML 5
        </td>
        <td>
            <code>&lt;video src="http://example.org/download/foobar/"/&gt;</code>
        </td>
    </tr>
</table>

<!--
<img
    id="video"
    src="${h.url_for('/dummy/poster.png')}"
/>
-->

