from yolanda.lib.base import *

import paste.fileapp
import os

class DownloadFileApp(paste.fileapp.FileApp):
    def __init__(self, path, filename, headers=None, **kwargs):
        self.filename = path
        kwargs['content-type'] = "video/ogg"
        kwargs['Content-Disposition'] =' attachment; filename="'+filename+'"'
        paste.fileapp.DataApp.__init__(self, None, headers, **kwargs)
        
class DownloadController(BaseController):

    def download(self, id, title):
        fapp = DownloadFileApp(
                    path=os.path.join(config['pylons.paths']['static_files'], "videos", id),
                    filename=title+".ogv")
        return fapp(request.environ, self.start_response)
