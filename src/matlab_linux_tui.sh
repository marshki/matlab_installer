#!/bin/bash
# mjk235 [at] nyu [dot] edu --2017.02.10
# v.0.2 

#########################################################################################
#### Install latest version of Matlab on Linux (Debian-based). 		             ####
#### Open to members of NYU's Center for Neural Science and Department of Psychology #### 
#### Requires: root privileges; access to Meyer network; adequate free disk space.   ####   
#### Note: Use on machines WITHOUT previous version of MATLAB installed on them.     ####
#########################################################################################

# TODO: 
# add dialog and pv package check
# add untar progress meter   
# code review/refactor as needed 

script=`basename "$0"`
program="MATLAB INSTALLER"

PCT=100

LOCAL_WEB="128.122.112.23"

MATLAB_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.4.tgz"

MATLAB=(
Matlab9.4
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.4.tgz"
matlab9.4
)

###########################
#### Pre-flight checks ####
###########################
# Add checks for dialog and pv 

########################
#### Progress meter ####
########################

progress_meter () {
  for ((i=1;i<=PCT;i++)); do
  echo $i; 
  sleep 0.1; 
  done
}

#######################
#### Sanity checks ####
#######################

# Is current UID 0? If not, exit.

root_check () {
  if [ "$EUID" -ne "0" ] ; then
    dialog --backtitle "$script" --title "$program" --msgbox "ERROR: ROOT PRIVILEGES ARE REQUIRED TO CONTINUE. EXITING." >&2 10 40
    exit 1
fi
}

# Is there adequate disk space in /usr/local directory? If not, exit.

# Is 30 GB actually needed? 

check_disk_space () {
  if [ $(df -l --output=avail /usr/local |awk 'FNR == 2 {print $1}') -le "31457280" ]; then 
    dialog --backtitle "$script" --title "$program" --msgbox "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2 10 40
    exit 1
fi
}

# Is wget installed? If not, install it.

wget_check () {
  if [ $(dpkg-query --show --showformat='${Status}' wget 2>/dev/null | grep --count "ok installed") -eq "0" ]; then
    dialog --backtitle "$script" --title "$program" --infobox "WGET IS NOT INSTALLED. LET'S INSTALL IT..." >&2 10 40
    apt-get install wget --yes
fi
}

# Is CNS local web available? If not, exit. 

ping_local_web () {
 
  progress_meter | dialog --backtitle "$script" --title "$program" --gauge "PINGING CNS LOCAL WEB..." 10 40 

  if ping -c 1 "$LOCAL_WEB" &> /dev/null; then
    dialog --backtitle "$script" --title "$program" --msgbox "CNS LOCAL WEB IS REACHABLE. CONTINUING..." 10 40 
  else
    dialog --backtitle "$script" --title "$program" --msgbox "ERROR: CNS LOCAL WEB IS NOT REACHABLE. EXITING." >&2 10 40
    exit 1
fi
}

sanity_checks () {
  root_check 
  check_disk_space
  wget_check 
  ping_local_web
} 

##########################
#### Matlab Install-r ####
##########################

# Download tarball to /usr/local. 
get_matlab () {

  wget --progress=dot --output-document=/usr/local/matlab.tgz --tries=3 --continue $MATLAB_INSTALLER 2>&1 | \
    grep "%" |\
    sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" |
    dialog --gauge "RETRIEVING MATLAB INSTALLER..." 10 40 
}

# Unpack tarball to /usr/local, which installs Matlab. 

untar_matlab () {
  (pv --numeric /usr/local/matlab.tgz | tar --extract --gzip --directory=/usr/local) 2>&1|
  dialog --backtitle "$script" --title "$program" --gauge "UNTARRING ${MATLAB[0]} PACKAGE TO /usr/local..." 10 40
}

# Unpack tarball to /usr/local which installs Matlab 
#
#untar_matlab () {
#  dialog --backtitle "$script" --title "$program" --infobox "UNTARRING ${MATLAB[0]} PACKAGE TO /usr/local..." 10 40
#  tar --extract --gzip --verbose --file=/usr/local/matlab.tgz --directory=/usr/local
#}

# Remove tarball. 

remove_matlab_tar () {
  dialog --backtitle "$script" --title "$program" --infobox "REMOVING $MATLAB[0]} INSTALLER..." 10 40 ; sleep 2 
 
  rm --recursive --verbose /usr/local/matlab.tgz
}

# Does /usr/local/bin exist? If not, add it. 

local_bin_check () {
  if [ ! -d "/usr/local/bin" ] ; then

    dialog --backtitle "$script" --title "$program" --infobox "/usr/local/bin DOES NOT exist; LET'S ADD IT..." 10 40 ; sleep 2 
    
    mkdir -pv /usr/local/bin
fi
}

# Create symbolic link for Matlab. 

symlink_matlab () {
  dialog --backtitle "$script" --title "$program" --infobox "CREATING SYMLINK FOR ${MATLAB[0]}..." 10 40 ; sleep 2 

  ln --symbolic /usr/local/${MATLAB[2]}/bin/matlab /usr/local/bin/matlab
}

# Install complete message.  

install_complete () {
   dialog --backtitle "$script" --title "$program" --msgbox "${MATLAB[0]} installed successfully!" 10 40
}

matlab_installer () {
  get_matlab 
  untar_matlab
  remove_matlab_tar
  local_bin_check
  symlink_matlab
  install_complete
} 

# Main 

main () {
  sanity_checks
  matlab_installer
}

main "$@"
