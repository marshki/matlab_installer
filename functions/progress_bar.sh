#!/bin/bash

script=$(basename "$0")
program="PINGDOM"

URL="159.65.178.169"
PCT=100

#===============
# Progress meter
#===============

progress_meter () {
  for ((i=1;i<=PCT;i++)); do
  echo $i;
  sleep 0.1;
  done
}

#==============
# Ping
#==============

# Is URL available? If not, exit.

ping_url () {

  progress_meter | dialog --backtitle "$script" --title "$program" --gauge "PINGING '$URL' ..." 10 40

  if ping -c 1 "$URL" &> /dev/null; then
    dialog --backtitle "$script" --title "$program" --infobox "'$URL' IS REACHABLE. CONTINUING..." 10 40
  else
    dialog --backtitle "$script" --title "$program" --msgbox "ERROR: '$URL' IS NOT REACHABLE. EXITING." >&2 10 40
    exit 1
fi
}

ping_url

