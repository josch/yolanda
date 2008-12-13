## Yolanda, a video CMS for the web
## Copyright (C) 2007, 2008 Nils Dagsson Moskopp, Johannes Schauer

## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU Affero General Public License as
## published by the Free Software Foundation, either version 3 of the
## License, or (at your option) any later version.

## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Affero General Public License for more details.

## You should have received a copy of the GNU Affero General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

import logging
import os

from yolanda.lib.base import *

log = logging.getLogger(__name__)

class SearchController(BaseController):

    def results(self):

        c.query = request.params['query']

        # extremely simple search
        raw_results = []
        raw_results.extend(model.Video.query.filter_by(dc_title=c.query).all())
        raw_results.extend(model.Video.query.filter(model.Video.dc_creator.has(name=c.query)).all())
        raw_results.extend(model.Video.query.filter(model.Video.dc_contributor.any(name=c.query)).all())

        if not raw_results:
            c.message = {
                'type': 'warning',
                'text': 'No results for query "%s".' % c.query
            }
#            c.message['text']='No results for query "%s".' % c.query
            return render('/xhtml/results.mako')

        c.results = []

        for result in raw_results:
            c.results.append(
                {
                'dc_title': result.dc_title,
                'id': result.id,
                'snapshot': os.path.join(config['directory_video-stills'],str(result.id)),
                'thumbnail': os.path.join(config['directory_video-thumbnails'],str(result.id))
                }
            )

        return render('/xhtml/results.mako')
        # return request.params['query']
        # return h.form(h.url(action='search'), method='get'
