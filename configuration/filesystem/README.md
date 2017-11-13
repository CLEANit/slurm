#To share the filesystems:

Add the following to cron:
```BASH
@reboot sudo zfs set sharenfs=on archive/01
```




