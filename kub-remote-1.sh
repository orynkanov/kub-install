#!/bin/bash

yum install rsync -y
for HOST in kubetc01 kubetc02 kubetc03 kublb01 kublb02 kubmas01 kubmas02 kubnod01 kubnod02; do
    echo START $HOST
    ssh $HOST yum install rsync -y
    rsync -aP --delete ./kub-prepare*.sh $HOST:/opt/
    rsync -aP --delete ./kub $HOST:/opt/
    ssh $HOST /opt/kub-prepare-1.sh
    ssh $HOST reboot
    echo -e FINISH $HOST "\n\n\n\n\n"
done

cp -f /opt/kub/kubernetes.repo /etc/yum.repos.d/kubernetes.repo
yum install -y kubeadm kubectl --disableexcludes=kubernetes
