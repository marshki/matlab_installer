#!/bin/bash 

MATLAB_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.4.tgz"

# Download tarball to /Applications. 

get_matlab () {
  printf "%s\n" "RETRIEVING MATLAB INSTALLER..."

  wget "$MATLAB_INSTALLER" 2>&1 | \
  stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | \
  dialog --gauge "Da Matlab doe..." 10 100

  #curl --progress-bar --retry 3 --retry-delay 5 "$MATLAB_INSTALLER" --output /Applications/matlab.app.tgz
}

get_matlab
