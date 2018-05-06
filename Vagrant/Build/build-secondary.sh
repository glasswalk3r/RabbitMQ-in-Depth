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
apt-get install -y -qq rabbitmq-server

# Clean up apt-leftovers
apt-get -qq -y remove curl unzip
apt-get autoremove -y
apt-get clean
#rm -rf /var/lib/{apt,dpkg,cache,log}/

# Stop the already running RabbitMQ server
service rabbitmq-server stop

# Add the erlang cookie
echo "XBCDDYAVPRVEYREVJLXS" > /var/lib/rabbitmq/.erlang.cookie
chmod go-rwx /var/lib/rabbitmq/.erlang.cookie
chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie

#  Update the RabbitMQ configuration
echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config

# Add the plugins
PLUGINS=( rabbitmq_consistent_hash_exchange rabbitmq_management rabbitmq_management_visualiser rabbitmq_federation rabbitmq_federation_management rabbitmq_shovel rabbitmq_shovel_management rabbitmq_mqtt rabbitmq_stomp rabbitmq_tracing rabbitmq_web_stomp rabbitmq_web_stomp_examples rabbitmq_amqp1_0 )
for plugin in "${PLUGINS[@]}"
do
  rabbitmq-plugins --offline enable ${plugin}
done

service rabbitmq-server start
