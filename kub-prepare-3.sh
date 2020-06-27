#!/bin/bash

HOST=$(hostname -s)
HOSTMAS01=$(echo "$HOST" | grep -i -c kubmas01)

if [[ $HOSTMAS01 -eq 1 ]]; then #is mas01
    cp -f /opt/kub/kubeadm-config.yaml /root/kubeadm-config.yaml
    mkdir -p /etc/kubernetes/pki/etcd
fi
