from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
_magic_number = 2
_modified_time = 1217192624.700382
_template_filename=u'/home/nils/src/yolanda/trunk/yolanda/templates/xhtml/base.mako'
_template_uri=u'/xhtml/base.mako'
_template_cache=cache.Cache(__name__, _modified_time)
_source_encoding=None
_exports = []


def render_body(context,**pageargs):
    context.caller_stack.push_frame()
    try:
        __M_locals = dict(pageargs=pageargs)
        h = context.get('h', UNDEFINED)
        self = context.get('self', UNDEFINED)
        # SOURCE LINE 1
        context.write(u'<?xml version="1.0" ?>\n<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"\n    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n\n<html xmlns="http://www.w3.org/1999/xhtml">\n\n<head>\n\n    <meta\n        http-equiv="Content-Type"\n        content="application/xhtml+xml;charset=utf-8"\n    />\n\n    <link\n        rel="stylesheet"\n        type="text/css"\n        media="screen"\n        href="')
        # SOURCE LINE 18
        context.write(unicode(h.url_for('/css/default.css')))
        context.write(u'"\n    />\n\n    <title>\n        Yolanda - ')
        # SOURCE LINE 22
        context.write(unicode(self.title()))
        context.write(u'\n    </title>\n\n</head>\n\n<body>\n\n    <div id="heading-box">\n        <h1>\n            ')
        # SOURCE LINE 31
        context.write(unicode(self.heading()))
        context.write(u'\n        </h1>\n    </div>\n\n    <div id="search-box">\n\n        <h1>\n            Search all videos\n        </h1>\n\n        ')
        # SOURCE LINE 41
        context.write(unicode(h.form(h.url_for('search_results'), method='get')))
        context.write(u'\n\n            ')
        # SOURCE LINE 43
        context.write(unicode(h.text_field('query')))
        context.write(u'\n            ')
        # SOURCE LINE 44
        context.write(unicode(h.submit('Search')))
        context.write(u'\n\n        ')
        # SOURCE LINE 46
        context.write(unicode(h.end_form()))
        context.write(u'\n\n    </div>\n\n    ')
        # SOURCE LINE 50
        context.write(unicode(self.body()))
        context.write(u'\n\n    <div id="copyright">\n        <em>Yolanda</em> Copyright &copy; 2007, 2008 <em>The Yolanda Developers</em> &ndash;\n        This program comes with <em>absolutely no warranty</em>; for details <a href="">click here</a>.\n        This is <em>free software</em>, and you are welcome to redistribute it\n        under certain conditions; <a href="">click here</a> for details.\n        To view the source code, <a href="">click here</a>. Report bugs <a href="">here</a>.\n    </div>\n\n    <ul id="antipixel" role="navigation">\n\n        <li>\n            <a href="http://validator.w3.org/">\n                <img alt="XHTML 1.1 logo" class="antipixel" src="" />\n            </a>\n        </li>\n\n        <li>\n            <a href="http://jigsaw.w3.org/css-validator/">\n                <img alt="CSS logo" class="antipixel" src="" />\n            </a>\n        </li>\n\n        <li>\n            <a href="">\n                <img alt="Javascript logo" class="antipixel" src="" />\n            </a>\n        </li>\n\n        <li>\n            <a href="http://www.theora.org/">\n                <img alt="Ogg Theora logo" class="antipixel" src="" />\n            </a>\n        </li>\n\n    </ul>\n\n</body>\n\n</html>\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


