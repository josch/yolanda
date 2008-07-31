from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
_magic_number = 2
_modified_time = 1216910187.0066929
_template_filename='/home/nils/src/yolanda/trunk/yolanda/templates/results.mako'
_template_uri='/results.mako'
_template_cache=cache.Cache(__name__, _modified_time)
_source_encoding=None
_exports = ['result']


def render_body(context,**pageargs):
    context.caller_stack.push_frame()
    try:
        __M_locals = dict(pageargs=pageargs)
        h = context.get('h', UNDEFINED)
        c = context.get('c', UNDEFINED)
        def result(x):
            return render_result(context.locals_(__M_locals),x)
        # SOURCE LINE 1
        context.write(u'<html>\n\n\n<head>\n\n')
        # SOURCE LINE 6
        context.write(unicode( h.javascript_include_tag('/javascripts/effects.js', builtins=True) ))
        context.write(u'\n\n</head>\n\n\n<body>\n\n')
        # SOURCE LINE 18
        context.write(u'\n\n<p>\n    Here be results for ')
        # SOURCE LINE 21
        context.write(unicode(c.query))
        context.write(u'.\n</p>\n\n')
        # SOURCE LINE 24
        for x in range(1,10):
            # SOURCE LINE 25
            context.write(u'    ')
            context.write(unicode(result(x)))
            context.write(u'\n')
        # SOURCE LINE 27
        context.write(u'\n</body>\n\n\n</html>\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


def render_result(context,x):
    context.caller_stack.push_frame()
    try:
        h = context.get('h', UNDEFINED)
        # SOURCE LINE 13
        context.write(u'\n    <div class="result" id="')
        # SOURCE LINE 14
        context.write(unicode(x))
        context.write(u'">\n        ')
        # SOURCE LINE 15
        context.write(unicode( h.draggable_element(x, revert=True) ))
        context.write(u'\n        thumbnail and infos for video ')
        # SOURCE LINE 16
        context.write(unicode(x))
        context.write(u'\n    </div>\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


