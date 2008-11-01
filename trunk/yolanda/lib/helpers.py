"""Helper functions

Consists of functions to typically be used within templates, but also
available to Controllers. This module is available to both as 'h'.
"""
from webhelpers import *

# between 0.9.6 and 0.9.7, some things are no longer imported by default
from routes import url_for
