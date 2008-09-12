<?xml version="1.0" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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

        <h1>To upload videos, login.</h1>

        ${h.form(h.url_for('account/login'), method='post')}

            ${h.text_field('username')}
            ${h.submit('Login (OpenID)')}

        ${h.end_form()}

    </div>
</%def>

<%def name="messagebox()">

%if c.error:
    <div class="messagebox error">
        ${c.error}
    </div>
%endif

%if c.information:
    <div class="messagebox information">
        ${c.information}
    </div>
%endif

%if c.warning:
    <div class="messagebox warning">
        ${c.warning}
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

    <div id="heading">
        <h1>
            ${self.heading()}
        </h1>
    </div>

    ${self.search()}

    ${self.login()}

    ${self.tagcloud()}

    ${self.messagebox()}

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
