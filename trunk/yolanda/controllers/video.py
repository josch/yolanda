import logging

from yolanda.lib.base import *

log = logging.getLogger(__name__)

class VideoController(BaseController):

    def index(self):
        return 'show a video html page'

    def file(self):
        return 'serve video'

