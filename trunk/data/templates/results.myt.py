from mako import runtime, filters, cache
UNDEFINED = runtime.UNDEFINED
_magic_number = 2
_modified_time = 1216817791.7502799
_template_filename='/home/nils/src/yolanda/trunk/yolanda/templates/results.myt'
_template_uri='/results.myt'
_template_cache=cache.Cache(__name__, _modified_time)
_source_encoding=None
_exports = []


def render_body(context,**pageargs):
    context.caller_stack.push_frame()
    try:
        __M_locals = dict(pageargs=pageargs)
        h = context.get('h', UNDEFINED)
        c = context.get('c', UNDEFINED)
        # SOURCE LINE 1
        context.write(u'<h1>\n    Welcome to Yolanda\n</h1>\n\n<p>\n    This is the search page.\n</p>\n\n<p>\n')
        # SOURCE LINE 10
        h.start_form(h.url_for(action='save', title=c.query), method="get") 
        
        context.write(u'\n    ')
        # SOURCE LINE 11
        h.text_area(name='content', rows=7, cols=40, content=c.content)
        
        context.write(u' <br />\n    ')
        # SOURCE LINE 12
        h.submit(value="Save changes", name='commit') 
        
        context.write(u'\n')
        # SOURCE LINE 13
        h.end_form() 
        
        context.write(u'\n\n    ')
        # SOURCE LINE 15
        c.query 
        
        context.write(u'\n</p>\n')
        return ''
    finally:
        context.caller_stack.pop_frame()


