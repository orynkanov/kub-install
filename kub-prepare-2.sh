#!/bin/bash

HOST=`hostname -s`
HOSTETC01=`echo $HOST | grep -i kubetc01 | wc -l`

if [[ $HOSTETC01 -eq 1 ]]; then #is etc01
    /opt/kub/kub-prepare-etcd.sh
fi
