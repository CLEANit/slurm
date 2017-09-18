#!/bin/bash

sudo cp ./munge/munge.key /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key
sudo chown munge /etc/munge/munge.key
sudo chgrp munge /etc/munge/munge.key

sudo cp ./slurm-llnl/*.conf /etc/slurm-llnl/


sudo /etc/init.d/munge start

