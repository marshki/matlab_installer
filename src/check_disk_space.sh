#!/bin/bash

# In circumstances where df -Hl outputs a decimal we will get an "integer expression expected error", 
# but the program won't exit. As a precaution, let's go to kbs.  
 

# Linux 
check_disk_space_linux () {
  if [ $(df -l --output=avail /usr/local |awk 'FNR == 2 {print $1}' |sed 's/G//') -le "31457280" ]; then
    printf "%s\n" "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2
    exit 1
fi
}

# OS X

check_disk_space_osx () {
  if [ $(df -l /Applications |awk 'FNR == 2 {print $4}' |sed 's/G//') -le "31457280000" ]; then
    printf "%s\n" "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2
    exit 1
fi
}

check_disk_space_osx
