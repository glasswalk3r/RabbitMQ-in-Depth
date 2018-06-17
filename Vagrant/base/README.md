# Artifacts to generate a base Vagrant image for RabbitMQ

The files included in this directory is to provide an automated way to create base RabbitMQ images to be used for primary and secondary later.

The Vagrantfile and setup.sh shell script will:

1. Update the Ubuntu Linux distribution.
2. Download and install GPG keys from Erlang distribution.
3. Download and install GPG keys from RabbitMQ distribution.
4. Update the Ubuntu APT repositories and install the required software.

This will ensure that all the basic required software to run a RabbitMQ server is in place and use the latest stable versions available.

This current implementation is designed to work only with Virtualbox provider. New providers support could be added later.
