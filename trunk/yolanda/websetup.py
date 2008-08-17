"""Setup the Yolanda application"""
import logging

from paste.deploy import appconfig
from pylons import config

from yolanda.config.environment import load_environment

from yolanda.model import metadata

log = logging.getLogger(__name__)

def setup_config(command, filename, section, vars):
    """Place any commands to setup yolanda here"""
    conf = appconfig('config:' + filename)
    load_environment(conf.global_conf, conf.local_conf)
    
    log.info("Creating tables")
    metadata.create_all()
    log.info("Successfully setup")

