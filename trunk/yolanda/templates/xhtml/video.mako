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
Sorry, your browser does not support the &lt;video&gt; element. <a href="http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/">Firefox 3.1 nightly builds</a>, <a href="http://labs.opera.com/news/2008/07/18/">Opera experimental builds</a> and <a href="http://www.apple.com/safari/">Safari</a> with <a href="http://xiph.org/quicktime/">XiphQT</a> installed can playback videos with varying degrees of success.
</video>

<a href="">download file</a>

<a href="">download in HD resolution</a>

<!--
<img
    id="video"
    src="${h.url_for('/dummy/poster.png')}"
/>
-->

