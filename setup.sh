#!/bin/bash

# after ubuntu install
sudo apt-get update && apt-get upgrade && apt autoremove && apt install -y va-driver-all &&  apt-get upgrade && apt autoremove && apt install -y openssh-server curl git 
sudo apt install -y update-manager-core 
sudo do-release-upgrade

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -   

sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

sudo apt-get update

