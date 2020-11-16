#!/bin/bash

apt-get update && apt-get upgrade && apt autoremove && apt install -y va-driver-all &&  \
apt-get upgrade && apt autoremove && apt install -y openssh-server curl git 


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -   

apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

apt-get update && apt autoremove

apt-get update

apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

apt-get install -y docker-ce=5:19.03.8~3-0~ubuntu-bionic docker-ce-cli=5:19.03.8~3-0~ubuntu-bionic containerd.io

mkdir /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "1"
  },
  "storage-driver": "overlay2",
  "insecure-registries" : ["10.10.100.14:5000"]
}
EOF

apt-get install -y docker-ce=5:19.03.13~3-0~ubuntu-bionic docker-ce-cli=5:19.03.13~3-0~ubuntu-bionic containerd.io
mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload
systemctl enable docker
systemctl start docker
systemctl status docker

docker info

apt-get install -y kubelet=1.19.3-00 kubeadm=1.19.3-00 kubectl=1.19.3-00

systemctl daemon-reload
systemctl enable kubelet
systemctl start kubelet
systemctl status kubelet