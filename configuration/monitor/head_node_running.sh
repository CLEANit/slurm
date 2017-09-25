#!/bin/bash


GPU_PIDs=$(nvidia-smi  | grep -A 10000 PID | grep -v '+-------' | awk 'NR > 2{print $3}' | grep  -v 'running' | sort )


if [[ ! "x$GPU_PIDs" == "x" ]] ;
then
    slurm_PIDs=$(scontrol listpids 2>/dev/null | awk 'NR>1 {print $1}' | sort)
    echo "GPU PIDs:"
    echo $GPU_PIDs
    echo ""
    echo "SLURM PIDs:"
    echo $slurm_PIDs
    echo ""

    echo "GPU PIDs that are not SLURM PIDs:"
    non_slurm_pids=$(diff -U 10000  <(for i in $(echo $GPU_PIDs); do echo $i; done ) <(for j in $(echo $slurm_PIDs); do echo $j; done )  | sed -n 's/^-//p' | awk 'NR>1{print $1}')
    echo $non_slurm_pids

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
            kill -s SIGKILLi $pid
        elif [[ $etime -gt 300 ]]; then
            echo "PID $pid has been running for over 5 minutes and has ignored the previous SIGINTs. Sending SIGTERM."
            kill -s SIGTERM $pid
        elif [[ $etime -gt 5 ]]; then
            echo "PID $pid has been running for over 5 seconds. Sending SIGINT."
            kill -s SIGINT $pid
        fi

    done
fi
