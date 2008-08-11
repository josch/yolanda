<?xml version="1.0" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%def name="search()">
    <div id="search-box">

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
    <div id="login-box">

        <h1>Login to upload videos</h1>

        ${h.form(h.url_for('account_login'), method='post')}

            ${h.text_field('username')}
            ${h.submit('Login (OpenID)')}

        ${h.end_form()}

    </div>
</%def>

<%def name="tagcloud()">
    <div id="tagcloud-box">

        <h1>Tag cloud</h1>

        <a class="tag4+">Proin</a>
        <a class="tag16+">lectus</a>
        <a class="tag4+">orci</a>
        <a class="tag4+">venenatis</a>
        <a class="tag16+">pharetra</a>
        <a class="tag4+">egestas</a>
        <a class="tag16+">id</a>
        <a class="tag4+">tincidunt</a>
        <a class="tag16+">vel</a>
        <a class="tag16+">eros</a>
        <a class="tag4+">Integer</a>
        <a class="tag4+">risus</a>
        <a class="tag4+">velit</a>
        <a class="tag16+">facilisis</a>
        <a class="tag16+">eget</a>
        <a class="tag4+">viverra</a>
        <a class="tag4+">et</a>
        <a class="tag4+">leo</a>
        <a class="tag16+">Suspendisse</a>
        <a class="tag16+">potenti</a>
        <a class="tag16+">Phasellus</a>
        <a class="tag16+">auctor</a>
        <a class="tag16+">enim</a>
        <a class="tag4+">eget</a>
        <a class="tag16g+">sem</a>

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

    <div id="heading-box">
        <h1>
            ${self.heading()}
        </h1>
    </div>

    ${self.search()}

    ${self.tagcloud()}

    ${self.login()}

    ${self.body()}

    <div id="copyright">
        <em>Yolanda</em> Copyright &copy; 2007, 2008 <em>The Yolanda Developers</em> &ndash;
        This program comes with <em>absolutely no warranty</em>; for details <a href="${h.url_for('license')}">click here</a>.
        This is <em>free software</em>, and you are welcome to redistribute it
        under certain conditions; <a href="${h.url_for('license')}">click here</a> for details.
        To view the source code, <a href="">click here</a>. Report bugs <a href="">here</a>.
    </div>

    <ul id="badges">

        <li class="badge">
            <a href="http://validator.w3.org/">
                <img alt="XHTML 1.1 logo" src="${h.url_for('images/badges/xhtml 1.1.png')}" />
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
