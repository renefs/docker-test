#!/bin/bash

echo 'Starting app...'
# We run the application using uwsgi
cp -rf /opt/app-root/app-temp/* /opt/app-root/app
uwsgi --ini /opt/app-root/etc/uwsgi.ini
