#!/bin/bash

sudo apt-get update
sudo apt-get -y upgrade

#Installs chef
curl -L https://www.opscode.com/chef/install.sh | sudo bash