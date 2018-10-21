#!/usr/bin/env bash
# available disk space check   

check_disk_space () {
  # df on locally-mounted file systems in kbs | get 2nd line, 4th field 
  # less than or equal to " "

  if [ "$(df -lk /Applications |awk 'FNR == 2 {print $4}')" -le "7717519" ]; then
    printf "%s\\n" "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2
    exit 1
fi
}

check_disk_space
