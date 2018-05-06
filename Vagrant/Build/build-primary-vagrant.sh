#!/bin/bash

cd "${HOME}"
virtualenv venv
source "${HOME}/venv/bin/activate"
pip install --upgrade pip

echo "
jinja2
paho-mqtt
nose
pika
pamqp
pexpect
pygments
pyzmq
jsonschema
rabbitpy
readline
requests
stomp.py
statelessd
tornado
ipython
jupyter
"  > /tmp/requirements.pip
pip install -r /tmp/requirements.pip
rm /tmp/requirements.pip
