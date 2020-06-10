#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "No Arguments Supplied"
    echo "Arg Options are: remove install reinstall"
    exit
fi
if [ $1 != 'install' ]
then
   rm -rf /var/lib/rook
   apt remove -y docker \
   docker-ce \
   docker-ce-cli \
   kubelet \
   kubeadm \
   kubectl

   rm -rf /etc/kubernetes
   rm -rf /var/lib/docker/*
   rm -rf /var/lib/kubelet/*
   rm -rf /var/lib/etcd
   rm -rf /var/lib/cni/*
   rm -rf /etc/cni/

   ip link show
fi

if [ $1 == 'remove' ]
then
   echo "exiting"
   exit
fi

apt-get update

apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

apt-get install -y docker-ce=5:19.03.8~3-0~ubuntu-bionic docker-ce-cli=5:19.03.8~3-0~ubuntu-bionic containerd.io

# Set up the Docker daemon
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload
systemctl enable docker
systemctl start docker
systemctl status docker
docker version

apt-get install -y kubelet=1.15.7-00 kubeadm=1.15.7-00 kubectl=1.15.7-00

systemctl daemon-reload
systemctl enable kubelet
systemctl start kubelet
systemctl status kubelet

kubeadm init --pod-network-cidr=10.41.0.0/16 --ignore-preflight-errors=all --kubernetes-version=1.15.11

echo "sleeping 10 seconds"
sleep 10

mkdir /home/jtfogar/.kube
cp -i /etc/kubernetes/admin.conf /home/jtfogar/.kube/config
chown jtfogar:jtfogar /home/jtfogar/.kube -R

echo "sleeping 30 seconds"
sleep 30

kubectl get nodes