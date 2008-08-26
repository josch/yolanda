import logging

from yolanda.lib.base import *
from yolanda.lib.gstreamer import info, snapshot
import os

log = logging.getLogger(__name__)

class UploadController(BaseController):

    def index(self):
        return render('/xhtml/upload.mako')
    
    def upload(self):
        myfile = request.params['file']
        permanent_file = open(os.path.join(myfile.filename.lstrip(os.sep)),'w')

        #u.copyfileobj(myfile.file, permanent_file)
        
        foo=model.Video(title=u"foooooo")
        model.session.commit()
        
        videoinfo = info.Info(myfile.file)
        videoinfo.get_info()
        print videoinfo.print_info()
        
        myfile.file.close()
        permanent_file.close()

        return 'Successfully uploaded: %s'%""

