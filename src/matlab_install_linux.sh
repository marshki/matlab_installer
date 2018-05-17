#!/bin/bash
# mjk235 [at] nyu [dot] edu --2017.02.10
# v.0.2 

#########################################################################################
#### Auto install Matlab on Linux (Debian-based). 		                     ####
#### Open to members of NYU's Center for Neural Science and Department of Psychology #### 
#### Requires: root privileges; access to Meyer network; adequate free disk space.   ####   
##########################################################################################

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
  if [ $(df -Hl --output=avail /usr/local |awk 'FNR == 2 {print $1}' |sed 's/G//') -le "30" ]; then
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
  printf "%s\n" "RETRIEVING MATLAB INSTALLER..."

  curl --progress-bar --retry 3 --retry-delay 5 "$MATLAB_INSTALLER" --output /usr/local/matlab.tgz
}

# Unpack tarball to /usr/local which installs Matlab 

untar_matlab () {
  printf "%s\n" "UNTARRING PACKAGE TO /usr/local..."

  tar --extract --gzip --verbose --file=/usr/local/matlab.tgz --directory=/usr/local
}

# Remove tarball. 

remove_matlab_tar () {
  printf "%s\n" "REMOVING MATLAB INSTALLER..."

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
  printf "%s\n" "CREATING SYMLINK.."

  ln --symbolic /usr/local/matlab9.4/bin/matlab /usr/local/bin/matlab
}

###################
#### Launch-r ####
###################

# Launch Matlab from terminal. 

launch_matlab () {
  printf "%s\n" "LAUNCHING MATLAB..."

  matlab -nodesktop
}

# Main 

main () {
	root_check
	check_disk_space
	curl_check
  	ping_local_web
	get_matlab
	untar_matlab
	remove_matlab_tar
  	local_bin_check
	symlink_matlab
	launch_matlab
}

main "$@"
