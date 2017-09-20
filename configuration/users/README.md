# Users

All users must have the same UID and GID across the cluster nodes.  The chuid.sh script will change the uid and gid of a specified user, as well as all files owned by the user.

Usage:
```bash
bash chuid.sh <user> <newuid> <newgid>
```
