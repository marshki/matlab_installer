#!/usr/bin/env bash
#
# linux_installer_tui
#
# Install pre-packaged version of MATLAB on Linux (Debian-based) via TUI.
# For use by NYU's: Center for Brain Imaging, Center for Neural Science,
# and Department of Psychology
# Notes:
#  - Creates symbolic link to launch MATLAB binary.
#  - Script requires dialog. Install it with: sudo apt-get install --yes dialog
#
# Author: M. Krinitz <mjk235 [at] nyu [dot] edu>
# Date: 2020.05.13
# License: MIT

###########
# Variables
###########

script=$(basename "$0")
program="MATLAB INSTALLER"

local_web="http://localweb.cns.nyu.edu/sys/mat-archive-8-2016/unix/matlab9.11.tgz"

source_hash="292870b20f197bbabce562ef2f4c3473"

MATLAB=(
Matlab9.11
"http://localweb.cns.nyu.edu/sys/mat-archive-8-2016/unix/matlab9.11.tgz"
matlab9.11
)

##################
# Pre-flight check
##################

# Is dialog installed? If not, let's add it.

dialog_check () {
  if [ "$(dpkg-query --show --showformat='${Status}' dialog 2>/dev/null | grep --count "ok installed")" -eq "0" ]; then
    printf "%s\n" "DIALOG IS NOT INSTALLED. EXITING."
    exit 1
fi
}

###############
# Sanity checks
###############

# Is current UID 0? If not, exit.

root_check () {
  if [ "$EUID" -ne "0" ] ; then
    dialog --backtitle "$script" --title "$program" --msgbox "ERROR: ROOT PRIVILEGES ARE REQUIRED TO CONTINUE. EXITING." >&2 10 40
    exit 1
fi
}

# Is there adequate disk space in /usr/local directory? If not, exit.

check_disk_space () {
  if [ "$(df --local -k --output=avail /usr/local |awk 'FNR == 2 {print $1}')" -le "14680064" ]; then
    dialog --backtitle "$script" --title "$program" --msgbox "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2 10 40
    exit 1
fi
}

# Is wget installed? It should be, but if not, install it.

wget_check () {
  if [ "$(dpkg-query --show --showformat='${Status}' wget 2>/dev/null | grep --count "ok installed")" -eq "0" ]; then
    dialog --backtitle "$script" --title "$program" --infobox "WGET IS NOT INSTALLED. LET'S INSTALL IT..." >&2 10 40
    apt-get --quiet install wget --yes
fi
}

# Is pv installed? If not, install it.

pv_check () {
  if [ "$(dpkg-query --show --showformat='${Status}' pv 2>/dev/null | grep --count "ok installed")" -eq "0" ]; then
    dialog --backtitle "$script" --title "$program" --infobox "PV IS NOT INSTALLED. LET'S INSTALL IT..." >&2 10 40
    apt-get --quiet install pv --yes
fi
}

# Is CNS local web available? If not, exit.

local_web_check() {
  local status_code
  status_code=$(wget --spider --server-response "$local_web" 2>&1 | awk '/HTTP\/1.1/{print $2}' | head -1)

  if [ "$status_code" -ne "200" ] ; then
    dialog --backtitle "$script" --title "$program" --infobox "ERROR: CNS LOCAL WEB IS NOT REACHABLE." >&2 10 40
    exit 1

  else
    dialog --backtitle "$script" --title "$program" --infobox "CNS LOCAL WEB IS REACHABLE. CONTINUING..." >&2 10 40 ; sleep 2
fi
}

# Wrapper

sanity_checks () {
  root_check
  check_disk_space
  pv_check
  wget_check
  local_web_check
}

##################
# Matlab Install-r
##################

# Download tarball to /usr/local.
# Progress bar built off of gist from: https://gist.github.com/Gregsen/7822421

get_matlab () {

  wget --progress=dot --output-document=/usr/local/matlab.tgz --tries=3 --continue ${MATLAB[1]} 2>&1 | \
    grep "%" |\
    sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g" |
    dialog --backtitle "$script" --title "$program" --gauge "RETRIEVING ${MATLAB[0]} INSTALLER..." 10 40
}

# Calculate md5 hash for downloaded file.

get_destination_hash () {

  dialog --backtitle "$script" --title "$program" --infobox "CALCULATING HASH TO VERIFY DOWNLOAD INTEGRITY..." 10 40 ; sleep 2

  destination_hash="$(md5sum /usr/local/matlab.tgz |awk '{print $1}')"
}

# Compare hashes. Exit if different.

md5_check () {

  if [ "$source_hash" != "$destination_hash" ]; then
    dialog --backtitle "$script" --title "$program" --infobox "ERROR: HASHES DO NOT MATCH. EXITING." >&2 10 40
    exit 1

  else
      dialog --backtitle "$script" --title "$program" --infobox "HASHES MATCH. CONTINUING..." >&2 10 40; sleep 2
fi
}

# Unpack tarball to /usr/local, which installs Matlab.

untar_matlab () {
  (pv --numeric /usr/local/matlab.tgz | tar --extract --gzip --directory=/usr/local) 2>&1|
  dialog --backtitle "$script" --title "$program" --gauge "UNTARRING ${MATLAB[0]} PACKAGE TO /usr/local..." 10 40
}

# Remove tarball.

remove_matlab_tar () {
  dialog --backtitle "$script" --title "$program" --infobox "REMOVING ${MATLAB[0]} INSTALLER..." 10 40 ; sleep 2

  rm --recursive --verbose /usr/local/matlab.tgz
}

# Does /usr/local/bin exist? If not, add it.

local_bin_check () {
  if [ ! -d "/usr/local/bin" ] ; then

    dialog --backtitle "$script" --title "$program" --infobox "/usr/local/bin DOES NOT EXIST; LET'S ADD IT..." 10 40 ; sleep 2

    mkdir -pv /usr/local/bin
fi
}

# Create symbolic link for Matlab.

symlink_matlab () {
  dialog --backtitle "$script" --title "$program" --infobox "CREATING SYMLINK FOR ${MATLAB[0]}..." 10 40 ; sleep 2

  ln --symbolic /usr/local/"${MATLAB[2]}"/bin/matlab /usr/local/bin/matlab
}

# Install complete message.

install_complete () {
   dialog --backtitle "$script" --title "$program" --msgbox "${MATLAB[0]} installed successfully!" 10 40
}

# Wrapper

matlab_installer () {
  get_matlab
  get_destination_hash
  md5_check
  untar_matlab
  remove_matlab_tar
  local_bin_check
  symlink_matlab
  install_complete
}

######
# Main
######

main () {
  dialog_check
  sanity_checks
  matlab_installer
}

main "$@"
