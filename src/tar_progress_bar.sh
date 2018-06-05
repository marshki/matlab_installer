#!/bin/bash 
# Progress bar using tar, pv, and dialog in Linux. 

untar_matlab () {
  (pv --numeric /usr/local/rando.tgz | tar --extract --gzip --directory=/usr/local) 2>&1|
  dialog --backtitle "$script" --title "bleh" --gauge "UNTARRING rando PACKAGE TO /usr/local..." 10 40
}

untar_matlab

