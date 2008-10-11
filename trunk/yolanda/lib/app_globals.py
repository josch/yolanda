"""The application's Globals object"""
from pylons import config

class Globals(object):
    """Globals acts as a container for objects available throughout the
    life of the application
    """

    def __init__(self):
        """One instance of Globals is created during application
        initialization and is available during requests via the 'g'
        variable
        """
        self.application_name = "Yolanda"
        self.platform_name = "Demo Application"
        self.platform_slogan = "Welcome to Demo Application, a video CMS without a slogan."
        self.developers = ("Nils Dagsson Moskopp", "Johannes Schauer")
        pass
