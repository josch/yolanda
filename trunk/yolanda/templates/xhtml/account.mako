<%inherit file="base.mako"/>

<%def name="title()">
    account stuff
</%def>

<%def name="heading()">
    account login / logout
</%def>

<p>The following information will be saved.</p>


<form action="${h.url_for('account/login')}" method="post">

    <label for="username">OpenID:</label>
    <input id="username" name="username" type="url"/>

    <input type="submit" value="Login (OpenID)"/>
    
</form>
