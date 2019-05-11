#!/bin/bash 
# Download tarball to /usr/local. 

MATLAB=(
Matlab9.5
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.5.tgz"
matlab9.5
)

get_matlab () {
  printf "%s\\n" "RETRIEVING ${MATLAB[0]} INSTALLER..."

  #wget --progress=bar --tries=3 --wait=5 --continue "${MATLAB[1]}" --output-document=/usr/local/matlab.tgz 
  curl --progress-bar --retry 3 --retry-delay 5 --keepalive-time 60 --continue-at - "${MATLAB[1]}" --output /usr/local/matlab.tgz
}

get_matlab
