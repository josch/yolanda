import logging

from yolanda.lib.base import *

log = logging.getLogger(__name__)

class AccountController(BaseController):

    def index(self):
        # Return a rendered template
        #   return render('/some/template.mako')
        # or, Return a response
        return 'account'
