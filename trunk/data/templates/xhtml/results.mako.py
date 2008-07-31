from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
_magic_number = 2
_modified_time = 1217192310.2031181
_template_filename='/home/nils/src/yolanda/trunk/yolanda/templates/xhtml/results.mako'
_template_uri='/xhtml/results.mako'
_template_cache=cache.Cache(__name__, _modified_time)
_source_encoding=None
_exports = ['results_listing', 'heading', 'title']


def _mako_get_namespace(context, name):
    try:
        return context.namespaces[(__name__, name)]
    except KeyError:
        _mako_generate_namespaces(context)
        return context.namespaces[(__name__, name)]
def _mako_generate_namespaces(context):
    pass
def _mako_inherit(template, context):
    _mako_generate_namespaces(context)
    return runtime._inherit_from(context, u'base.mako', _template_uri)
def render_body(context,**pageargs):
    context.caller_stack.push_frame()
    try:
        __M_locals = dict(pageargs=pageargs)
        def results_listing(results):
            return render_results_listing(context.locals_(__M_locals),results)
        c = context.get('c', UNDEFINED)
        # SOURCE LINE 1
        context.write(u'\n\n')
        # SOURCE LINE 5
        context.write(u'\n\n')
        # SOURCE LINE 9
        context.write(u'\n\n')
        # SOURCE LINE 25
        context.write(u'\n\n')
        # SOURCE LINE 27
        context.write(unicode(results_listing(c.results)))
        context.write(u'\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


def render_results_listing(context,results):
    context.caller_stack.push_frame()
    try:
        h = context.get('h', UNDEFINED)
        c = context.get('c', UNDEFINED)
        # SOURCE LINE 11
        context.write(u'\n    <ol id="results">\n')
        # SOURCE LINE 13
        for result in c.results:
            # SOURCE LINE 14
            context.write(u'        <li id="result">\n            <a href="')
            # SOURCE LINE 15
            context.write(unicode(h.url_for('video_page', video=result)))
            context.write(u'">\n                <img src="')
            # SOURCE LINE 16
            context.write(unicode(result['thumbnail']))
            context.write(u'" alt=\'thumbnail for "')
            context.write(unicode(result['title']))
            context.write(u'"\'/>\n            </a>\n            <br />\n            <a href="')
            # SOURCE LINE 19
            context.write(unicode(h.url_for('video_page', video=result)))
            context.write(u'">\n                ')
            # SOURCE LINE 20
            context.write(unicode(result['title']))
            context.write(u'\n            </a>\n        </li>\n')
        # SOURCE LINE 24
        context.write(u'    </ol>\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


def render_heading(context):
    context.caller_stack.push_frame()
    try:
        c = context.get('c', UNDEFINED)
        # SOURCE LINE 7
        context.write(u'\n    9001 results for "')
        # SOURCE LINE 8
        context.write(unicode(c.query))
        context.write(u'":\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


def render_title(context):
    context.caller_stack.push_frame()
    try:
        c = context.get('c', UNDEFINED)
        # SOURCE LINE 3
        context.write(u'\n    results for "')
        # SOURCE LINE 4
        context.write(unicode(c.query))
        context.write(u'"\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


