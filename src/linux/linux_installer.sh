#!/usr/bin/env bash
#
# linux_installer
#
# Install pre-packaged version of MATLAB on GNU/Linux (Debian-based).
# For use by NYU's: Center for Brain Imaging, Center for Neural Science,
# and Department of Psychology
# Requires: root privileges; access to Meyer network; adequate free disk space.
# Creates symbolic link to launch MATLAB binary.
#
# Author: M. Krinitz <mjk235 [at] nyu [dot] edu>
# Date: 2020.05.13
# License: MIT

###########
# Variables
###########

LOCAL_WEB="http://www.cns.nyu.edu/linux/current-matlab.tgz"

source_hash="bfb9e0037907fb6cf81038a1d07ceb9b"

MATLAB=(
Matlab9.9
http://www.cns.nyu.edu/linux/current-matlab.tgz
matlab9.9
)

###############
# Sanity checks
###############

# Is current UID 0? If not, exit.

root_check () {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\n" "ERROR: ROOT PRIVILEGES ARE REQUIRED TO CONTINUE. EXITING." >&2
    exit 1
fi
}

# Is there adequate disk space in /usr/local directory? If not, exit.

check_disk_space () {
  if [ "$(df --local -k --output=avail /usr/local |awk 'FNR == 2 {print $1}')" -le "14680064" ]; then
    printf "%s\n" "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2
    exit 1
fi
}

# Is wget installed? If not, install it.

wget_check () {
  if [ "$(dpkg-query --show --showformat='${Status}' wget 2>/dev/null | grep --count "ok installed")" -eq "0" ]; then
    printf "%s\n" "WGET IS NOT INSTALLED. LET'S INSTALL IT..."
    apt-get install wget
fi
}

# Is CNS local web available? If not, exit.

local_web_check() {
  local status_code
  status_code=$(wget --spider --server-response "$LOCAL_WEB" 2>&1 | awk '/HTTP\/1.1/{print $2}' | head -1)

  if [ "$status_code" -ne "200" ] ; then
    printf "%s\n" "ERROR: CNS LOCAL WEB IS NOT REACHABLE. EXITING." >&2
    exit 1

  else
    printf "%s\n" "CNS LOCAL WEB IS REACHABLE. CONTINUING..."
fi
}

# Wrapper

sanity_checks () {
  root_check
  check_disk_space
  wget_check
  local_web_check
}

##################
# Matlab Install-r
##################

# Download tarball to /usr/local.

get_matlab () {
  printf "%s\n" "RETRIEVING ${MATLAB[0]} INSTALLER..."

  wget --progress=bar --tries=3 --wait=5 --continue "${MATLAB[1]}" --output-document=/usr/local/matlab.tgz
}

# Calculate md5 hash for downloaded file.

get_destination_hash () {
  printf "%s\n" "CALCULATING HASH..."

  destination_hash="$(md5sum /usr/local/matlab.tgz |awk '{print $1}')"
}

# Compare hashes. Exit if different.

md5_check () {
  printf "%s\n" "COMPARING HASHES..."
  printf "%s\n" "$source_hash"
  printf "%s\n" "$destination_hash"

  if [ "$source_hash" != "$destination_hash" ]; then
    printf "%s\n" "ERROR: HASHES DO NOT MATCH. EXITING."
    exit 1

    else
      printf "%s\n" "HASHES MATCH. CONTINUING..."
fi
}

# Unpack tarball to /usr/local, which installs Matlab.

untar_matlab () {
  printf "%s\n" "UNTARRING ${MATLAB[0]} PACKAGE TO /usr/local..."

  tar --extract --gzip --verbose --file=/usr/local/matlab.tgz --directory=/usr/local
}

# Remove tarball.

remove_matlab_tar () {
  printf "%s\n" "REMOVING ${MATLAB[0]} INSTALLER..."

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

  ln --symbolic /usr/local/"${MATLAB[2]}"/bin/matlab /usr/local/bin/matlab
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
}

##########
# Launch-r
##########

# Launch Matlab from terminal. This is for visual confirmation; you may comment this function in main.

launch_matlab () {
  printf "%s\n" "LAUNCHING ${MATLAB[0]}..."

  matlab -nodesktop
}

######
# Main
######

main () {
  sanity_checks
  matlab_installer
  launch_matlab
}

main "$@"
