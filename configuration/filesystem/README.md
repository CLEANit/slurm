#To share the filesystems:

Add the following to cron:
```BASH
@reboot sudo zfs set sharenfs=on archive/01
```

This will mark the zfs archive filesystem as shareable.






Copy `archive_disk_intermount.sh` to `/etc/network/if-up.d` to remount the archive drives when a network interfaces comes up. 






