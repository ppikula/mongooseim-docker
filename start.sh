#!/bin/bash

if [ -n "$HOSTNAME" ]; then
    VMARGS=/opt/mongooseim/rel/mongooseim/etc/vm.args
    echo "-kernel inet_dist_listen_min 9100 inet_dist_listen_max 9100" >> $VMARGS
    SEDARG="-i 's/sname mongooseim@localhost/sname mongooseim@$HOSTNAME/g' $VMARGS"
    eval sed "$SEDARG"
fi

if [ -n "$CLUSTER_WITH" ]; then
    mongooseimctl add_to_cluster mongooseim@$CLUSTER_WITH
fi

if [ "$#" -ne 1 ]; then
    mongooseimctl start
    sleep 2
    tail -F $MONGOOSEIM_REL_DIR/log/ejabberd.log
else
    mongooseimctl $1
fi
