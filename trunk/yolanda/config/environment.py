"""Pylons environment configuration"""
import os

from pylons import config

import yolanda.lib.app_globals as app_globals
import yolanda.lib.helpers
from yolanda.config.routing import make_map

from sqlalchemy import engine_from_config
from yolanda import model

def load_environment(global_conf, app_conf):
    """Configure the Pylons environment via the ``pylons.config``
    object
    """
    # Pylons paths
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    paths = dict(root=root,
                 controllers=os.path.join(root, 'controllers'),
                 static_files=os.path.join(root, 'public'),
                 templates=[os.path.join(root, 'templates')])

    # Initialize config with the basic options
    config.init_app(global_conf, app_conf, package='yolanda',
                    template_engine='mako', paths=paths)

    config['routes.map'] = make_map()
    config['pylons.g'] = app_globals.Globals()
    config['pylons.h'] = yolanda.lib.helpers

    # Customize templating options via this variable
    tmpl_options = config['buffet.template_options']

    # CONFIGURATION OPTIONS HERE (note: all config options will override
    # any Pylons config options)
    
    config['pylons.response_options']['content_type'] = "application/xhtml+xml"
    # FIXME: this is generally wrong for other XML content

    model.metadata.bind = engine_from_config(config, 'sqlalchemy.')
    model.metadata.bind.echo = True

    # better safe than sorry - everything should be utf-8
    tmpl_options['mako.input_encoding'] = 'utf-8'
