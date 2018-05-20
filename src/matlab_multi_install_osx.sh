#!/bin/bash
# mjk235 [at] nyu [dot] edu --2017.02.10
# v.0.2

############################################################################################
#### Menu-based installer for various versions of MATLAB on OS X. 		        ####
#### Open to members of NYU's Center for Neural Science and Department of Psychology    ####
#### Requires: root privileges; access to Meyer network; adequate free disk space.      ####
############################################################################################

LOCAL_WEB="128.122.112.23"

#### Arrays follow this structure: 		####
#### MATLAB_x.y=(Matlabx.y "URL" MATLABX.Y.app) ####

MATLAB_7.5=(
Matlab7.5
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/MATLAB7.5.app.tgz"
MATLAB7.5.app
)

MATLAB_8.0=(
Matlab8.0
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/MATLAB8.0.app.tgz"
MATLAB8.0.app
)

MATLAB_8.3=(
Matlab8.3
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/MATLAB8.3.app.tgz"
MATLAB8.3.app
)

MATLAB_8.5=(
Matlab8.5
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/MATLAB8.5.app.tgz"
MATLAB8.5.app
)

MATLAB_8.6=(
Matlab8.6
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/MATLAB8.6.app.tgz"
MATLAB8.6.app
)

MATLAB_9.0=(
Matlab9.0
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/MATLAB9.0.app.tgz"
MATLAB9.0.app
)

MATLAB_9.1=(
Matlab9.1
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/MATLAB9.1.app.tgz"
MATLAB9.1.app
)

MATLAB_9.2=(
Matlab9.2
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/MATLAB9.2.app.tgz"
MATLAB9.2.app
)

MATLAB_9.3=(
Matlab9.3
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/MATLAB9.3.app.tgz"
MATLAB9.3.app
)

MATLAB_9.4=(
Matlab9.4
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-13-2014/macos/MATLAB9.4.app.tgz"
MATLAB9.4.app
)

#######################
#### Sanity Checks ####
#######################

# Is current UID 0? If not, exit.

root_check () {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\n" "ERROR: ROOT PRIVILEGES ARE REQUIRED TO CONTINUE. EXITING." >&2
    exit 1
fi
}

# Is there adequate disk space in "/Applications"? If not, exit.

check_disk_space () {
  if [ $(df -Hl /Applications |awk 'FNR == 2 {print $4}' |sed 's/G//') -le 30 ]; then
    printf "%s\n" "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2
    exit 1
fi
}

# Is curl installed? If not, exit. (Curl ships with OS X, but let's check).

curl_check () {
  if ! [ -x "$(command -v curl 2>/dev/null)" ]; then
    printf "%s\n" "ERROR: CURL IS NOT INSTALLED. EXITING."  >&2
    exit 1
fi
}

# Is CNS local web available? If not, exit.

ping_local_web() {
  printf "%s\n" "PINGING CNS LOCAL WEB..."

  if ping -c 1 "$LOCAL_WEB" &> /dev/null; then
    printf "%s\n" "CNS LOCAL WEB IS REACHABLE. CONTINUING..."
  else
    printf "%s\n" "ERROR: CNS LOCAL WEB IS NOT REACHABLE. EXITING." >&2
    exit 1
fi
}

sanity_checks() {
  root_check
  check_disk_space
  curl_check
  ping_local_web
}

######################
#### Display Menu ####
######################

# Display pause prompt.
# Suspend processing of script; display message prompting user to press [Enter] key to continue.
# $1-> Message (optional).

function pause() {
    local message="$@"
    [ -z $message ] && message="INSTALL DONE. PRESS [Enter] KEY TO CONTINUE:  "
    read -p "$message" readEnterKey
}

# Display on-screen menu

function show_menu() {
    printf "%s\n" "------------------------------"
    printf "%s\n" "  MATLAB INSTALLER MAIN MENU  "
    printf "%s\n" "------------------------------"
        printf "%s\n" "  1.  INSTALL MATLAB 7.5"
        printf "%s\n" "  2.  INSTALL MATLAB 8.0"
        printf "%s\n" "  3.  INSTALL MATLAB 8.3"
        printf "%s\n" "  4.  INSTALL MATLAB 8.5" 
	printf "%s\n" "  5.  INSTALL MATLAB 8.6"
	printf "%s\n" "  6.  INSTALL MATLAB 9.0"
	printf "%s\n" "  7.  INSTALL MATLAB 9.1"
	printf "%s\n" "  8.  INSTALL MATLAB 9.2"
	printf "%s\n" "  9.  INSTALL MATLAB 9.3"
	printf "%s\n" "  10. INSTALL MATLAB 9.4"
	printf "%s\n" "  11. EXIT"
}

##########################
#### Matlab Install-r ####
##########################

# Download tarball to /Applications

get_matlab () {
  printf "%s\n" "RETRIEVING $1 INSTALLER..."

  curl --progress-bar --retry 3 --retry-delay 5 $2 --output /Applications/matlab.app.tgz
}

# Unpack tarball to /Applications, which installs Matlab

untar_matlab () {
  printf "%s\n" "UNTARRING $1 PACKAGE TO /Applications..."

  tar --extract --gzip -v --file=/Applications/matlab.app.tgz --directory=/Applications
}

# Remove tarball from /Applications.

remove_matlab_tar () {
  printf "%s\n" "REMOVING $1 TARBALL..."

  rm -rv /Applications/matlab.app.tgz
}

# Does /usr/local/bin exist? If not, add it

local_bin_check () {
  if [ ! -d "/usr/local/bin" ] ; then
    printf "%s\n" "/usr/local/bin DOES NOT EXIST; LET'S ADD IT..."
    mkdir -pv /usr/local/bin
fi
}

# Create symbolic link for Matlab

symlink_matlab () {
  printf "%s\n" "CREATING SYMLINK FOR ${MATLAB[0]}..."

  ln -s /Applications/$4/bin/matlab /usr/local/bin/matlab
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

# Launch Matlab from terminal

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
