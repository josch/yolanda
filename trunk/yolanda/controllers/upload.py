import logging

from yolanda.lib.base import *

log = logging.getLogger(__name__)

class UploadController(BaseController):

    def index(self):
        return render('/xhtml/upload.mako')
    
    def upload(self):
        myfile = request.params['file']
        permanent_file = open(os.path.join(
                                           myfile.filename.lstrip(os.sep)),
                              'w')

        u.copyfileobj(myfile.file, permanent_file)
        myfile.file.close()
        permanent_file.close()

        return 'Successfully uploaded: %s'%myfile.filename

