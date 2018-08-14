#!/usr/bin/env bash 
# add current network .lic files to /Applications/MATLAB/licenses dir in OS X

################
# MATLAB ARRAY #
################

MATLAB_VERSION=(
  MATLAB9.4.app
  MATLAB9.3.app
  MATLAB9.2.app
  MATLAB9.1.app
  MATLAB9.0.app
  MATLAB8.6.app
  MATLAB8.5.app
  MATLAB8.3.app 
  MATLAB8.0.app 
  MATLAB7.5.app 
  MATLAB.app 
)

########################
#### Sanity checks  ####
########################

root_check() {
  # is current UID 0? if not, exit

  if [ "$EUID" -ne "0" ] ; then
    printf "%s\\n" "ERROR: ROOT PRIVILEGES ARE REQUIRED TO CONTINUE. EXITING." >&2
    exit 1 
  fi
}

matlab_check() {
  # is there at least 1 occurrence of `/Applications/MATLAB*.*.app/licenses` dir? 
  # if yes, continue; if not, exit  

  for MATLAB in "${MATLAB_VERSION[@]}"; do
      if [ -d "/Applications/${MATLAB}/licenses" ]; then
          printf "%s\\n" "FOUND A VERSION OF MATLAB (${MATLAB}), CONTINUING..."
          return 0
      fi
  done
    
  printf "%s\\n" "DID NOT FIND ANY VERSIONS OF MATLAB. EXITING." 
  return 1
}

#########################
#### Meat & Potatoes ####
#########################

make_nyu_lic() { 
  # create 1NYU_NET.lic in /Applications/MATLAB*.*.app/licenses

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
  # create 1CNS_NET.lic in /Applications/MATLAB*.*.app/licenses 
 
  printf "%s\\n" "ADDING 1CNS_NET.lic to /Applications/MATLAB9.3.app/licenses" 
 
  cat > /Applications/MATLAB9.3.app/licenses/1CNS_NET.lic << EOF 
# CNS license server - 08.01.2018
SERVER matlic1.cns.nyu.edu 27000
USE_SERVER
EOF
} 
 
main() { 
  root_check 
  matlab_check 
  #make_nyu_lic 
  #make_cns_lic 
}

main "$@" 
