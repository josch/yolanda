<%inherit file="base.mako"/>

<%def name="title()">
    account stuff
</%def>

<%def name="heading()">
    account login / logout
</%def>

<div class="privacy">
    <img src="${h.url_for('/images/privacy/username.png')}" alt="username"/>
    <img src="${h.url_for('/images/privacy/saved.png')}" alt="will be saved"/>
    <img src="${h.url_for('/images/privacy/forever.png')}" alt="forever"/>
</div>

<form action="${h.url_for('/account/login')}" method="post">

    <label for="username">OpenID:</label>
    <input id="username" name="openid_identifier" type="url" value="http://"/>

    <a href="http://openid.net/what/">What is OpenID ?</a>

    <label>Remember me</label>
    <input id="rememberme" type="checkbox" tabindex="90" value="forever" name="rememberme"/>

    <input type="submit" value="Login (OpenID)"/>
    
</form>
