import logging

from yolanda.lib.base import *

log = logging.getLogger(__name__)

class IndexController(BaseController):

    def index(self):

        tags = {}
        for tag in model.DC_Subject.query.all():
            if tag.name in tags.keys():
                tags[tag.name]+=1
            else:
                tags[tag.name] = 1
        c.tagcloud = tags

        return render('/xhtml/index.mako')

