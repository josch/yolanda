## <one line to give the program's name and a brief idea of what it does.>
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

from yolanda.lib.base import *
from yolanda.lib.gstreamer import info, snapshot, encode

import os
import hashlib
import threading

from datetime import datetime, timedelta

log = logging.getLogger(__name__)

class UploadController(BaseController):

    def index(self):
        return render('/xhtml/upload.mako')

    def upload(self):
        upload = request.params['file'] # request.param.get('file') is better maybe, doesn't raise a KeyError exception

        # check if file is video
        videoinfo = info.Info(upload.file)
        if not videoinfo.get_info():
            c.message = {
                        'type': 'error',
                        'text': 'Your file was not recognized as a video. Go figure.'
                        }
            return render('/xhtml/upload.mako')

        # check if file is duplicate
        upload.file.seek(0)
        sha256 = hashlib.sha256(upload.file.read(1024*1024)).hexdigest()

#        if model.Video.query.filter_by(sha256=sha256).count():
#            c.message = {
#                        'type': 'error',
#                        'text': 'Your file was already uploaded. Go away.'
#                        }
#            return render('/xhtml/upload.mako')

        # TODO: set up safeguards against omitted / wrong data

        # set up database entry
        video = model.Video(

            # Dublin Core terms
            dc_title = request.params['title'],
            dc_creator = request.params['creator'],
            dc_subject = request.params['subject'],

            dc_abstract = request.params['abstract'],

            # TODO: enable several contributors
            dc_contributor = '',

            dc_created = '',
            dc_valid = '',
            dc_available = '',
            dc_issued = '',
            dc_modified = '',
            dc_dateAccepted = '',
            dc_dateCopyrighted = '',
            dc_dateSubmitted = datetime.today().isoformat(),

            dc_identifier = '',
            dc_source = '',
            dc_language = request.params['language'],

            dc_extent = timedelta(0), # TODO: insert videolength

            dc_spatial = request.params['spatial'],
            dc_temporal = request.params['temporal'],

            dc_rightsHolder = '',

            # Creative Commons properties
            cc_commercial = (request.params['commercial'] == 'commercial'),
            cc_sharealike = (request.params['modification'] == 'sharealike'),
            cc_derivatives = (request.params['modification'] != 'noderivatives'),

            sha256=sha256
            )
        model.session.commit()

        # copy file to temporary destination
        temp_file = open(os.path.join(config['cache.dir'], str(video.id)), 'w')
        upload.file.seek(0)
        u.copyfileobj(upload.file, temp_file)
        upload.file.close()
        temp_file.close()

        # define stuff
        videosource=os.path.join(config['cache.dir'], str(video.id))
        videodestination=os.path.join(config['pylons.paths']['static_files'], "videos", str(video.id))
        imagedestination=os.path.join(config['pylons.paths']['static_files'], "video-stills", str(video.id))

        # start encoding unt snapshot threads in background
        threading.Thread(target=self.bgencode, args=(videosource, videodestination, imagedestination)).start()

        # return 'Successfully uploaded: %s'%video.query.all()
        c.message = {
                    'type': 'information',
                    'text': ''
                    }
        c.message['text']='Your file was successfully uploaded to "%s".'%videodestination
        return render('/xhtml/index.mako')

    def bgencode(self, source, destination, snapshotdestination):
        videosnapshot = snapshot.Snapshot(source).get_snapshot()
        videosnapshot.save(snapshotdestination, "JPEG")
        videoencode = encode.Encode(source,destination)
        videoencode.run()
        os.unlink(source)
