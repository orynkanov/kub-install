#!/bin/bash

for HOST in kubetc01 kubetc02 kubetc03 kublb01 kublb02 kubmas01 kubmas02 kubnod01 kubnod02; do
    echo START $HOST
    rsync -aP --delete ./kub-prepare*.sh $HOST:/opt/
    rsync -aP --delete ./kub $HOST:/opt/
    ssh $HOST /opt/kub-prepare-3.sh
    if [[ $HOST == 'kubmas01' ]]; then
	rsync -aP kubetc01:/etc/kubernetes/pki /tmp/
	rsync -aP /tmp/pki/etcd/ca.crt $HOST:/etc/kubernetes/pki/etcd/
	rsync -aP /tmp/pki/apiserver-etcd-client.crt $HOST:/etc/kubernetes/pki/
	rsync -aP /tmp/pki/apiserver-etcd-client.key $HOST:/etc/kubernetes/pki/
	rm -rf /tmp/pki
    fi
    echo -e FINISH $HOST "\n\n\n\n\n"
done
