from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
_magic_number = 2
_modified_time = 1217192819.900584
_template_filename='/home/nils/src/yolanda/trunk/yolanda/templates/xhtml/index.mako'
_template_uri='/xhtml/index.mako'
_template_cache=cache.Cache(__name__, _modified_time)
_source_encoding=None
_exports = ['heading', 'title']


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
        # SOURCE LINE 1
        context.write(u'\n\n')
        # SOURCE LINE 5
        context.write(u'\n\n')
        # SOURCE LINE 9
        context.write(u'\n\nLOL INDEX\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


def render_heading(context):
    context.caller_stack.push_frame()
    try:
        # SOURCE LINE 7
        context.write(u'\n    Welcome, youngling !\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


def render_title(context):
    context.caller_stack.push_frame()
    try:
        # SOURCE LINE 3
        context.write(u'\n    front page\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


