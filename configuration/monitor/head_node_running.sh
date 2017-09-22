#!/bin/bash

non_slurm_pids=$(comm -23 <(pgrep python) <(scontrol listpids | awk 'NR>1 {print $1}'))

for pid in $non_slurm_pids; 
do 
    echo $pid=$(ps -o etimes= $pid)
done



