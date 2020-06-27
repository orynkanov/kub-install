#!/bin/bash

HOST=$(hostname -s)
HOSTLB=$(echo "$HOST" | grep -i -c kublb)
HOSTETC=$(echo "$HOST" | grep -i -c kubetc)

if [[ $HOSTLB -eq 0 ]]; then #is not lb
    cp -f /opt/kub/k8s.conf /etc/sysctl.d/k8s.conf
    echo "br_netfilter" > /etc/modules-load.d/br_netfilter.conf
    
    systemctl disable firewalld
    
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum update -y && yum install -y containerd.io-1.2.13 docker-ce-19.03.8 docker-ce-cli-19.03.8
    mkdir /etc/docker
    cp -f /opt/kub/daemon.json /etc/docker/daemon.json
    mkdir -p /etc/systemd/system/docker.service.d
    systemctl daemon-reload
    systemctl enable docker
    
    cp -f /opt/kub/kubernetes.repo /etc/yum.repos.d/kubernetes.repo
    yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
    systemctl enable kubelet
fi

if [[ $HOSTLB -eq 1 ]]; then #is lb
    cp -f /opt/kub/bind.conf /etc/sysctl.d/bind.conf
    
    systemctl disable firewalld
    
    yum install -y haproxy keepalived
    cp -f /opt/kub/haproxy.cfg."$HOST" /etc/haproxy/haproxy.cfg
    cp -f /opt/kub/keepalived.conf."$HOST" /etc/keepalived/keepalived.conf
    systemctl enable haproxy
    systemctl enable keepalived
fi

if [[ $HOSTETC -eq 1 ]]; then #is etc
    mkdir -p /etc/systemd/system/kubelet.service.d
    cp -f /opt/kub/20-etcd-service-manager.conf /etc/systemd/system/kubelet.service.d
    systemctl daemon-reload
fi
