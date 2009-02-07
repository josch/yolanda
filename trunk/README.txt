This file is for you to describe the Yolanda application. Typically
you would include information such as the information below:

Installation and Setup
======================

Install ``Yolanda`` using easy_install::

    easy_install Yolanda

Make a config file as follows::

    paster make-config Yolanda config.ini

Tweak the config file as appropriate and then setup the application::

    paster setup-app config.ini

Then you are ready to go.

Resetting the database can be accomplished by deleting the database.sql file and 
running the setup command again.
