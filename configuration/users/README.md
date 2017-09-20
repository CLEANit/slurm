# Users

All users must have the same UID and GID across the cluster nodes.  The chuid.sh script will change the uid and gid of a specified user, as well as all files owned by the user.

Usage:
```bash
sudo bash chuid.sh <user> <newuid> <newgid>
```

Note that `<user>` cannot be logged in, or have any running processes, or the usermod command will silently fail.  I attempt to catch this with a `ps -u <user>`, so hopefully this is sufficient. 
