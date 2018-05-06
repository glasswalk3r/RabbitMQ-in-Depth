#!/bin/bash
# Configuration file for ipython-notebook.
mkdir -p /var/log/ipython
mkdir -p /home/vagrant/.ipython/profile_default
echo "c = get_config()

c.InteractiveShell.autoindent = True
c.NotebookApp.ip = '*'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False
c.NotebookApp.ipython_dir = u'/home/vagrant/.ipython'
c.NotebookApp.notebook_dir = u'/opt/rabbitmq-in-depth/notebooks'
c.ContentsManager.hide_globs = [u'__pycache__', '*.pyc', '*.pyo', '.DS_Store', '*.so', '*.dylib', '*~', 'ch6']
" > /home/vagrant/.ipython/profile_default/ipython_notebook_config.py
chown vagrant:vagrant -R /home/vagrant/.ipython

echo "[Unit]
Description=Jupyter Notebook Server

[Service]
Type=simple
Environment="PATH=/home/vagrant/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
ExecStart=/home/vagrant/venv/bin/python /home/vagrant/venv/bin/jupyter notebook
User=vagrant
Group=vagrant
WorkingDirectory=/home/vagrant

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/jupyter.service

echo "[Unit]
Description=Statelessd
[Service]
Type=simple
Environment="PATH=/home/vagrant/venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
ExecStart=/home/vagrant/venv/bin/python /home/vagrant/venv/bin/tinman -c /etc/statelessd.yml -f
User=vagrant
Group=vagrant
WorkingDirectory=/home/vagrant

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/statelessd.service

echo "%YAML 1.2
---
Daemon:
  pidfile: /var/run/statelessd/statelessd.pid
  user: nginx

Application:
  debug: False
  xsrf_cookies: false
  paths:
    base: /usr/local/share/statelessd
    static: static
    templates: templates
  rabbitmq:
    host: localhost
    port: 5672

HTTPServer:
  no_keep_alive: false
  ports: [8900]
  xheaders: false

Routes:
 - ['/([^/]+)/([^/]+)/([^/]+)', statelessd.Publisher]
 - [/stats, statelessd.Stats]
 - [/, statelessd.Dashboard]

Logging:
  version: 1
  formatters:
    verbose:
      format: '%(levelname) -10s %(asctime)s %(processName)-20s %(name) -35s %(funcName) -30s: %(message)s'
      datefmt: '%Y-%m-%d %H:%M:%S'
    syslog:
      format: '%(levelname)s <PID %(process)d:%(processName)s> %(name)s.%(funcName)s(): %(message)s'
  filters: []
  handlers:
    console:
      class: logging.StreamHandler
      formatter: verbose
      debug_only: false
    syslog:
      class: logging.handlers.SysLogHandler
      facility: daemon
      address: /dev/log
      formatter: syslog
  loggers:
    clihelper:
      level: WARNING
      propagate: true
      handlers: [console, syslog]
    pika:
      level: INFO
      propagate: true
      handlers: [console, syslog]
    pika.adapters:
      level: DEBUG
      propagate: true
      handlers: [console, syslog]
    pika.connection:
      level: DEBUG
      propagate: true
      handlers: [console, syslog]
    statelessd:
      level: INFO
      propagate: true
      handlers: [console, syslog]
    tinman:
      level: INFO
      propagate: true
      handlers: [console, syslog]
    tornado:
      level: WARNING
      propagate: true
      handlers: [console, syslog]
  disable_existing_loggers: true
  incremental: false
" > /etc/statelessd.yml
