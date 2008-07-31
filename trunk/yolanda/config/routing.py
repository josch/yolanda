"""Routes configuration

The more specific and detailed routes should be defined first so they
may take precedent over the more generic routes. For more information
refer to the routes manual at http://routes.groovie.org/docs/
"""
from pylons import config
from routes import Mapper

def make_map():
    """Create, configure and return the routes Mapper"""
    map = Mapper(directory=config['pylons.paths']['controllers'],
                 always_scan=config['debug'])

    # The ErrorController route (handles 404/500 error pages); it should
    # likely stay at the top, ensuring it can always be resolved
    map.connect('error/:action/:id', controller='error')

    # CUSTOM ROUTES HERE

    # front page (search form and search errors)
    map.connect('', controller='index', action='index')

    # search results
    map.connect('search_results', 'results', controller='search', action='results')

    # videos
    def video_expand(kargs):
        # only alter kargs if a video keyword arg is present
        if 'video' not in kargs:
            return kargs

        video = kargs.pop('video')
        kargs['id'] = video['id']
        kargs['title'] = video['title']

        return kargs

    map.connect('video_page', 'video/:id/:title', controller='video', _filter=video_expand)
    # map.connect('video_file', 'video/:id.ogv', controller='video', action='file' _filter=video_expand)

    # everything else
    map.connect(':controller/:action/:id')
    # map.connect('*url', controller='template', action='view')

    return map
