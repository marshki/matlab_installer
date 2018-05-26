#!/bin/bash
# mjk235 [at] nyu [dot] edu --2017.02.10
# v.0.2 

#########################################################################################
#### Auto install latest version of Matlab on Linux (Debian-based). 		     ####
#### Open to members of NYU's Center for Neural Science and Department of Psychology #### 
#### Requires: root privileges; access to Meyer network; adequate free disk space.   ####   
#### Note: Use on machines WITHOUT previous version of MATLAB installed on them.     ####
#########################################################################################

LOCAL_WEB="128.122.112.23"

MATLAB_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.4.tgz"

MATLAB=(
Matlab9.4
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.4.tgz"
matlab9.4
)

#######################
#### Sanity checks ####
#######################

# Is current UID 0? If not, exit.

root_check () {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\n" "ERROR: ROOT PRIVILEGES ARE REQUIRED TO CONTINUE. EXITING." >&2
    exit 1
fi
}

# Is there adequate disk space in /usr/local directory? If not, exit.

check_disk_space () {
  if [ $(df -l --output=avail /usr/local |awk 'FNR == 2 {print $1}') -le "31457280" ]; then
    printf "%s\n" "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2
    exit 1
fi
}

# Is curl installed? If not, install it.

curl_check () {
  if [ $(dpkg-query --show --showformat='${Status}' curl 2>/dev/null | grep --count "ok installed") -eq "0" ]; then
    printf "%s\n" "CURL IS NOT INSTALLED. LET'S INSTALL IT..."
    apt-get install curl
fi
}

# Is CNS local web available? If not, exit. 

ping_local_web () {
  printf "%s\n" "PINGING CNS LOCAL WEB..."

  if ping -c 1 "$LOCAL_WEB" &> /dev/null; then
    printf "%s\n" "CNS LOCAL WEB IS REACHABLE. CONTINUING..."
  else
    printf "%s\n" "ERROR: CNS LOCAL WEB IS NOT REACHABLE. EXITING." >&2
    exit 1
fi
}

sanity_checks () {
  root_check 
  check_disk_space
  curl_check 
  ping_local_web
} 

##########################
#### Matlab Install-r ####
##########################

# Download tarball to /usr/local. 

get_matlab () {
  printf "%s\n" "RETRIEVING ${MATLAB[0]} INSTALLER..."

  curl --progress-bar --retry 3 --retry-delay 5 "${MATLAB[1]}" --output /usr/local/matlab.tgz
}

# Unpack tarball to /usr/local which installs Matlab 

untar_matlab () {
  printf "%s\n" "UNTARRING ${MATLAB[0]} PACKAGE TO /usr/local..."

  tar --extract --gzip --verbose --file=/usr/local/matlab.tgz --directory=/usr/local
}

# Remove tarball. 

remove_matlab_tar () {
  printf "%s\n" "REMOVING $MATLAB[0]} INSTALLER..."

  rm --recursive --verbose /usr/local/matlab.tgz
}

# Does /usr/local/bin exist? If not, add it. 

local_bin_check () {
  if [ ! -d "/usr/local/bin" ] ; then

    printf "%s\n" "/usr/local/bin DOES NOT exist; LET'S ADD IT..."

    mkdir -pv /usr/local/bin
fi
}

# Create symbolic link for Matlab. 

symlink_matlab () {
  printf "%s\n" "CREATING SYMLINK FOR ${MATLAB[0]}..."

  ln --symbolic /usr/local/${MATLAB[2]}/bin/matlab /usr/local/bin/matlab
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

# Launch Matlab from terminal. 

launch_matlab () {
  printf "%s\n" "LAUNCHING ${MATLAB[0]}..."

  matlab -nodesktop
}

# Main 

main () {
  sanity_checks
  matlab_installer
  launch_matlab
}

main "$@"
