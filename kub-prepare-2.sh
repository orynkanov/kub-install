#!/bin/bash

HOST=$(hostname -s)
HOSTETC01=$(echo "$HOST" | grep -i -c kubetc01)

if [[ $HOSTETC01 -eq 1 ]]; then #is etc01
    /opt/kub/kub-prepare-etcd.sh
fi
