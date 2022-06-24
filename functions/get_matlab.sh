#!/usr/bin/env bash
# Retrieve tarball via curl (or wget).
 
# Download tarball to /usr/local.
# Show progress bar -> retry 3 times -> wait 5 seconds between retries. 
# (curl) keep connections alive for 60 secs [wget does this be default].
# output download to /usr/local as "matlab.tgz".

MATLAB=(
Matlab9.11
"www.cns.nyu.edu/mac/matlab9.11.tgz"  
matlab9.11
)

get_matlab () {
  printf "%s\n" "RETRIEVING ${MATLAB[0]} INSTALLER..."

  #wget --progress=bar --tries=3 --wait=5 --continue "${MATLAB[1]}" --output-document=/usr/local/matlab.tgz 
  curl --progress-bar --retry 3 --retry-delay 5 --keepalive-time 60 --continue-at - "${MATLAB[1]}" --output /usr/local/matlab.tgz
}

get_matlab
