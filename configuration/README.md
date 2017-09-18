# SLURM setup

## On all nodes:

1) Install slurm and mail.  Mail just needs to exist, not necessarily _work_.

```bash 
sudo apt-get install slurm-wlm mailutils
```

2) Make the log directory:
``` bash 
sudo mkdir -p /var/spool/slurmd
sudo chown slurm /var/spool/slurmd 
```

3) Copy the `munge.key` present in `munge/` to `/etc/munge/` and set permissions.
```bash 
sudo cp ./munge/munge.key /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key
sudo chown munge /etc/munge/munge.key
sudo chgrp munge /etc/munge/munge.key
```



## On the *head* node:
1) Start the `slurmctld` daemon
``` bash
sudo /etc/init.d/slurmctld start
```




## On each *compute* node:
1) Start the `slurmd` daemon
``` bash
sudo /etc/init.d/slurmd start
```





