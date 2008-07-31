<?xml version="1.0" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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

    <div id="search-box">

        <h1>
            Search all videos
        </h1>

        ${h.form(h.url_for('search_results'), method='get')}

            ${h.text_field('query')}
            ${h.submit('Search')}

        ${h.end_form()}

    </div>

    ${self.body()}

    <div id="copyright">
        <em>Yolanda</em> Copyright &copy; 2007, 2008 <em>The Yolanda Developers</em> &ndash;
        This program comes with <em>absolutely no warranty</em>; for details <a href="">click here</a>.
        This is <em>free software</em>, and you are welcome to redistribute it
        under certain conditions; <a href="">click here</a> for details.
        To view the source code, <a href="">click here</a>. Report bugs <a href="">here</a>.
    </div>

    <ul id="antipixel" role="navigation">

        <li>
            <a href="http://validator.w3.org/">
                <img alt="XHTML 1.1 logo" class="antipixel" src="" />
            </a>
        </li>

        <li>
            <a href="http://jigsaw.w3.org/css-validator/">
                <img alt="CSS logo" class="antipixel" src="" />
            </a>
        </li>

        <li>
            <a href="">
                <img alt="Javascript logo" class="antipixel" src="" />
            </a>
        </li>

        <li>
            <a href="http://www.theora.org/">
                <img alt="Ogg Theora logo" class="antipixel" src="" />
            </a>
        </li>

    </ul>

</body>

</html>
