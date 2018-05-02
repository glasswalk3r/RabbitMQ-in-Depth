#!/bin/bash

# Let aptitude know it's a non-interactive install
export DEBIAN_FRONTEND=noninteractive
wget https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add -
wget -O- https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc | apt-key add -
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
dpkg -i erlang-solutions_1.0_all.deb
rm -v erlang-solutions_1.0_all.deb
apt-get update
apt-get remove -y -qq chef puppet
apt-get autoremove -y -qq
apt-get -y upgrade
apt-get -y install esl-erlang
apt-get -y install rabbitmq-server
