<?xml version="1.0" ?>
<!DOCTYPE html>
<!-- XHTML 5, baby ! -->

<%def name="search()">
    <div id="search">

        ${h.form(h.url_for('search_results'), method='get')}

            ${h.text_field('query')}
            ${h.submit('Search Videos')}

        ${h.end_form()}

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

    </div>
</%def>

<%def name="login()">
    <div id="login">

        ${h.form(h.url_for('account/login'), method='post')}

            ${h.text_field('username')}
            ${h.submit('Login (OpenID)')}

        ${h.end_form()}

    </div>
</%def>

<%def name="messagebox()">

%if c.message:
    <div id="messagebox" class="${c.message['type']}">
        <span id="message">
            ${c.message['text']}
        </span>
    </div>
%endif

</%def>


<%def name="tagcloud()">
    <div id="tagcloud">

        <h1>Popular tags</h1>

        <a href="" class="tag6">Proin</a>
        <a href="" class="tag5">lectus</a>
        <a href="" class="tag2">orci</a>
        <a href="" class="tag6">venenatis</a>
        <a href="" class="tag5">pharetra</a>
        <a href="" class="tag6">egestas</a>
        <a href="" class="tag1">id</a>
        <a href="" class="tag6">tincidunt</a>
        <a href="" class="tag5">vel</a>
        <a href="" class="tag3">eros</a>
        <a href="" class="tag6">Integer</a>
        <a href="" class="tag6">risus</a>
        <a href="" class="tag6">velit</a>
        <a href="" class="tag2">facilisis</a>
        <a href="" class="tag4">eget</a>
        <a href="" class="tag5">viverra</a>
        <a href="" class="tag6">et</a>
        <a href="" class="tag6">leo</a>
        <a href="" class="tag1">Suspendisse</a>
        <a href="" class="tag3">potenti</a>
        <a href="" class="tag5">Phasellus</a>
        <a href="" class="tag4">auctor</a>
        <a href="" class="tag6">enim</a>
        <a href="" class="tag3">eget</a>
        <a href="" class="tag4">sem</a>

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

    ${self.login()}

    ${self.search()}

    ${self.tagcloud()}

    <div id="header">
        <h1>
            <img src="${h.url_for('logo')}" alt="${g.platform_name} logo"/>
        </h1>
    </div>

    <div id="heading">
        <h1>
            ${self.heading()}
        </h1>
    </div>

    ${self.messagebox()}

    <div id="content">

        ${self.body()}

    </div>

    <div id="copyright">
        ${g.platform_name} is realized using <em>${g.application_name}</em> Copyright © 2007, 2008 ${g.developers} –
        ${g.application_name} comes with <em>absolutely no warranty</em>; for details <a href="${h.url_for('license')}">click here</a>.
        ${g.application_name} is <em>free software</em>, and you are welcome to redistribute it
        under certain conditions; <a href="${h.url_for('license')}">click here</a> for details.
        To view the source code, <a href="">click here</a>. Report bugs <a href="">here</a>.
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
