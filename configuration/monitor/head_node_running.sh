#!/bin/bash


pids_to_check=$(nvidia-smi  | grep -A 10000 PID | grep -v '+-------' | awk 'NR > 2{print $3}' | grep  -v 'running')
#pids_to_check=$(pgrep python)$pids_to_check


if [[ ! "x$pids_to_check" == "x" ]] ;
then
    echo "Checking to see if $pids_to_check are slurm PIDs"
    non_slurm_pids=$(comm -23 <(echo $pids_to_check) <(scontrol listpids 2>/dev/null | awk 'NR>1 {print $1}'))
else
    echo "No processes to check"
    non_slurm_pids=""
fi

if [[ ! "x$non_slurm_pids" == "x" ]] ;
then

    echo "Processes I'm keeping an eye on: $non_slurm_pids"
    for pid in $non_slurm_pids; 
    do 
        echo -e $pid "\t" $(ps -o etimes= $pid)
    done


    for pid in $non_slurm_pids; 
    do 
        etime=$(ps -o etimes= $pid)
        if [[ $etime -gt 600 ]]; then
            echo "PID $pid has been running for over 10 minutes and has ignored both SIGINTs and SIGTERMs. Sending SIGKILL."
            kill -s SIGKILL $pid
        elif [[ $etime -gt 300 ]]; then
            echo "PID $pid has been running for over 5 minutes and has ignored the previous SIGINTs. Sending SIGTERM."
            kill -s SIGTERM $pid
        elif [[ $etime -gt 5 ]]; then
            echo "PID $pid has been running for over 5 seconds. Sending SIGINT."
            kill -s SIGINT $pid
        fi

    done
fi
