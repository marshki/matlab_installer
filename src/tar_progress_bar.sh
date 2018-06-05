#!/bin/bash 

# Progress bar using tar, pv, and dialog in Linux. 

untar_matlab () {
  # dialog --backtitle "$script" --title "$program" --infobox "UNTARRING ${MATLAB[0]} PACKAGE TO /usr/local..." 10 40

  tar --extract --gzip --verbose --file=/usr/local/matlab.tgz --directory=/usr/local 2>&1
  # |dialog --backtitle "$script" --title "$program" --gauge "UNTARRING ${MATLAB[0]} PACKAGE TO /usr/local..." 10 40
}




#(pv -n file.tgz | tar xzf - -C target_directory ) \
#2>&1 | dialog --gauge "Extracting file..." 6 50
