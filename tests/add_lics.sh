#!/usr/bin/env bash 
# add current network .lic files to /Applications/MATLAB/licenses dir in OS X

MATLAB_APP=(
MATLAB.app 
MATLAB7.5.app 
MATLAB8.0.app 
MATLAB8.3.app 
MATLAB8.5.app
MATLAB8.6.app
MATLAB9.0.app
MATLAB9.1.app
MATLAB9.2.app
MATLAB9.3.app
MATLAB9.4.app
)

########################
#### Sanity checks  ####
########################

root_check() {

# Is current UID 0? If not, exit.

  if [ "$EUID" -ne "0" ] ; then
    printf "%s\\n" "ERROR: ROOT PRIVILEGES ARE REQUIRED TO CONTINUE. EXITING." >&2
    exit 1
fi
}

ping_local_web() {

# Is CNS local web available? If not, exit.

  printf "%s\\n" "PINGING CNS LOCAL WEB..."

  if ping -c 1 "$LOCAL_WEB" &> /dev/null; then
    printf "%s\\n" "CNS LOCAL WEB IS REACHABLE. CONTINUING..."
  else
    printf "%s\\n" "ERROR: CNS LOCAL WEB IS NOT REACHABLE. EXITING." >&2
    exit 1
 fi
}

#########################
#### Meat & Potatoes ####
#########################

matlab_check() { 
  # Is MATLAB.app installed in /Applications?  

  if [ -d "/Applications/MATLAB.app" ]; then 
    printf "%s\\n" "MATLAB EXIST"       
  else 
    printf "%s\\n" "MATLAB DOES NOT EXIST" 
    exit 1 
fi 
}
 
main() { 
  root_check 
  matlab_check 
}

main "$@" 
