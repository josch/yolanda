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

        raise RuntimeError

        video = model.Video(

            # Dublin Core terms
            dc_title = request.params['dc_title'],
            dc_alternative = request.params['dc_title'],

            dc_subject = [model.DC_Subject(name=u'lol'), model.DC_Subject(name=u'wut')],
#            dc_subject = self.getsubjects(),
#            dc_creator = model.DC_Creator(name = request.params['dc_creator']),

            dc_abstract = request.params['dc_abstract'],

            # TODO: enable several contributors
#            dc_contributor = [model.DC_Contributor(name=contributor.lstrip()) for contributor in  request.params['dc_contributor'].split(',')],
#            dc_contributor = [model.DC_Contributor(name=u'lol'), model.DC_Contributor(name=u'wut')],

            # TODO: insert real data
            dc_created = datetime(9999,9,9).strftime("%Y-%m-%d %H:%M:%S"),
            dc_valid = datetime(9999,9,9).strftime("%Y-%m-%d %H:%M:%S"),
            dc_available = datetime(9999,9,9).strftime("%Y-%m-%d %H:%M:%S"),
            dc_issued = datetime(9999,9,9).strftime("%Y-%m-%d %H:%M:%S"),
            dc_modified = datetime(9999,9,9).strftime("%Y-%m-%d %H:%M:%S"),
            dc_dateAccepted = datetime(9999,9,9).strftime("%Y-%m-%d %H:%M:%S"),
            dc_dateCopyrighted = datetime(9999,9,9).strftime("%Y-%m-%d %H:%M:%S"),
            dc_dateSubmitted = datetime.now().strftime("%Y-%m-%d %H:%M:%S"),

            dc_identifier = '',
            dc_source = '',
            dc_language = request.params['dc_language'],

            # TODO: insert videolength
            dc_extent = timedelta(0),

            dc_spatial = request.params['dc_spatial'],
            dc_temporal = datetime(9999,9,9).strftime("%Y-%m-%d %H:%M:%S"),

            dc_rightsHolder = '',

            # Creative Commons properties
            cc_commercial = (request.params['commercial'] == 'cc_commercial'),
            cc_sharealike = (request.params['modification'] == 'cc_sharealike'),
            cc_derivatives = (request.params['modification'] != 'cc_noderivatives'),

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
        videodestination=os.path.join(config['pylons.paths']['static_files'], config['directory_videos'], str(video.id))
        snapshotdestination=os.path.join(config['pylons.paths']['static_files'], config['directory_video-stills'], str(video.id))
        thumbnaildestination=os.path.join(config['pylons.paths']['static_files'], config['directory_video-thumbnails'], str(video.id))

        # start encoding thread in background
        threading.Thread(target=self.bgencode, args=(videosource, videodestination, snapshotdestination, thumbnaildestination)).start()

        # return 'Successfully uploaded: %s'%video.query.all()
        c.message = {
                    'type': 'information',
                    'text': ''
                    }
        c.message['text']='Your file was successfully uploaded to "%s".'%videodestination
        return render('/xhtml/index.mako')

    def bgencode(self, source, destination, snapshotdestination, thumbnaildestination):
        videosnapshot = snapshot.Snapshot(source).get_snapshot()
        videosnapshot.save(snapshotdestination, 'JPEG')
        videosnapshot.thumbnail((300,150))
        videosnapshot.save(thumbnaildestination, 'JPEG')
        videoencode = encode.Encode(source,destination)
        videoencode.run()
        os.unlink(source)

    def getsubjects(self):
        dc_subject = []
        for subject in  request.params['dc_subject'].split(','):
            s = model.DC_Subject.get_by(name=subject.lstrip())
            if s:
                dc_subject.append(s)
            else:
                dc_subject.append(model.DC_Subject(name=subject.lstrip()))
        return dc_subject
