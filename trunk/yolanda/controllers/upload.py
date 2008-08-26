import logging

from yolanda.lib.base import *
from yolanda.lib.gstreamer import info, snapshot, encode
import os
import hashlib

log = logging.getLogger(__name__)

class UploadController(BaseController):

    def index(self):
        return render('/xhtml/upload.mako')
    
    def upload(self):
        upload = request.params['file']
        
        #check if file is video
        videoinfo = info.Info(upload.file)
        if not videoinfo.get_info():
            return "not a valid video"
        
        #check if file is duplicate
        sha256 = hashlib.sha256(upload.file.read(1024*1024)).hexdigest()
        
        if model.Video.query.filter_by(sha256=sha256).count():
            return "duplicate"
        
        video = model.Video(title=request.params['title'],sha256=sha256)
        model.session.commit()
        
        permanent_file = open(os.path.join(config['cache.dir'], str(video.id)), 'w')
        upload.file.seek(0)
        u.copyfileobj(upload.file, permanent_file)
        upload.file.close()
        permanent_file.close()
        
        videoencode = encode.Encode(os.path.join(config['cache.dir'], str(video.id)))
        videoencode.run()
        
        return 'Successfully uploaded: %s'%video.query.all()
