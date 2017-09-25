#!/bin/bash


while true; do
    sleep 1


non_slurm_pids=$(comm -23 <(pgrep python) <(scontrol listpids 2>/dev/null | awk 'NR>1 {print $1}'))

echo "Processes I'm keeping an eye on:"
for pid in $non_slurm_pids; 
do 
    echo -e $pid "\t" $(ps -o etimes= $pid)
done




for pid in $non_slurm_pids; 
do 
    etime=$(ps -o etimes= $pid)
    if [[ $etime -gt 600 ]]; then
        echo "PID $pid has been running for over 10 minutes. Sending SIGINT."
        kill -s SIGINT $pid
    fi

    if [[ $etime -gt 900 ]]; then
        echo "PID $pid has been running for over 15 minutes and has ignored the previously sent SIGINTs. Sending SIGKILL."
        kill -s SIGKILL $pid
    fi
done

done

