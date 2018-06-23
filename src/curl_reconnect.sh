#!/bin/bash
# Test function 
# Curl resume downloads in the event of a dropped connection

MATLAB=(
Matlab9.4
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz"
MATLAB9.4.app
)

get_matlab () {
  printf "%s\\n" "RETRIEVING ${MATLAB[0]} INSTALLER..."
  
  curl --progress-bar --retry 3 --retry-delay 5 --keepalive-time 60 --continue-at - "${MATLAB[1]}" --output /Applications/matlab.app.tgz

  # curl --progress-bar --retry 3 --retry-delay 5 "${MATLAB[1]}" --output /Applications/matlab.app.tgz
} 

get_matlab
