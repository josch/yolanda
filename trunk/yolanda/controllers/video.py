import logging

from yolanda.lib.base import *

log = logging.getLogger(__name__)

class VideoController(BaseController):

    def index(self):
        c.video =   {
                    'title': 'foobar',
                    'description': 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nullam sapien mauris, venenatis at, fermentum at, tempus eu, urna.' ,
                    'preview': h.url_for('/images/404.png')
                    }
        return 'show a video html page'

    def file(self):
        return 'serve video'

