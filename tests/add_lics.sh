#!/usr/bin/env bash 
# add current network .lic files to /Applications/MATLAB/licenses dir in OS X

# associative array --> will iterate through  <--

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

matlab_check() { 
  # is MATLAB installed in /Applications?  

  if [ -d "/Applications/MATLAB9.3.app" ]; then 
    printf "%s\\n" "MATLAB EXISTS, CONTINUING..."       
  else 
    printf "%s\\n" "MATLAB9.3.app DOES NOT EXIST in /Applications. EXITING." 
    exit 1 
fi 
}

#########################
#### Meat & Potatoes ####
#########################

make_nyu_lic() { 
  # create 1NYU_NET.lic in /Applications/MATLAB/licenses

  printf "%s\\n" "ADDING 1NYU_NET.lic TO /Applications/MATLAB9.3.app/licenses" 
 
  cat > /Applications/MATLAB9.3.app/licenses/1NYU_NET.lic << EOF
  # NYU ITS matlab license servers - 08.01.2018
  SERVER its428-wap-v.cfs.its.nyu.edu 27000
  SERVER its429-wap-v.cfs.its.nyu.edu 27000
  SERVER its430-wap-v.cfs.its.nyu.edu 27000 
  USE_SERVER
EOF
} 

make_cns_lic() { 
  # create 1CNS_NET.lic in /Applications/MATLAB9.3.app/licenses 
 
  printf "%s\\n" "ADDING 1CNS_NET.lic to /Applications/MATLAB9.3.app/licenses" 
 
  cat > /Applications/MATLAB9.3.app/licneses/1CNS_NET.lic << EOF 
  # CNS license server - 08.01.2018
  SERVER matlic1.cns.nyu.edu 27000
  USE_SERVER
EOF 
} 
 
main() { 
  root_check 
  matlab_check 
  make_nyu_lic 
  make_cns_lic 
}

main "$@" 
