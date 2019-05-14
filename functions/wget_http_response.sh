#!/bin/bash

script=$(basename "$0")
program="MATLAB INSTALLER"

LOCAL_WEB="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.5.tgz"

local_web_check() {
  local status_code
  status_code=$(wget --spider --server-response "$LOCAL_WEB" 2>&1 | awk '/HTTP\/1.1/{print $2}' | head -1)

  if [ "$status_code" -ne "200" ] ; then
    dialog --backtitle "$script" --title "$program" --infobox "ERROR: CNS LOCAL WEB IS NOT REACHABLE. EXITING." >&2 10 40
    exit 1

  else
    dialog --backtitle "$script" --title "$program" --infobox "CNS LOCAL WEB IS REACHABLE. CONTINUING." >&2 10 40
fi
}

local_web_check
