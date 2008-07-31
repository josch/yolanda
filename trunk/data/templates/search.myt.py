from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
_magic_number = 2
_modified_time = 1216814715.8671241
_template_filename='/home/nils/src/yolanda/trunk/yolanda/templates/search.myt'
_template_uri='/search.myt'
_template_cache=cache.Cache(__name__, _modified_time)
_source_encoding=None
_exports = []


def render_body(context,**pageargs):
    context.caller_stack.push_frame()
    try:
        __M_locals = dict(pageargs=pageargs)
        # SOURCE LINE 1
        context.write(u'<!-- header -->\n\n<h1>\n    Welcome to Yolanda\n</h1>\n\n<p>\n    This is the search page.\n</p>\n\n<!-- footer -->\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


