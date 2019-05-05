#!/bin/bash 

MATLAB_9_4=(
Matlab9.4
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/MATLAB9.4.app.tgz"
MATLAB9.4.app
_9.4
)

printf "%s\n" ${MATLAB_9_4[0]}
printf "%s\n" ${MATLAB_9_4[1]}
printf "%s\n" ${MATLAB_9_4[2]}
printf "%s\n" ${MATLAB_9_4[3]}

get_matlab () {
  printf "%s\\n" "RETRIEVING $1 INSTALLER..."

  #curl --progress-bar --retry 3 --retry-delay 5 --keepalive-time 60 --continue-at - "$2" --output /Applications/matlab.app.tgz
}

launch_matlab () {
  printf "%s\\n" "LAUNCHING '$1'..."

  # this doesn't work!!! need to fix <--

  printf "%s\n" matlab'$3'
}

get_matlab
launch_matlab
