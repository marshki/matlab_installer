#!/bin/bash
# mjk235 [at] nyu [dot] edu --2017.02.10
# v.0.2

#########################################################################################
#### Auto-install latest version of Matlab on OS X. 		                     ####
#### Open to members of NYU's: Center for Brain Imaging, Center for Neural Science,  ####
#### and Department of Psychology.                                                   ####
#### Requires: root privileges; access to Meyer network; adequate free disk space.   ####
#### Note: Use on machines WITHOUT previous version of MATLAB installed on them.     ####
#########################################################################################

LOCAL_WEB="128.122.112.23"

MATLAB=(
Matlab9.4
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz"
MATLAB9.4.app
)

#######################
#### Sanity Checks ####
#######################

# Is current UID 0? If not, exit.

root_check () {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\\n" "ERROR: ROOT PRIVILEGES ARE REQUIRED TO CONTINUE. EXITING." >&2
    exit 1
fi
}

# Is there adequate disk space in "/Applications"? If not, exit.

check_disk_space () {
  if [ "$(df -lk /Applications |awk 'FNR == 2 {print $4}' |sed 's/G//')" -le "14680064" ]; then
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

ping_local_web() {
  printf "%s\\n" "PINGING CNS LOCAL WEB..."

  if ping -c 1 "$LOCAL_WEB" &> /dev/null; then
    printf "%s\\n" "CNS LOCAL WEB IS REACHABLE. CONTINUING..."
  else
    printf "%s\\n" "ERROR: CNS LOCAL WEB IS NOT REACHABLE. EXITING." >&2
    exit 1
fi
}

sanity_checks() {
  root_check
  check_disk_space
  curl_check
  #ping_local_web --> ping back turned off on local web; need a different test
}

##########################
#### Matlab Install-r ####
##########################

# Download tarball to /Applications. 

get_matlab () {
  printf "%s\\n" "RETRIEVING ${MATLAB[0]} INSTALLER..."

  curl --progress-bar --retry 3 --retry-delay 5 --keepalive-time 60 --continue-at - "${MATLAB[1]}" --output /Applications/matlab.app.tgz
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
  untar_matlab
  remove_matlab_tar
  local_bin_check
  symlink_matlab
}

###################
#### Launch-r ####
###################

# Launch Matlab from terminal. This is for visual confirmation, you may comment this function in main. 

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
