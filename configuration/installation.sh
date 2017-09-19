#!/bin/bash

sudo apt-get install slurm-wlm mailutils


sudo mkdir -p /var/spool/slurmd
sudo chown slurm /var/spool/slurmd 


bash update_config.sh

