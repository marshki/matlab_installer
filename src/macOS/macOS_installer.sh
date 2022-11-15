#!/usr/bin/env bash
#
# macOS_installer
#
# Install pre-packaged version of MATLAB on macOS.
# For use by NYU's: Center for Brain Imaging, Center for Neural Science,
# and Department of Psychology.
# Note: Creates a symbolic link to MATLAB binary.
#
# Author: M. Krinitz <mjk235 [at] nyu [dot] edu>
# Date: 2020.05.13
# License: MIT

############
# Variables
############

local_web="http://localweb.cns.nyu.edu/sys/mat-archive-8-2016/macos/MATLAB9.11.app.tgz"
source_hash="b1637929b1249a17d04802ea61ae311b"

MATLAB=(
Matlab9.11
"http://localweb.cns.nyu.edu/sys/mat-archive-8-2016/macos/MATLAB9.11.app.tgz"
MATLAB9.11.app
)

###############
# Sanity Checks
###############

# Is current UID 0? If not, exit.

root_check () {

  if [ "$EUID" -ne "0" ] ; then
    printf "%s\n" "ERROR: ROOT PRIVILEGES ARE REQUIRED TO CONTINUE. EXITING." >&2
    exit 1
fi
}

# Is there adequate disk space in "/Applications"? If not, exit.

check_disk_space () {

  if [ "$(df -lk /Applications |awk 'FNR == 2 {print $4}' |sed 's/G//')" -le "31457280" ]; then
    printf "%s\n" "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2
    exit 1
fi
}

# Is curl installed? If not, exit. (Curl ships with macOS, but let's check).

curl_check () {

  if ! [ -x "$(command -v curl 2>/dev/null)" ]; then
    printf "%s\n" "ERROR: CURL IS NOT INSTALLED. EXITING."  >&2
    exit 1
fi
}

# Is CNS local web available? If not, exit.

local_web_check(){
  local status_code
  status_code=$(curl --output /dev/null --silent --insecure --head --write-out '%{http_code}\n' "$local_web")

  if [ "$status_code" -ne "200" ] ; then
    printf "%s\n" "ERROR: CNS LOCAL WEB IS NOT REACHABLE. EXITING." >&2
    exit 1

  else
    printf "%s\n" "CNS LOCAL WEB IS REACHABLE. CONTINUING..."
fi
}

sanity_checks() {
  root_check
  check_disk_space
  curl_check
  local_web_check
}

##################
# Matlab Install-r
##################

# Download tarball to /Applications.

get_matlab () {
  printf "%s\n" "RETRIEVING ${MATLAB[0]} INSTALLER..."

  curl --insecure --progress-bar --retry 3 --retry-delay 5 --keepalive-time 60 --continue-at - "${MATLAB[1]}" --output /Applications/matlab.app.tgz
}

# Calculate md5 hash for downloaded file.

get_destination_hash () {

  printf "%s\n" "CALCULATING HASH..."

  destination_hash="$(md5 -r /Applications/matlab.app.tgz |awk '{print $1}')"
}

# Compare hashes. Exit if different.

md5_check () {
  printf "%s\n" "COMPARING HASHES..."
  printf "%s\n" "$source_hash"
  printf "%s\n" "$destination_hash"

  if [ "$source_hash" != "$destination_hash" ]
    then
      printf "%s\n" "ERROR: HASHES DO NOT MATCH. EXITING."
      exit 1

  else
      printf "%s\n" "HASHES MATCH. CONTINUING..."
fi
}

# Unpack tarball to /Applications, which installs Matlab.

untar_matlab () {
  printf "%s\n" "UNTARRING ${MATLAB[0]} PACKAGE TO /Applications..."

  tar --extract --gzip -v --file=/Applications/matlab.app.tgz --directory=/Applications
}

# Remove tarball from /Applications.

remove_matlab_tar () {
  printf "%s\n" "REMOVING ${MATLAB[0]} TARBALL..."

  rm -rv /Applications/matlab.app.tgz
}

# Does /usr/local/bin exist? If not, add it.

local_bin_check () {
  if [ ! -d "/usr/local/bin" ] ; then
    printf "%s\n" "/usr/local/bin DOES NOT EXIST; LET'S ADD IT..."
    mkdir -pv /usr/local/bin
fi
}

# Create symbolic link for Matlab.

symlink_matlab () {
  printf "%s\n" "CREATING SYMLINK FOR ${MATLAB[0]}..."

  ln -s /Applications/"${MATLAB[2]}"/bin/matlab /usr/local/bin/matlab
}

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

# Launch Matlab from terminal. Provides visual confirmation; you may comment this function in main.

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
