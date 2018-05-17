#!/bin/bash
# Works in Ubuntu but not Raspbian. Need to test...

check_disk_space () {
  if [ $(df -Hl --output=avail /usr/local |awk 'FNR == 2 {print $1}' |sed 's/G//') -le "30" ]; then
    printf "%s\n" "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2
    exit 1
fi
}

check_disk_space
