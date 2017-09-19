#!/bin/bash

sudo systemctl enable munge
sudo systemctl enable slurmctld
sudo systemctl disable slurmd

