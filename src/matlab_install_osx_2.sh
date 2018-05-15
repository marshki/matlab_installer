#!/bin/bash
# mjk235 [at] nyu [dot] edu --2017.02.10
# v.0.2 

############################################################################################
#### Auto install latest version of Matlab on OS X. 		                       	####
#### Open to members of NYU's Center for Neural Science and Department of Psychology    #### 
#### Requires: root privileges; access to Meyer network; and adequate free disk space.  ####   
############################################################################################

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
    printf "%s\n" "Error: root privileges are required to continue. Exiting." >&2
    exit 1
fi
}

# Is there adequate disk space in "/Applications"? If not, exit.

check_disk_space () {
  if [ $(df -Hl /Applications |awk 'FNR == 2 {print $4}' |sed 's/G//') -le 30 ]; then
    printf "%s\n" "Error: not enough free disk space. Exiting." >&2
    exit 1
fi
}

# Is curl installed? If not, exit. (Curl ships with OS X, but let's check).

curl_check () {
  if ! [ -x "$(command -v curl 2>/dev/null)" ]; then
    printf "%s\n" "Error: curl is not installed. Exiting."  >&2
    exit 1
fi
}

# Is CNS local web available? If not, exit.

ping_local_web() {
 printf "%s\n" "Pinging CNS local web..."

  if ping -c 1 "$LOCAL_WEB" &> /dev/null; then
    printf "%s\n" "CNS local web IS reachable. Continuing..."
  else
    printf "%s\n" "Error: CNS local web IS NOT reachable. Exiting." >&2
    exit 1
fi
}

sanity_checks() {
  root_check
  check_disk_space
  curl_check
  ping_local_web
}

##########################
#### Matlab Install-r ####
##########################

# Download tarball to /Applications

get_matlab () {
  printf "%s\n" "Retrieving ${MATLAB[0]} insaller..."
  
  curl --progress-bar --retry 3 --retry-delay 5 "${MATLAB[1]}" --output /Applications/matlab.app.tgz
}

# Unpack tarball to /Applications.

untar_matlab () {
  printf "%s\n" "Untarring ${MATLAB[0]} package to /Applications..."
  
  tar --extract --gzip -v --file=/Applications/matlab.app.tgz --directory=/Applications
}

# Remove tarball from /Applications.

remove_matlab_tar () {
  printf "%s\n" "Removing ${MATLAB[0]} tarball..."

  rm -rv /Applications/matlab.app.tgz
}

# Does /usr/local/bin exist? If not, add it

local_bin_check () {
  if [ ! -d "/usr/local/bin" ] ; then
    printf "%s\n" "/usr/local/bin does NOT exist; let's add it..."
    mkdir -pv /usr/local/bin
fi
}

# Create symlink for Matlab

symlink_matlab () {
  printf "%s\n" "Creating symlink for ${MATLAB[0]}..."

  ln -s /Applications/MATLAB9.4.app/bin/matlab /usr/local/bin/matlab
}

###################
#### Launch-r ####
###################

# Launch Matlab from terminal

launch_matlab () {
  printf "%s\n" "Launching ${MATLAB[0]}..."

  matlab -nodesktop
}

# Main 

main () {
  sanity_checks
  get_matlab
  untar_matlab
  remove_matlab_tar
  local_bin_check
  symlink_matlab
  launch_matlab
}

main "$@"
