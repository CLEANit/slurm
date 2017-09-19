#!/bin/bash

sudo systemctl enable munge
sudo systemctl disable slurmctld
sudo systemctl enable slurmd

