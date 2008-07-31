import logging

from yolanda.lib.base import *

log = logging.getLogger(__name__)

class IndexController(BaseController):

    def index(self):
        return render('/xhtml/index.mako')
