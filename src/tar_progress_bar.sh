#!/bin/bash 
# A "dialog" progress bar using tar and pv. 

# Install pre-reqs: 
# sudo apt-get --yes install dialog pv   

# Create a file (optional, but done here for illustrative purposes): 
# sudo fallocate --length 2GB /usr/local/rando.img

# Compress file (optional, but done here for illustrative purposes): 
# tar -cvzf /usr/local/rando.tgz /usr/local/rando.img 
# 


untar_package () {
  (pv --numeric /usr/local/rando.tgz | tar --extract --gzip --directory=/usr/local) 2>&1|
  dialog --backtitle "$script" --title "bleh" --gauge "UNTARRING PACKAGE TO /usr/local..." 10 40
}

untar_package
