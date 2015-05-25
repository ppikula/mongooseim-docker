#!/bin/bash
MIMDIR="/opt/mongooseim/rel/mongooseim/"

if [ -n "$HOSTNAME" ]; then
    VMARGS=/opt/mongooseim/rel/mongooseim/etc/vm.args
    echo "-kernel inet_dist_listen_min 9100 inet_dist_listen_max 9100" >> $VMARGS
    SEDARG="-i 's/sname mongooseim@localhost/sname mongooseim@$HOSTNAME/g' $VMARGS"
    eval sed "$SEDARG"
fi


if [ -n "$CLUSTER_WITH" ]; then
   $MIMDIR/bin/mongooseimctl add_to_cluster mongooseim@$CLUSTER_WITH
fi

mkdir -p "$MIMDIR/Mnesia.mongooseim@$HOSTNAME"
ln -sfn "$MIMDIR/Mnesia.mongooseim@$HOSTNAME" "/data/mnesia/Mnesia.mongooseim@$HOSTNAME" 

if [ "$#" -ne 1 ]; then
   $MIMDIR/bin/mongooseim live --noshell -noinput +Bd
else
   $MIMDIR/bin/mongooseimctl $1
fi

