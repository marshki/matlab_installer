#!/bin/bash
# mjk235 [at] nyu [dot] edu --2020.05.13

#===============================================================================
# Auto-install latest version of Matlab on OS X. 		                    
# Open to members of NYU's: Center for Brain Imaging, Center for Neural Science,  
# and Department of Psychology.                                                   
# Requires: root privileges; access to Meyer network; adequate free disk space.   
# Note: Use on machines WITHOUT previous version of MATLAB installed on them.     
#===============================================================================

LOCAL_WEB="https://localweb.cns.nyu.edu/mac/matlab.tgz"

SOURCE_HASH="1cacd3d4cf99fc628f25ffdfe0ad736b"

MATLAB=(
Matlab9.7
"https://localweb.cns.nyu.edu/mac/MATLAB9.7.app.tgz"
MATLAB9.7.app
)

#==============
# Sanity Checks 
#==============

# Is current UID 0? If not, exit.

root_check () {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\\n" "ERROR: ROOT PRIVILEGES ARE REQUIRED TO CONTINUE. EXITING." >&2
    exit 1
fi
}

# Is there adequate disk space in "/Applications"? If not, exit.

check_disk_space () {
  if [ "$(df -lk /Applications |awk 'FNR == 2 {print $4}' |sed 's/G//')" -le "31457280" ]; then
    printf "%s\\n" "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2
    exit 1
fi
}

# Is curl installed? If not, exit. (Curl ships with OS X, but let's check).

curl_check () {
  if ! [ -x "$(command -v curl 2>/dev/null)" ]; then
    printf "%s\\n" "ERROR: CURL IS NOT INSTALLED. EXITING."  >&2
    exit 1
fi
}

# Is CNS local web available? If not, exit.

local_web_check(){
  local status_code
  status_code=$(curl --output /dev/null --silent --insecure --head --write-out '%{http_code}\n' "$LOCAL_WEB")

  if [ "$status_code" -ne "200" ] ; then
    printf "%s\\n" "ERROR: CNS LOCAL WEB IS NOT REACHABLE. EXITING." >&2
    exit 1 

  else
    printf "%s\\n" "CNS LOCAL WEB IS REACHABLE. CONTINUING..."
fi
}

sanity_checks() {
  root_check
  check_disk_space
  curl_check
  local_web_check  
}

#=================
# Matlab Install-r 
#=================

# Download tarball to /Applications. 

get_matlab () {
  printf "%s\\n" "RETRIEVING ${MATLAB[0]} INSTALLER..."

  curl --insecure --progress-bar --retry 3 --retry-delay 5 --keepalive-time 60 --continue-at - "${MATLAB[1]}" --output /Applications/matlab.app.tgz
}

# Calculate md5 hash for downloaded file. 

get_destination_hash () {

  printf "%s\\n" "CALCULATING HASH..."

  DESTINATION_HASH="$(md5 -r /Applications/matlab.app.tgz |awk '{print $1}')"
}

# Compare hashes. Exit if different.

md5_check () {
  printf "%s\\n" "COMPARING HASHES..."
  printf "%s\\n" "$SOURCE_HASH"
  printf "%s\\n" "$DESTINATION_HASH"

  if [ "$SOURCE_HASH" != "$DESTINATION_HASH" ]
    then
      printf "%s\\n" "ERROR: HASHES DO NOT MATCH. EXITING."
      exit 1

  else
      printf "%s\\n" "HASHES MATCH. CONTINUING..."
fi
}

# Unpack tarball to /Applications, which installs Matlab. 

untar_matlab () {
  printf "%s\\n" "UNTARRING ${MATLAB[0]} PACKAGE TO /Applications..."

  tar --extract --gzip -v --file=/Applications/matlab.app.tgz --directory=/Applications
}

# Remove tarball from /Applications.

remove_matlab_tar () {
  printf "%s\\n" "REMOVING ${MATLAB[0]} TARBALL..."

  rm -rv /Applications/matlab.app.tgz
}

# Does /usr/local/bin exist? If not, add it. 

local_bin_check () {
  if [ ! -d "/usr/local/bin" ] ; then
    printf "%s\\n" "/usr/local/bin DOES NOT EXIST; LET'S ADD IT..."
    mkdir -pv /usr/local/bin
fi
}

# Create symbolic link for Matlab. 

symlink_matlab () {
  printf "%s\\n" "CREATING SYMLINK FOR ${MATLAB[0]}..."

  ln -s /Applications/"${MATLAB[2]}"/bin/matlab /usr/local/bin/matlab
}

matlab_installer () {
  get_matlab
  get_destination_hash
  md5_check
  untar_matlab
  remove_matlab_tar
  local_bin_check
  symlink_matlab
}

#=========
# Launch-r
#=========

# Launch Matlab from terminal. Provides visual confirmation; you may comment this function in main. 

launch_matlab () {
  printf "%s\\n" "LAUNCHING ${MATLAB[0]}..."

  matlab -nodesktop
}

# Main

main () {
  sanity_checks
  matlab_installer
  launch_matlab
}

main "$@"
