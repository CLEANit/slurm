# How to use SLURM on the transformers:


SLURM is configured on the transformers, that is:
```
arcee
shockwave
ratchet
starscream
```
It is configured in _Backfill/FIFO mode_, that is First In First Out, with backfill. This means, that jobs will largely be run in the order they are submitted, but the scheduler will attempt to make efficient use of multiple GPU jobs, backfilling where necessary. There is no job accounting, and every user is treated equally in the queue.  Please use it responsibly.

This enables users to queue GPU (or CPU) jobs. 

Since these nodes do not share a filesystem, jobs must be submitted a bit differently than the traditional cluster setup, with the specific node on which they are destined to run specified in the submit script. If the node is not specified, the job will run on _any_ node, and consequently file dependencies will either not be met, or files will be placed (or worse, overwritten) on a node not expected.

Here is the minimal submit script for running a GPU-enabled Python script on two GPUs on shockwave:

```bash
#!/bin/bash
#SBATCH --gres=gpu:2
#SBATCH --nodelist='shockwave'

python train.py

```


Additional options can be added, such as a walltime limit, and the location of the stdout:


```bash
#!/bin/bash
#SBATCH --gres=gpu:2
#SBATCH --nodelist='shockwave'
#SBATCH --time 12:00:00
#SBATCH -o stdout

python train.py

```


 
The submit script can be placed in a file, say `submit.s`, and then the job can be submitted using
```bash 
sbatch submit.s
```
