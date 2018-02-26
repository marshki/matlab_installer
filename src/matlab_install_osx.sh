#!/bin/bash

### Matlab installer V.1.0 for OS X. ###

MATLAB_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz"

# Is current UID 0? If not, exit.

function root_check () {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\n" "ROOT privileges are required to continue. Exiting." >&2
    exit 1
fi
}

# Is there adequate disk space in ""/Applications"? If not, exit.

function check_disk_space () {
  if [ $(df -Hl /Applications |awk 'FNR == 2 {print $4}' |sed 's/G//') -le 30 ]; then
    printf "%s\n" "Not enough free disk space. Exiting." >&2
    exit 1
fi
}

# Is curl installed? If not, exit. (Curl ships with OS X, but let's check).

function curl_check () {
if ! [ -x "$(command -v curl 2>/dev/null)" ]; then
  printf "%s\n" "Error: curl is not installed.  Please install it."  >&2
  exit 1
fi
}

# Download tarball

function get_matlab () {
  printf "%s\n" "Retrieving Matlab insaller..."
  curl --progress-bar --retry 3 --retry-delay 5 "$MATLAB_INSTALLER" --output matlab.app.tgz
}

# Delete quarrantine attribute
# NOTE: Probably don't need this, so commented out. Will test to confirm. 
#function lift_quarrantine (){
#  printf "%s\n" "Removing quattantine..."
#  xattr -d com.apple.quarantine matlab.app.tgz
#}

# Unpack tarball to /Applications

function untar_matlab () {
  printf "%s\n" "Untarring package to /Applications..."
  tar --extract --gzip -v --file=matlab.app.tgz --directory=/Applications
}

# Remove tarball

function remove_matlab_tar () {
  printf "%s\n" "Removing Matlab Installer..."
  rm -rf matlab.app.tgz
}

# Create symlink for Matlab
# NOTE: Check syntax 
#function symlink_matlab () {
#  printf "%s\n" "Creating symlink..."
#  ln -s /Applications/MATLAB9.3.app/bin/matlab /usr/local/bin/matlab
#}

# Launch Matlab from terminal
# NOTE: Check syntax above. Once confirmed, use this as a test of your install. 
#function launch_matlab () {
#  printf "%s\n" "Launching Matlab..."
#  matlab -nodesktop
#}

# Main function

main () {
	root_check
	check_disk_space
	curl_check
  	get_matlab
  	#lift_quarrantine
	untar_matlab
	remove_matlab_tar
	#symlink_matlab
	#launch_matlab
}

main "$@"
