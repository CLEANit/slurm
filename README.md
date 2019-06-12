# How to use SLURM on the transformers:


SLURM is configured on the transformers, that is:
```
Gen-1:
  arcee
  shockwave
  ratchet
  starscream
Gen-2:
  bumblebee
Gen-3:
  chromia
  thundercracker
  moonracer
```
The maximum walltime for a job is 24 hours, and the default job length if no time limit is specified is 10 minutes. Shorter jobs can potentially see lower queue times because the scheduler can backfill.

Since these nodes do not share a filesystem, jobs should likely be submitted a bit differently than a traditional cluster setup, with the specific node on which they are destined to run specified in the submit script. If the node is not specified, the job will run on _any_ node, and consequently file dependencies will either not be met, or files will be placed (or worse, overwritten) on a node not expected.  See the section "Node-agnostic queues" below for more information. 

Here is the minimal submit script for running a GPU-enabled Python script on two GPUs on shockwave:

```bash
#!/bin/bash
#SBATCH --gres=gpu:2
#SBATCH -p shockwave

python train.py

```

Additional options can be added, such as a walltime limit, and the location of the stdout:


```bash
#!/bin/bash
#SBATCH --gres=gpu:2
#SBATCH -p shockwave
#SBATCH --time 12:00:00
#SBATCH -o stdout

python train.py

```
 
The submit script can be placed in a file, say `submit.s`, and then the job can be submitted using
```bash 
sbatch submit.s
```


You can also run in the terminal (without a submit script) by using the `srun` command:
``` bash
srun -p $HOSTNAME --gres=gpu:3 python script.py
```
however the submit script method is recommended to avoid jobs being killed upon ssh connection loss.

This will run the the `script.py` python script with 3 GPUs available on arcee.


## Job accounting and priority
Slurm is configured to keep track of job usage and schedule jobs based on a fair share priority.  That is, users who consume more resources will be prioritized below infrequent users.  Each running job has an associated "cost" that is billed based on the resources requested.  For example, a four-GPU job will be billed at 4x the rate of a single-GPU job, and GPUs will be billed based on their memory/performance, with higher-performing GPUs (e.g. bumblebee, chromia), costing more than the others.

### Free queues
There are some "free-queues" which cost nothing against your priority to run in.  These are the `lp*` queues (`lp=low priority`), and the `gpu_med` (gpu, medium priority) queue. Jobs will, however be instantaneously preemtpted by jobs submitted to higher priority queues, so these should only be used for long-running, frequently-checkpointing jobs that are prepared to die at any given time.

## Node-agnostic queues
Jobs submitted to the `gpu`, `cpu`, and `gpu_med` partitions will be run on _any_ available node. If you would like your job to run on a specific node, make sure to specify `--nodelist=nodename` to sbatch.  *Be very careful in these queues as there is no shared filesystem.  e.g. if you submit your job with `-p gpu` from `arcee:/home/experiment`, the job could run on `ratchet` with working directory `ratchet:/home/experiment`.  In the ideal case, the files will not exist and your job will fail, but worst case you will unexpectedly overwrite some files on `ratchet`.



## Longer walltime
For maximum throughput and sharing of resources, the walltime is set at a 24-hour maximum. To make longer-running jobs easier, I have set up a submission wrapper `sbatchchain` which will submit a "chain" of jobs, each dependent on the completion of the previous job.  For example
```bash
sbatchchain submit.s 10
```
will submit 10 instances of `submit.s` to run in sequence.  Note that this doesn't preserve your environment, etc. so you should have checkpointing (saving/restoring) configured in whatever program you're running.   

This script merely uses the `--dependency` options of Slurm and comes with no warranty.  Take a look at the script before using it to make sure it meets your needs:

```bash
cat $(which sbatchchain)
```


# Software
### Python and python modules
Generally, it is recommended that each user maintain their own environment using Anaconda.  The fastest way to install Anaconda is by running
```bash /software/anaconda/Anaconda3-2019.03-Linux-x86_64.sh```
The version of Anaconda maintained here may not be the most recent. If you want to be sure you're using the most recent version, download it from here: https://www.anaconda.com/distribution/

#### TensorFlow, PyTorch, etc.
Python modules that depend on CUDA and CuDNN should be installed using the `conda` package manager and *not* pip.  You will probably wish to install the GPU-accelerated versions, e.g. 

```bash
conda install tensorflow-gpu
```

Using `conda` allows Anaconda to manage the CUDA and CuDNN libraries. If you get a missing `libcudart.so` error, chances are your TensorFlow or PyTorch was installed using `pip`.

### Other software

Some other software is provided through `modules`.  Use 
```bash
module avail
```
to see what is available and 
```bash 
module load XXX
```
to add the software to your $PATH.

### Other, other software

If specific software is required that requires sudo access to install, please ask @millskyle to install it by posting in #comp-transformers Slack channel. 




