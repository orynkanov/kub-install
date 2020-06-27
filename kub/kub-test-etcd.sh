#!/bin/bash

TAG=$(docker images | grep etcd | awk '{print $2}')
IP=$(ip addr | grep 24 | awk '{print $2}' | sed 's/\/24//')

docker run --rm -it \
--net host \
-v /etc/kubernetes:/etc/kubernetes k8s.gcr.io/etcd:"$TAG" etcdctl \
--cert /etc/kubernetes/pki/etcd/peer.crt \
--key /etc/kubernetes/pki/etcd/peer.key \
--cacert /etc/kubernetes/pki/etcd/ca.crt \
--endpoints https://"$IP":2379 endpoint health --cluster
