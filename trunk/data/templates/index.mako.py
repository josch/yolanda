from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
_magic_number = 2
_modified_time = 1216907993.197489
_template_filename='/home/nils/src/yolanda/trunk/yolanda/templates/index.mako'
_template_uri='/index.mako'
_template_cache=cache.Cache(__name__, _modified_time)
_source_encoding=None
_exports = []


def render_body(context,**pageargs):
    context.caller_stack.push_frame()
    try:
        __M_locals = dict(pageargs=pageargs)
        h = context.get('h', UNDEFINED)
        # SOURCE LINE 1
        context.write(u'<h1>\n    Welcome to Yolanda\n</h1>\n\n<p>\n    This is the front page.\n</p>\n\n<p>\n    <a href="">upload video</a>\n</p>\n\n<p>\n\n')
        # SOURCE LINE 15
        context.write(unicode( h.form( \
    h.url(action='/results'), \
    method='get', \
    enctype='application/x-www-form-urlencoded' \
) ))
        # SOURCE LINE 19
        context.write(u'\n\n')
        # SOURCE LINE 21
        context.write(unicode( h.text_field('query') ))
        context.write(u'\n')
        # SOURCE LINE 22
        context.write(unicode( h.submit('find video') ))
        context.write(u'\n\n')
        # SOURCE LINE 24
        context.write(unicode( h.end_form() ))
        context.write(u'\n\n    <form action="/results" method="get" enctype="application/x-www-form-urlencoded">\n        <fieldset>\n\n            <legend>\n                search for videos\n            </legend>\n\n            <input type="text" name="query" />\n            <input type="submit" value="find" />\n\n        </fieldset>\n    </form>\n</p>\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


