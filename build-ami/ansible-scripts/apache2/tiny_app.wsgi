#!/usr/bin/python
import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0,"/var/www/tiny_app/")

from tiny_app import app as application
application.secret_key = 'Hereisthesecretkey'
