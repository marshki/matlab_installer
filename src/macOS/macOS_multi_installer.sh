#!/usr/bin/env bash
#
# macOS_multi_installer
# 
# Menu-based installer for pre-packaged versions of MATLAB on macOs. 		        
# For use by NYU's: Center for Brain Imaging, Center for Neural Science,    
# and Department of Psychology.                                                      
# Note: Use on machines with previous version of MATLAB.   
#
# Author: M. Krinitz <mjk235 [at] nyu [dot] edu> 
# Date: 2019.05.25
# License: MIT

############
# Variables
############

LOCAL_WEB="https://localweb.cns.nyu.edu/mac/matlab.tgz"

#########
# Arrays
# Arrays follow this structure: 		
# MATLAB_x.y=(Matlabx.y "URL" MATLABX.Y.app) 
#########

MATLAB_9_0=(
Matlab9.0
"https://localweb.cns.nyu.edu/mac/MATLAB9.0.app.tgz"
MATLAB9.0.app
_9.0
)

MATLAB_9_1=(
Matlab9.1
"https://localweb.cns.nyu.edu/mac/MATLAB9.1.app.tgz"
MATLAB9.1.app
_9.1
)

MATLAB_9_2=(
Matlab9.2
"https://localweb.cns.nyu.edu/mac/MATLAB9.2.app.tgz"
MATLAB9.2.app
_9.2
)

MATLAB_9_3=(
Matlab9.3
"https://localweb.cns.nyu.edu/mac/MATLAB9.3.app.tgz"
MATLAB9.3.app
_9.3
)

MATLAB_9_4=(
Matlab9.4
"https://localweb.cns.nyu.edu/mac/MATLAB9.4.app.tgz"
MATLAB9.4.app
_9.4
)

MATLAB_9_5=(
Matlab9.5
"https://localweb.cns.nyu.edu/mac/MATLAB9.5.app.tgz"
MATLAB9.5.app
_9.5
)

MATLAB_9_6=(
Matlab9.6
"https://localweb.cns.nyu.edu/mac/MATLAB9.6.app.tgz"
MATLAB9.6.app
_9.6
)

MATLAB_9_7=(
Matlab9.7
"https://localweb.cns.nyu.edu/mac/MATLAB9.7.app.tgz"
MATLAB9.7.app
_9.7
)

MATLAB_9_8=(
Matlab9.8
"https://localweb.cns.nyu.edu/mac/MATLAB9.8.app.tgz"
MATLAB9.8.app
_9.7
)

MATLAB_9_9=(
Matlab9.9
"https://localweb.cns.nyu.edu/mac/MATLAB9.9.app.tgz"
MATLAB9.9.app
_9.9
)




###############
# Sanity Checks
###############

# Is current UID 0? If not, exit.

root_check () {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\\n" "ERROR: ROOT PRIVILEGES ARE REQUIRED TO CONTINUE. EXITING." >&2
    exit 1
fi
}

# Is there adequate disk space in "/Applications"? If not, exit.

check_disk_space () {
  if [ "$(df -lk /Applications |awk 'FNR == 2 {print $4}')" -le "31457280" ]; then
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
  status_code=$(curl --output /dev/null --silent --insecure --head --write-out '%{https_code}\n' "$LOCAL_WEB")

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

##############
# Display Menu 
##############

# Display pause prompt.
# Suspend processing of script; display message prompting user to press [Enter] key to continue.
# $1-> Message (optional).

pause() {
    local message="$*"
    [ -z "$message" ] && message="INSTALL DONE. PRESS [Enter] KEY TO CONTINUE:  "
    read -rp "$message" 
}

# Display on-screen menu. 

show_menu() {
    printf "%s\\n" "---------------------------------"
    printf "%s\\n" "   MATLAB INSTALLER MAIN MENU    "
    printf "%s\\n" "---------------------------------"
    printf "%s\\n" "  1.  INSTALL MATLAB 7.5 (R2007b)"
    printf "%s\\n" "  2.  INSTALL MATLAB 8.0 (R2012b)"
    printf "%s\\n" "  3.  INSTALL MATLAB 8.3 (R2014a)"
    printf "%s\\n" "  4.  INSTALL MATLAB 8.5 (R2015a)" 
    printf "%s\\n" "  5.  INSTALL MATLAB 8.6 (R2015b)"
    printf "%s\\n" "  6.  INSTALL MATLAB 9.0 (R2016a)"
    printf "%s\\n" "  7.  INSTALL MATLAB 9.1 (R2016b)"
    printf "%s\\n" "  8.  INSTALL MATLAB 9.2 (R2017a)"
    printf "%s\\n" "  9.  INSTALL MATLAB 9.3 (R2017b)"
    printf "%s\\n" "  10. INSTALL MATLAB 9.4 (R2018a)"
    printf "%s\\n" "  11. INSTALL MATLAB 9.5 (R2018b)"
    printf "%s\\n" "  12. INSTALL MATLAB 9.6 (R2019a)"
    printf "%s\\n" "  13. INSTALL MATLAB 9.7 (R2019b)"
    printf "%s\\n" "  14. EXIT"
}

##################
# Matlab Install-r 
##################

# Download tarball to /Applications. 

get_matlab () {
  printf "%s\\n" "RETRIEVING $1 INSTALLER..."

  curl --insecure --progress-bar --retry 3 --retry-delay 5 --keepalive-time 60 --continue-at - "$2" --output /Applications/matlab.app.tgz
}

# Unpack tarball to /Applications, which installs Matlab. 

untar_matlab () {
  printf "%s\\n" "UNTARRING $1 PACKAGE TO /Applications..."

  tar --extract --gzip -v --file=/Applications/matlab.app.tgz --directory=/Applications
}

# Remove tarball from /Applications.

remove_matlab_tar () {
  printf "%s\\n" "REMOVING $1 TARBALL..."

  rm -rv /Applications/matlab.app.tgz
}

# Does /usr/local/bin exist? If not, add it

local_bin_check () {
  if [ ! -d "/usr/local/bin" ] ; then
    printf "%s\\n" "/usr/local/bin DOES NOT EXIST; LET'S ADD IT..."
    mkdir -pv /usr/local/bin
fi
}

# Create symbolic link for Matlab

symlink_matlab () {
  printf "%s\\n" "CREATING SYMLINK FOR $1..."

  ln -s /Applications/"$3"/bin/matlab /usr/local/bin/matlab"$4"
}

# Launch Matlab from terminal. This is for visual confirmation; you may comment out this function in main. 

launch_matlab () {
  printf "%s\\n" "LAUNCHING $1 ..."

  matlab$4 -nodesktop
}

matlab_installer () {
  get_matlab "$@"
  untar_matlab "$@"
  remove_matlab_tar "$@"
  local_bin_check "$@"
  symlink_matlab "$@"
  launch_matlab "$@"
}

############
# User Input
############

# Get input via the keyboard and make a decision using case...esac 

read_input() {
    local c
    read -rp "ENTER YOUR CHOICE [ 1-14 ]:  " c
    case $c in
        1) matlab_installer "${MATLAB_7_5[@]}" ;;
        2) matlab_installer "${MATLAB_8_0[@]}" ;;
        3) matlab_installer "${MATLAB_8_3[@]}" ;;
        4) matlab_installer "${MATLAB_8_5[@]}" ;;
        5) matlab_installer "${MATLAB_8_6[@]}" ;;
        6) matlab_installer "${MATLAB_9_0[@]}" ;;
        7) matlab_installer "${MATLAB_9_1[@]}" ;;
        8) matlab_installer "${MATLAB_9_2[@]}" ;;
        9) matlab_installer "${MATLAB_9_3[@]}" ;;
        10) matlab_installer "${MATLAB_9_4[@]}" ;;
        11) matlab_installer "${MATLAB_9_5[@]}" ;;
        12) matlab_installer "${MATLAB_9_6[@]}" ;;
        13) matlab_installer "${MATLAB_9_7[@]}" ;;
        14) printf "%s\\n" "CIAO!"; exit 0 ;;
        *)
           printf "%s\\n" "SELECT AN OPTION (1 to 14):  "

           pause "$@"
    esac
}

# Main. 

main () {

sanity_checks

  while true
  do
    clear
    show_menu 
    read_input "$@"
    pause
  done
}

main "$@"
