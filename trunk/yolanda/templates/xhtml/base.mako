<?xml version="1.0" ?>
<!DOCTYPE html>
<!-- XHTML 5, baby ! -->

<%def name="search()">

    <div id="search">

        <h1>Search</h1>

        <form action="${h.url_for('search_results')}" method="get">

            <input id="query" name="query" type="text"/>
            <input type="submit" value="Search"/>

        </form>

<!--
        <ul id="queries">

            <li id="important">
                <a href="">
                    Important matters
                </a>
            </li>

            <li id="popular">
                <a href="">
                    Popular garbage
                </a>
            </li>

            <li id="new">
                <a href="">
                    Totally new stuff
                </a>
            </li>

        </ul>
-->

    </div>
</%def>

<%def name="login()">
    <div id="login">

        <h1>Login</h1>

        <form action="${h.url_for('account/login')}" 
method="post">

            <input id="username" name="username" type="url"/>
            <input type="submit" value="Login (OpenID)"/>

        </form>

    </div>
</%def>

<%def name="messagebox()">

%if c.message:
    <div id="messagebox" class="${c.message['type']}">
        <h1>${c.message['type']}</h1>
        <strong>${c.message['text']}</strong>
    </div>
%endif

</%def>


<%def name="tagcloud()">

    <a href="#content" style="display:none;">
        Skip tagcloud.
    </a>

    <div id="tagcloud">

        <h1>Tagcloud</h1>

            <ul>
            % for tag in c.tagcloud:

                <li>
                    <a href="" class="tag4">${tag.name}</a>
                </li>

            % endfor
            </ul>

    </div>
</%def>

<%def name="account_actions()">

    <div id="account-actions">

        <h1>Account actions</h1>

        <ul>
            <li id="upload">
                <a href="${h.url_for('upload')}">Upload</a>
            </li>
            <li id="settings">
                <a href="${h.url_for('account-settings')}">Settings</a>
            </li>
            <li id="logout">
                <a href="${h.url_for('logout')}">Logout</a>
            </li>
        </ul>

    </div>

</%def>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>

    <meta
        http-equiv="Content-Type"
        content="application/xhtml+xml;charset=utf-8"
    />

    <link
        rel="stylesheet"
        type="text/css"
        media="screen"
        href="${h.url_for('/css/default.css')}"
    />

    <title>
        Yolanda - ${self.title()}
    </title>

</head>

<body>

    <a href="#content" style="display:none;">
        Skip menu.
    </a>

<%doc>
    login will be implemented later on
    ${self.login()}
</%doc>

    ${self.search()}

    ${self.account_actions()}

    ${self.tagcloud()}

    <div id="header">
        <h1>
            ${self.heading()}
        </h1>
    </div>

    ${self.messagebox()}

    <div id="content">

        ${self.body()}

    </div>

    <div id="copyright">
        <p>
        ${g.platform_name} is realized using <em>${g.application_name}</em> Copyright © 2007, 2008 ${g.developers} –
        ${g.application_name} comes with <em>absolutely no warranty</em>; for details <a href="${h.url_for('license')}">click here</a>.
        ${g.application_name} is <em>free software</em>, and you are welcome to redistribute it
        under certain conditions; <a href="${h.url_for('license')}">click here</a> for details.
        To view the source code, <a href="">click here</a>.
        </p>
    </div>

    <ul id="badges">

        <li class="badge">
            <a href="">
                <img alt="XHTML 5" src="${h.url_for('images/badges/xhtml5.png')}" />
            </a>
        </li>

        <li class="badge">
            <a href="http://jigsaw.w3.org/css-validator/">
                <img alt="CSS logo" src="${h.url_for('images/badges/css.png')}" />
            </a>
        </li>

        <li class="badge">
            <a href="http://www.theora.org/">
                <img alt="Ogg Theora logo" src="${h.url_for('images/badges/ogg theora.png')}" />
            </a>
        </li>

    </ul>

</body>

</html>
