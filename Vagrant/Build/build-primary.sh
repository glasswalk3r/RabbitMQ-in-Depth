#!/bin/bash

# Add the vagrant node primary addresses
echo "
# Vagrant Node Private Addresses
192.168.50.4 primary
192.168.50.5 secondary
" >> /etc/hosts

# Let aptitude know it's a non-interactive install
export DEBIAN_FRONTEND=noninteractive

# Install packages
apt-get install -y git python-pip python-dev ncurses-dev libjpeg8 python-imaging python-numpy python-opencv virtualenv

# Clean up apt-leftovers
apt-get -y remove curl
apt-get autoremove -y
apt-get clean

# Stop the already running RabbitMQ server
service rabbitmq-server stop

# Add the erlang cookie
echo "XBCDDYAVPRVEYREVJLXS" > /var/lib/rabbitmq/.erlang.cookie
chmod go-rwx /var/lib/rabbitmq/.erlang.cookie
chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie

#  Update the RabbitMQ configuration
echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config

# Add the plugins
PLUGINS=(rabbitmq_consistent_hash_exchange rabbitmq_management
rabbitmq_management_visualiser rabbitmq_federation rabbitmq_federation_management
rabbitmq_shovel rabbitmq_shovel_management rabbitmq_mqtt rabbitmq_stomp
rabbitmq_tracing rabbitmq_web_stomp rabbitmq_web_stomp_examples rabbitmq_amqp1_0)

for plugin in "${PLUGINS[@]}"
do
    cmd="rabbitmq-plugins --offline enable ${plugin}"
    echo "Executing '${cmd}'"
    $cmd
done

service rabbitmq-server start

# Get the RabbitMQ-In-Depth git repo
mkdir -p /opt
if [ ! -d "/opt/rabbitmq-in-depth" ]; then
  git clone https://github.com/gmr/RabbitMQ-in-Depth.git /opt/rabbitmq-in-depth
fi
chown -R vagrant:vagrant /opt/rabbitmq-in-depth
