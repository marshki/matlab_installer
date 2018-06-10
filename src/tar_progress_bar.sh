#!/bin/bash

# A "dialog" progress bar for opening an archive, using tar and pv.

script=`basename "$0"`
program="Tar & Feather"

# Change dirs, then install pre-reqs:

cd /home/*/Desktop && apt-get --yes install dialog pv

# Create file (optional, but done here for illustrative purposes): 

fallocate --length 2GB rando.img
 
# Create tar archive (optional, but done here for illustrative purposes):

tar --create --verbose --gzip --file=/usr/local/rando.tgz rando.img

# Untar 

untar_blob () {
  (pv --numeric /usr/local/rando.tgz | tar --extract --gzip --directory=/usr/local) 2>&1|
  dialog --backtitle "$script" --title "$program" --gauge "OPENING TAR ARCHIVE IN /usr/local..." 10 40
}

main () { 
  untar_blob
}

main "$@"
