import logging

from yolanda.lib.base import *

log = logging.getLogger(__name__)

class IndexController(BaseController):

    def index(self):

        # TODO: write elixir devs a mail to see how this works un-hackish

        return render('/xhtml/index.mako')

