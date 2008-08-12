from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
_magic_number = 2
_modified_time = 1218555872.226696
_template_filename=u'/home/nils/src/yolanda/trunk/yolanda/templates/xhtml/base.mako'
_template_uri=u'/xhtml/base.mako'
_template_cache=cache.Cache(__name__, _modified_time)
_source_encoding=None
_exports = ['search', 'tagcloud', 'login']


def render_body(context,**pageargs):
    context.caller_stack.push_frame()
    try:
        __M_locals = dict(pageargs=pageargs)
        h = context.get('h', UNDEFINED)
        self = context.get('self', UNDEFINED)
        # SOURCE LINE 1
        context.write(u'<?xml version="1.0" ?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"\n    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n\n')
        # SOURCE LINE 38
        context.write(u'\n\n')
        # SOURCE LINE 53
        context.write(u'\n\n')
        # SOURCE LINE 87
        context.write(u'\n\n<html xmlns="http://www.w3.org/1999/xhtml">\n\n<head>\n\n    <meta\n        http-equiv="Content-Type"\n        content="application/xhtml+xml;charset=utf-8"\n    />\n\n    <link\n        rel="stylesheet"\n        type="text/css"\n        media="screen"\n        href="')
        # SOURCE LINE 102
        context.write(unicode(h.url_for('/css/default.css')))
        context.write(u'"\n    />\n\n    <title>\n        Yolanda - ')
        # SOURCE LINE 106
        context.write(unicode(self.title()))
        context.write(u'\n    </title>\n\n</head>\n\n<body>\n\n    <div id="heading">\n        <h1>\n            ')
        # SOURCE LINE 115
        context.write(unicode(self.heading()))
        context.write(u'\n        </h1>\n    </div>\n\n    ')
        # SOURCE LINE 119
        context.write(unicode(self.search()))
        context.write(u'\n\n    ')
        # SOURCE LINE 121
        context.write(unicode(self.login()))
        context.write(u'\n\n    ')
        # SOURCE LINE 123
        context.write(unicode(self.tagcloud()))
        context.write(u'\n\n    ')
        # SOURCE LINE 125
        context.write(unicode(self.body()))
        context.write(u'\n\n    <div id="copyright">\n        <em>Yolanda</em> Copyright &copy; 2007, 2008 <em>The Yolanda Developers</em> &ndash;\n        This program comes with <em>absolutely no warranty</em>; for details <a href="')
        # SOURCE LINE 129
        context.write(unicode(h.url_for('license')))
        context.write(u'">click here</a>.\n        This is <em>free software</em>, and you are welcome to redistribute it\n        under certain conditions; <a href="')
        # SOURCE LINE 131
        context.write(unicode(h.url_for('license')))
        context.write(u'">click here</a> for details.\n        To view the source code, <a href="">click here</a>. Report bugs <a href="">here</a>.\n    </div>\n\n    <ul id="badges">\n\n        <li class="badge">\n            <a href="http://validator.w3.org/">\n                <img alt="XHTML 1.1 logo" src="')
        # SOURCE LINE 139
        context.write(unicode(h.url_for('images/badges/xhtml 1.1.png')))
        context.write(u'" />\n            </a>\n        </li>\n\n        <li class="badge">\n            <a href="http://jigsaw.w3.org/css-validator/">\n                <img alt="CSS logo" src="')
        # SOURCE LINE 145
        context.write(unicode(h.url_for('images/badges/css.png')))
        context.write(u'" />\n            </a>\n        </li>\n\n        <li class="badge">\n            <a href="http://www.theora.org/">\n                <img alt="Ogg Theora logo" src="')
        # SOURCE LINE 151
        context.write(unicode(h.url_for('images/badges/ogg theora.png')))
        context.write(u'" />\n            </a>\n        </li>\n\n    </ul>\n\n</body>\n\n</html>\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


def render_search(context):
    context.caller_stack.push_frame()
    try:
        h = context.get('h', UNDEFINED)
        # SOURCE LINE 5
        context.write(u'\n    <div id="search">\n\n        ')
        # SOURCE LINE 8
        context.write(unicode(h.form(h.url_for('search_results'), method='get')))
        context.write(u'\n\n            ')
        # SOURCE LINE 10
        context.write(unicode(h.text_field('query')))
        context.write(u'\n            ')
        # SOURCE LINE 11
        context.write(unicode(h.submit('Search Videos')))
        context.write(u'\n\n        ')
        # SOURCE LINE 13
        context.write(unicode(h.end_form()))
        context.write(u'\n\n        <ul id="queries">\n\n            <li id="important">\n                <a href="">\n                    Important matters\n                </a>\n            </li>\n\n            <li id="popular">\n                <a href="">\n                    Popular garbage\n                </a>\n            </li>\n\n            <li id="new">\n                <a href="">\n                    Totally new stuff\n                </a>\n            </li>\n\n        </ul>\n\n    </div>\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


def render_tagcloud(context):
    context.caller_stack.push_frame()
    try:
        # SOURCE LINE 55
        context.write(u'\n    <div id="tagcloud">\n\n        <h1>Popular tags</h1>\n\n        <a href="" class="tag6">Proin</a>\n        <a href="" class="tag5">lectus</a>\n        <a href="" class="tag2">orci</a>\n        <a href="" class="tag6">venenatis</a>\n        <a href="" class="tag5">pharetra</a>\n        <a href="" class="tag6">egestas</a>\n        <a href="" class="tag1">id</a>\n        <a href="" class="tag6">tincidunt</a>\n        <a href="" class="tag5">vel</a>\n        <a href="" class="tag3">eros</a>\n        <a href="" class="tag6">Integer</a>\n        <a href="" class="tag6">risus</a>\n        <a href="" class="tag6">velit</a>\n        <a href="" class="tag2">facilisis</a>\n        <a href="" class="tag4">eget</a>\n        <a href="" class="tag5">viverra</a>\n        <a href="" class="tag6">et</a>\n        <a href="" class="tag6">leo</a>\n        <a href="" class="tag1">Suspendisse</a>\n        <a href="" class="tag3">potenti</a>\n        <a href="" class="tag5">Phasellus</a>\n        <a href="" class="tag4">auctor</a>\n        <a href="" class="tag6">enim</a>\n        <a href="" class="tag3">eget</a>\n        <a href="" class="tag4">sem</a>\n\n    </div>\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


def render_login(context):
    context.caller_stack.push_frame()
    try:
        h = context.get('h', UNDEFINED)
        # SOURCE LINE 40
        context.write(u'\n    <div id="login">\n\n        <h1>To upload videos, login.</h1>\n\n        ')
        # SOURCE LINE 45
        context.write(unicode(h.form(h.url_for('account_login'), method='post')))
        context.write(u'\n\n            ')
        # SOURCE LINE 47
        context.write(unicode(h.text_field('username')))
        context.write(u'\n            ')
        # SOURCE LINE 48
        context.write(unicode(h.submit('Login (OpenID)')))
        context.write(u'\n\n        ')
        # SOURCE LINE 50
        context.write(unicode(h.end_form()))
        context.write(u'\n\n    </div>\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


