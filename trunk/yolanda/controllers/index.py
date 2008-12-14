import logging

from yolanda.lib.base import *

log = logging.getLogger(__name__)

class IndexController(BaseController):

    def index(self):

        raise(RuntimeError)
        c.tagcloud = model.DC_Subject.query.all()

        return render('/xhtml/index.mako')

