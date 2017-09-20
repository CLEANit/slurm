#!/bin/bash

#Create the user if it doesn't exist
id -u $1 || adduser $1


if [[ ! "x$(ps -u $1 | wc -l)" == "x1" ]];
then
   echo "User $1 has running processes:"
   ps -u $1
   echo "UID cannot be changed when user is logged in or running processes."
   echo "I can attempt to kill their running processes.  Is this what you want?  Type 1 or 2."
   select yn in "Yes" "No"; do
      case $yn in 
         Yes ) sudo kill -9 $(ps -u $1 | awk 'NR>1 {print $1}' ); break;;
         No ) exit ;;
      esac
   done
fi
exit

oldUID=$(id -u $1)
oldGID=$(id -g $1)

usermod -u $2 $1
groupmod -g $3 $1

find / -group $oldGID -exec chgrp -h $1 {} + 
find / -user $oldUID -exec chown -h $1 {} + 
