#!/bin/bash

#RUN AS ROOT
#This script can be run at boot, but ensure that the network interface is up before this is run.

LIST_OF_HOSTS='arcee ratchet shockwave starscream'


cd /archive
for host in $LIST_OF_HOSTS;
do
    mkdir -p $host
    mount $host.local:archive/01 $host
done


