from yolanda.tests import *

class TestVideoController(TestController):

    def test_index(self):
        response = self.app.get(url_for(controller='video'))
        # Test response...
