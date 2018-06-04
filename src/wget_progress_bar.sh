#!/bin/bash 

MATLAB_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.4.tgz"

# Download tarball to /Applications. 

get_matlab () {
  printf "%s\n" "RETRIEVING MATLAB INSTALLER..."

  wget --progress=dot --output-document=/usr/local/matlab.tgz --tries=3 --continue $MATLAB_INSTALLER 2>&1 | \
    grep "%" |\
    sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" |
    dialog --gauge "Dat Matlab doe..." 10 100
}

get_matlab

#stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | \
