#!/usr/bin/env bash
#
# lic_fix
#
# add current network .lic files to:
# - `/Applications/MATLAB*.*.app`
# AND/OR:
# - `MATLAB_R20**.app/licenses` dir in macOS
#
# Author: M. Krinitz <mjk235 [at] nyu [dot] edu>
# Date: 2020.04.20

##############
# MATLAB ARRAY
##############

MATLAB_VERSION=( MATLAB{9.{15..0},8.{6,5,3,0},7.5}.app MATLAB_R20{1,2}{0..9}{a,b}.app )

###############
# Sanity checks
###############

root_check() {
  # is current UID 0? if not, exit

  if [ "$EUID" -ne "0" ] ; then

    printf "%s\n" "ERROR: ROOT PRIVILEGES ARE REQUIRED TO CONTINUE. EXITING." >&2
    exit 1
  fi
}

matlab_check() {
  # is there at least 1 occurrence of:
  #   `/Applications/MATLAB*.*.app` AND/OR `MATLAB_R20**.app/licenses` dir?
  # if yes, continue; if not, exit

  for MATLAB in "${MATLAB_VERSION[@]}"; do

      if [ -d "/Applications/${MATLAB}/licenses" ]; then
          printf "%s\n" "FOUND A VERSION OF MATLAB (${MATLAB}), CONTINUING..."
          return 0
      fi
  done
    
  printf "%s\n" "DID NOT FIND ANY VERSIONS OF MATLAB. EXITING."
  return 1
}

#################
# Meat & Potatoes
#################

make_cns_lic() {
  # create 1CNS_NET.lic in `/Applications/MATLAB*.*.app` AND/OR `MATLAB_R20**.app/licenses`
 
  printf "%s\n" "ADDING 1CNS_NET.lic TO /Applications/${MATLAB}/licenses"
 
  cat > /Applications/"${MATLAB}"/licenses/1CNS_NET.lic << EOF
# CNS license server - 08.01.2018
SERVER matlic1.cns.nyu.edu 27000
USE_SERVER
EOF
}

make_nyu_lic() {
  # create 1NYU_NET.lic in `/Applications/MATLAB*.*.app` AND/OR `MATLAB_R20**.app/licenses`

  printf "%s\n" "ADDING 1NYU_NET.lic TO /Applications/${MATLAB}/licenses"
 
  cat > /Applications/"${MATLAB}"/licenses/1NYU_NET.lic << EOF
# NYU ITS matlab license servers - 09.09.2020
SERVER lm2.its.nyu.edu 27000
SERVER lm3.its.nyu.edu 27000
SERVER lm4.its.nyu.edu 27000
USE_SERVER
EOF
}

add_licks () {
  # iterate through array and do the following:
  # if match --> add .lic files
  # if no match --> continue

  for MATLAB in "${MATLAB_VERSION[@]}"; do
    if [ -d "/Applications/${MATLAB}/licenses" ]; then
      make_cns_lic
      make_nyu_lic
    else
      continue
    fi
  
  done
}

main() {
  root_check
  matlab_check
  add_licks
}

main "$@"
