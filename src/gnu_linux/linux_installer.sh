#!/usr/bin/env bash
#
# linux_installer
#
# Install pre-packaged version of MATLAB on GNU/Linux (Debian-based).
# For use by NYU's: Center for Brain Imaging, Center for Neural Science,
# and Department of Psychology.
#
# NOTES: 
# - Requires: root privilege; access to Meyer NET; adequate free disk space.
# - Creates symbolic link to launch MATLAB binary.
#
# Author: M. Krinitz <mjk235 [at] nyu [dot] edu>
# Date: 2023.08.13
# License: MIT

###########
# Variables
###########

local_web="https://localweb.cns.nyu.edu:443/sys/mat-archive-8-2016/unix/matlab9.11.tgz"

source_hash="c6fb756db7b5ca397f3aefe3df331261"

MATLAB=(
Matlab9.11
https://localweb.cns.nyu.edu:443/sys/mat-archive-8-2016/unix/matlab9.11.tgz
matlab9.11
)

###############
# Sanity checks
###############

# Is current UID 0? If not, exit.

root_check() {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\n" "Error: Root privileges are requried to continue. Exiting." >&2
    exit 1
  fi
}

# Is there adequate disk space in /usr/local directory? If not, exit.

check_disk_space() {
  local required_space=14680064
  local available_space=$(df --local -k --output=avail /usr/local \
    |awk 'FNR == 2 {print $1}')

  if [ "$available_space" -lt "$required_space" ]; then
    printf "%s\n" "Error: Not enough free disk space. Exiting." >&2
    exit 1
fi
}

# Is wget installed? If not, install it.

wget_check() {
  if [ "$(dpkg-query --show --showformat='${Status}' \
  wget 2>/dev/null grep --count "ok installed")" -eq "0" ]; then
    printf "%s\n" "WGET is NOT installed. Let's install it..."
    apt-get install -y wget
fi
}

# Is CNS local web available (capture connection status)? If not, exit.

lcoal_web_check() {
  local connection_status=$(wget --spider --server-response "$local_web" 2>&1 \
    | awk '/:443.../ {print $5}')

  if [ "$connection_status" = "connected." ]; then
    printf "%s\n" "Server IS reachable."
  else
    printf "%s\n" "Error: Server is NOT reachable."
    exit 1
  fi
}

# Wrapper

sanity_checks() {
  root_check
  check_disk_space
  wget_check
  local_web_check
}

##################
# Matlab Install-r
##################

# Download tarball to /usr/local.

get_matlab() {
  printf "%s\n" "Retrieving ${MATLAB[0]} installer..."

  wget --progress=bar --tries=3 --wait=5 \
    --continue "${MATLAB[1]}" --output-document=/usr/local/matlab.tgz
}

# Calculate md5 hash for downloaded file.

get_destination_hash() {
  printf "%s\n" "Calculating hash..."

  destination_hash="$(md5sum /usr/local/matlab.tgz |awk '{print $1}')"
}

# Compare hashes. Exit if different.

md5_check() {
  printf "%s\n" "Comparing hashes..."
  printf "%s\n" "$source_hash"
  printf "%s\n" "$destination_hash"

  if [ "$source_hash" != "$destination_hash" ]; then
    printf "%s\n" "Error: Hashes do not match. Exiting."
    exit 1

    else
      printf "%s\n" "Hashes match. Continuing..."
fi
}

# Unpack tarball to /usr/local, which installs Matlab.

untar_matlab() {
  printf "%s\n" "Untarring ${MATLAB[0]} package TO /usr/local..."

  tar --extract --gzip --verbose --file=/usr/local/matlab.tgz --directory=/usr/local
}

# Remove tarball.

remove_matlab_tar() {
  printf "%s\n" "Removing ${MATLAB[0]} installer..."

  rm --recursive --verbose /usr/local/matlab.tgz
}

# Does /usr/local/bin exist? If not, add it.

local_bin_check() {
  if [ ! -d "/usr/local/bin" ] ; then
    printf "%s\n" "/usr/local/bin Does NOT exist; Let's add it..."

    mkdir -pv /usr/local/bin
fi
}

# Create symbolic link for Matlab.

symlink_matlab() {
  printf "%s\n" "Creating symlink for ${MATLAB[0]}..."

  ln --symbolic /usr/local/"${MATLAB[2]}"/bin/matlab /usr/local/bin/matlab
}

# Wrapper

matlab_installer() {
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

launch_matlab() {
  printf "%s\n" "Launching ${MATLAB[0]}..."

  matlab -nodesktop
}

######
# Main
######

main() {
  sanity_checks
  matlab_installer
  launch_matlab
}

main "$@"
