import logging

from yolanda.lib.base import *

log = logging.getLogger(__name__)

class SearchController(BaseController):

    def results(self):

        c.query     =   request.params['query']

        # c.results dummy
        c.results = [
                    {'title': 'foobar', 'id': '23' },
                    {'title': 'blablupp', 'id': '42'},
                    {'title': 'uiae nrdt', 'id': '555'},
                    {'title': 'uiaenrtd uiaenrtd uiaenrdt', 'id': '666666666'},
                    {'title': 'foobar', 'id': '23'},
                    {'title': 'blablupp', 'id': '42'},
                    {'title': 'James Bond drives a bulletproof Aston Martin !!!', 'id': '555'},
                    {'title': 'uiaenrtd uiaenrtd uiaenrdt uiaenrtd uiaenrtd', 'id': '666666666'},
                    {'title': 'foobar', 'id': '123'},
                    {'title': 'blablupp', 'id': '42'},
                    {'title': 'lolwtf hax !!!11', 'id': '9001'}
                    ]

        return render('/xhtml/results.mako')
        # return request.params['query']
        # return h.form(h.url(action='search'), method='get')
