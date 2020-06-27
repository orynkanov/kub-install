#!/bin/bash

for HOST in kubetc01 kubetc02 kubetc03 kublb01 kublb02 kubmas01 kubmas02 kubnod01 kubnod02; do
    echo START $HOST
    rsync -aP --delete ./kub-prepare*.sh $HOST:/opt/
    rsync -aP --delete ./kub $HOST:/opt/
    ssh $HOST /opt/kub-prepare-2.sh
    if [[ $HOST == 'kubetc01' ]]; then
	rsync -aP $HOST:/tmp/192.168.0.112 /tmp/
	rsync -aP /tmp/192.168.0.112/kubeadmcfg.yaml kubetc02:/root/
	rsync -aP /tmp/192.168.0.112/pki kubetc02:/etc/kubernetes/
	rm -rf /tmp/192.168.0.112
	rsync -aP $HOST:/tmp/192.168.0.113 /tmp/
        rsync -aP /tmp/192.168.0.113/kubeadmcfg.yaml kubetc03:/root/
	rsync -aP /tmp/192.168.0.113/pki kubetc03:/etc/kubernetes/
	rm -rf /tmp/192.168.0.113
	ssh $HOST rm -rf /tmp/192.168.0.112
	ssh $HOST rm -rf /tmp/192.168.0.113
    fi
    echo -e FINISH $HOST "\n\n\n\n\n"
done

ssh kubetc01 /opt/kub/kub-init-etcd.sh
ssh kubetc02 /opt/kub/kub-init-etcd.sh
ssh kubetc03 /opt/kub/kub-init-etcd.sh

sleep 1m
ssh -tt kubetc01 /opt/kub/kub-test-etcd.sh
ssh -tt kubetc02 /opt/kub/kub-test-etcd.sh
ssh -tt kubetc03 /opt/kub/kub-test-etcd.sh
