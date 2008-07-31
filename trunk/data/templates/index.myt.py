from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
_magic_number = 2
_modified_time = 1216815389.6429961
_template_filename='/home/nils/src/yolanda/trunk/yolanda/templates/index.myt'
_template_uri='/index.myt'
_template_cache=cache.Cache(__name__, _modified_time)
_source_encoding=None
_exports = []


def render_body(context,**pageargs):
    context.caller_stack.push_frame()
    try:
        __M_locals = dict(pageargs=pageargs)
        # SOURCE LINE 1
        context.write(u'<!-- header -->\n\n<h1>\n    Welcome to Yolanda\n</h1>\n\n<p>\n    This is the front page.\n</p>\n\n<p>\n    <a href="">upload video</a>\n</p>\n\n<p>\n    <form action="/results" method="get" enctype="application/x-www-form-urlencoded">\n        <fieldset>\n\n            <legend>\n                search for videos\n            </legend>\n\n            <input type="text" name="query" />\n            <input type="submit" value="find" />\n\n        </fieldset>\n    </form>\n</p>\n\n<!-- footer -->\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


