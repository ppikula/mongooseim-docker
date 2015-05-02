#!/bin/bash

/opt/mongooseim/rel/mongooseim/bin/mongooseimctl start&
sleep 5
tail -F /opt/mongooseim/rel/mongooseim/log/ejabberd.log
