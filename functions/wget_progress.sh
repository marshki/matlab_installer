#!/usr/bin/env bash

# Download tarball to /usr/local. 
# Progress bar built off of gist from: https://gist.github.com/Gregsen/7822421

MATLAB=(
Matlab9.5
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz"
MATLAB9.5.app
)

get_matlab () {

  wget --progress=dot --output-document=/usr/local/matlab.tgz --tries=3 --continue ${MATLAB[1]} 2>&1 | \
    grep "%" |\
    sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" |
    dialog --backtitle "$script" --title "$program" --gauge "RETRIEVING ${MATLAB[0]} INSTALLER..." 10 40 
}

get_matlab
