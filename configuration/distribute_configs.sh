#!/bin/bash

for host in $(cat hosts);
do
   ssh ${host}.local 'mkdir -p /tmp/slurmconf/; rm /tmp/slurmconf/*'
   scp ./slurm-llnl/*.conf ${host}.local:/tmp/slurmconf/
   ssh -t ${host}.local "sudo cp /tmp/slurmconf/* /etc/slurm-llnl/; sudo systemctl restart slurmd "
done
