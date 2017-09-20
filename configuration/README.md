# SLURM setup

## On all nodes:

0) Add `deb http://ftp.de.debian.org/debian sid main` to /etc/apt/sources.list`.


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

4) Copy the `slurm.conf` and other configuration files to `/etc/slurm-llnl/`:
```bash
sudo cp ./slurm-llnl/*.conf /etc/slurm-llnl/
```


## On the *head* node:
1) Start the `munge` and `slurmctld` daemons.
``` bash
sudo systemctl start munge
sudo systemctl start slurmctld
```




## On each *compute* node:
1) Start the `munge` and `slurmd` daemon
``` bash
sudo systemctl start munge
sudo systemctl start slurmd
```





