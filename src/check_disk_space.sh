#!/bin/bash
# In circumstances where df -Hl outputs a decimal we will get an "integer expression expected error", but the program won't exit
# As a precaution, let's go to kbs 
 
check_disk_space () {
  if [ $(df -l --output=avail /usr/local |awk 'FNR == 2 {print $1}' |sed 's/G//') -le "31457280" ]; then
    printf "%s\n" "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2
    exit 1
fi
}

#check_disk_space () {
#  if [ $(df -Hl --output=avail /usr/local |awk 'FNR == 2 {print $1}' |sed 's/G//') -le "30" ]; then
#    printf "%s\n" "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2
#    exit 1
#fi
#}

check_disk_space
