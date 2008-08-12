from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
_magic_number = 2
_modified_time = 1218565522.49384
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
        context.write(u'\n\n<h1>An introduction to Yolanda</h1>\n\n<h2>What exactly is this ?</h2>\n\n<p>\nYolanda is a <em>free software video platform</em> and, as far as we (the developers) know, the <em>only</em> one that doesn\'t rely on proprietary browser extensions. Instead, we only use <em>open standards</em>, namely <a href="">XHTML</a>, <a href="">CSS</a> and <a href="">JavaScript</a>; Videos are served in <a href="">Ogg Theora</a> format. Since Yolanda is <a href="">free software</a>, you can <a href="">download the source code</a> to adapt, modify and extend it.\n</p>\n\n<h2>What do I need to play videos ?</h2>\n\n<p>\nIf you use a recent GNU/Linux Desktop distribution such as Ubuntu, no additional software is required. Users of inferior operating systems and arcane desktop environments are advised to install the <a href="">VLC media player</a> web plugin (Links and Lynx users should use VLC\'s aalib or libcaca output). As soon as browsers support the XHTML 5 &lt;video&gt; element, we will use it, which means that no additional software will be required.\n</p>\n\n<h2>How do I upload videos ?</h2>\n<p>\nSed non ipsum. Maecenas justo. Etiam fermentum. Praesent scelerisque. Quisque malesuada nulla sed pede volutpat pulvinar. Curabitur tincidunt tellus nec purus. Praesent a lacus vitae turpis consequat semper. Aenean turpis ipsum, rhoncus vitae, posuere vitae, euismod sed, ligula. Praesent semper, neque vel condimentum hendrerit, lectus elit pretium ligula, nec consequat nisl velit at dui. Nam malesuada sapien eu nibh. \n</p>\n\n<h2>Why don\'t you use Flash / Java / $foo ?</h2>\n<p>\nProbably because it is not <a href="">free (as in freedom)</a>. If you are serious about your suggestion, please file a ticket in our <a href="">bug tracker</a>.\n</p>\n\n')
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


