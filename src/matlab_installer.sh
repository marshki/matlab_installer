#!/bin/bash
# mjk235 [at] nyu [dot] edu --2017.02.10
# v.0.2

#########################################################################################
#### Auto install latest version of Matlab on Linux (Debian-based).                  ####
#### Open to members of NYU's Center for Neural Science and Department of Psychology ####
#### Requires: root privileges; access to Meyer network; adequate free disk space.   ####
#### Note: Use on machines WITHOUT previous version of MATLAB installed on them.     ####
#########################################################################################

# dialog_box="dialog --backtitle "$script" --title "$program" --msgbox"
# dialog_dimension"10 40" 

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

check_disk_space () {
  if [ $(df -l --output=avail /usr/local |awk 'FNR == 2 {print $1}') -le "3" ]; then #"31457280"
    dialog --backtitle "$script" --title "$program" --msgbox "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2 10 40
    exit 1
fi
} 

# Is curl installed? If not, install it.

curl_check () {
  if [ $(dpkg-query --show --showformat='${Status}' curl 2>/dev/null | grep --count "ok installed") -eq "0" ]; then
    dialog --backtitle "$script" --title "$program" --infobox "CURL IS NOT INSTALLED. LET'S INSTALL IT..." >&2 10 40
    apt-get install curl --yes
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
  curl_check
  ping_local_web
}

##########################
#### Matlab Install-r ####
##########################

# Download tarball to /usr/local.

get_matlab () {
  dialog --backtitle "$script" --title "$program" --infobox "RETRIEVING ${MATLAB[0]} INSTALLER..." 10 40

  curl --progress-bar --retry 3 --retry-delay 5 "${MATLAB[1]}" --output /usr/local/matlab.tgz
}

# Unpack tarball to /usr/local which installs Matlab

untar_matlab () {
  dialog --backtitle "$script" --title "$program" --infobox "UNTARRING ${MATLAB[0]} PACKAGE TO /usr/local..." 10 40

  tar --extract --gzip --verbose --file=/usr/local/matlab.tgz --directory=/usr/local
}

# Remove tarball.

remove_matlab_tar () {
  dialog --backtitle "$script" --title "$program" --infobox "REMOVING $MATLAB[0]} INSTALLER..." 10 40

  rm --recursive --verbose /usr/local/matlab.tgz
}

# Does /usr/local/bin exist? If not, add it.

local_bin_check () {
  if [ ! -d "/usr/local/bin" ] ; then

    dialog --backtitle "$script" --title "$program" --infobox "/usr/local/bin DOES NOT exist; LET'S ADD IT..." 10 40

    mkdir -pv /usr/local/bin
fi
}

# Create symbolic link for Matlab.

symlink_matlab () {
  dialog --backtitle "$script" --title "$program" --infobox "CREATING SYMLINK FOR ${MATLAB[0]}..." 10 40

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
  #launch_matlab
}

main "$@"
