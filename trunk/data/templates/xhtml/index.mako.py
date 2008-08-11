from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
_magic_number = 2
_modified_time = 1218428536.96173
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
        context.write(u'\n\n<h1>Welcome to Yolanda</h1>\n\n<h2>WTF Is This Shit ?</h2>\n\n<p>\nMauris et dolor. Suspendisse potenti. Proin diam augue, semper vitae, varius et, viverra id, felis. Praesent lacus. Pellentesque tempor. Suspendisse viverra placerat tortor. Maecenas justo. Aenean justo ipsum, luctus ut, volutpat laoreet, vehicula in, libero. Morbi volutpat. Cras gravida. \n</p>\n\n<p>\nSed non ipsum. Maecenas justo. Etiam fermentum. Praesent scelerisque. Quisque malesuada nulla sed pede volutpat pulvinar. Curabitur tincidunt tellus nec purus. Praesent a lacus vitae turpis consequat semper. Aenean turpis ipsum, rhoncus vitae, posuere vitae, euismod sed, ligula. Praesent semper, neque vel condimentum hendrerit, lectus elit pretium ligula, nec consequat nisl velit at dui. Nam malesuada sapien eu nibh. \n</p>\n\n<h2>Lol Awesome !</h2>\n\n<p>\nEtiam fermentum. Quisque arcu ante, cursus in, ornare quis, viverra ut, justo. Nulla sed lacus. Morbi turpis arcu, egestas congue, condimentum quis, tristique cursus, leo. Vestibulum non arcu a ante feugiat vestibulum. Quisque facilisis, urna sit amet pulvinar mollis, purus arcu adipiscing velit, non condimentum diam purus eu massa. Nulla sagittis condimentum ligula. Quisque dictum quam vel neque. Nam id neque. Fusce venenatis ligula in pede. \n</p>\n\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


def render_heading(context):
    context.caller_stack.push_frame()
    try:
        # SOURCE LINE 7
        context.write(u'\n    Welcome to Yolanda, a place for people who hate Adobe Flash.\n')
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


