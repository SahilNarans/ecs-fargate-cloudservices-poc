#!/usr/bin/env bash
# This script installs all the prerequisites needed to run the project.
sudo apt-get update
sudo apt-get install -y gnupg2
sudo apt-get install -y wget
sudo apt-get install -y curl
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update 
sudo apt-get install -y docker-ce
sudo apt-get -y install openjdk-8-jdk
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
sudo apt-get update
sudo apt-get install -y sbt
#cd sbt-project/
sbt test
sbt dist
sbt stage

