#!/bin/bash

sudo apt-get install slurm-wlm mailutils


sudo mkdir -p /var/spool/slurmd
sudo chown slurm /var/spool/slurmd 

sudo cp ./munge/munge.key /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key
sudo chown munge /etc/munge/munge.key
sudo chgrp munge /etc/munge/munge.key

sudo cp ./slurm-llnl/*.conf /etc/slurm-llnl/

