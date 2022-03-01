#!/bin/bash
sudo yum update -y
wget https://d6opu47qoi4ee.cloudfront.net/install_mattermost_linux.sh

sudo yum install dos2unix -y
sudo dos2unix install_mattermost_linux.sh

chmod 700 install_mattermost_linux.sh
sudo ./install_mattermost_linux.sh ${db_server_privateip}
sudo chown -R mattermost:mattermost /opt/mattermost
sudo chmod -R g+w /opt/mattermost
cd /opt/mattermost
sudo -u mattermost ./bin/mattermost
