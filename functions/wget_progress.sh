#!/usr/bin/env bash
# Progress bar for downloading tarball to: /usr/local via `dialog`. 
# - built off of gist from: https://gist.github.com/Gregsen/7822421.

MATLAB=(
Matlab9.11
"https://localweb.cns.nyu.edu:443/sys/mat-archive-8-2016/macos/MATLAB9.11.app.tgz"
MATLAB9.11.app
)

get_matlab() {

  wget --progress=dot --output-document=/usr/local/matlab.tgz --tries=3 --continue ${MATLAB[1]} 2>&1 | \
    grep "%" | sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" |
    dialog --backtitle "$script" --title "$program" --gauge "RETRIEVING ${MATLAB[0]} INSTALLER..." 10 40
}

get_matlab
