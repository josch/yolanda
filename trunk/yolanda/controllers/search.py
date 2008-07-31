import logging

from yolanda.lib.base import *

log = logging.getLogger(__name__)

class SearchController(BaseController):

    def results(self):

        # maybe c.query could / should be a dictionary ?
        c.query     =   request.params['query']

        # c.results dummy
        c.results   =   [
                        {'title': 'foobar', 'id': '23' , 'thumbnail': h.url_for('/images/404.png')},
                        {'title': 'blablupp', 'id': '42', 'thumbnail': h.url_for('/images/404.png')},
                        {'title': 'uiae nrdt', 'id': '555' , 'thumbnail': h.url_for('/images/404.png')},
                        {'title': 'uiaenrtd uiaenrtd uiaenrdt', 'id': '666666666', 'thumbnail': h.url_for('/images/404.png')},
                        {'title': 'foobar', 'id': '23' , 'thumbnail': h.url_for('/images/404.png')},
                        {'title': 'blablupp', 'id': '42', 'thumbnail': h.url_for('/images/404.png')},
                        {'title': 'James Bond drives a bulletproof Aston Martin !!!', 'id': '555' , 'thumbnail': h.url_for('/images/404.png')},
                        {'title': 'uiaenrtd uiaenrtd uiaenrdt uiaenrtd uiaenrtd', 'id': '666666666', 'thumbnail': h.url_for('/images/404.png')},
                        {'title': 'foobar', 'id': '123' , 'thumbnail': h.url_for('/images/404.png')},
                        {'title': 'blablupp', 'id': '42', 'thumbnail': h.url_for('/images/404.png')},
                        {'title': 'lolwtf hax !!!11', 'id': '9001', 'thumbnail': h.url_for('/images/404.png')}
                        ]

        return render('/xhtml/results.mako')
        # return request.params['query']
        # return h.form(h.url(action='search'), method='get')
