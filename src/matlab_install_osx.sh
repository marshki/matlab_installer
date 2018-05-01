#!/bin/bash
# mjk235 [at] nyu [dot] edu --20170210

### Matlab installer V.0.1 for OS X. ###

MATLAB_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz"

LOCAL_WEB="128.122.112.23"

# Is current UID 0? If not, exit.

function root_check () {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\n" "Error: root privileges are required to continue. Exiting." >&2
    exit 1
fi
}

# Is there adequate disk space in "/Applications"? If not, exit.

function check_disk_space () {
  if [ $(df -Hl /Applications |awk 'FNR == 2 {print $4}' |sed 's/G//') -le 30 ]; then
    printf "%s\n" "Error: not enough free disk space. Exiting." >&2
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

# Is CNS local web available? If not, exit.

function ping_local_web() {
  printf "%s\n" "Pinging CNS local web..."

  if ping -c 1 "$LOCAL_WEB" &> /dev/null; then
    printf "%s\n" "CNS local web IS reachable. Continuing..."
  else
    printf "%s\n" "Error: CNS local web IS NOT reachable. Exiting." >&2
    exit 1
 fi
}

# Download tarball.

function get_matlab () {
  printf "%s\n" "Retrieving Matlab insaller..."

  curl --progress-bar --retry 3 --retry-delay 5 "$MATLAB_INSTALLER" --output matlab.app.tgz
}

# Unpack tarball to /Applications .

function untar_matlab () {
  printf "%s\n" "Untarring package to /Applications..."
  tar --extract --gzip -v --file=matlab.app.tgz --directory=/Applications
}

# Remove tarball.

function remove_matlab_tar () {
  printf "%s\n" "Removing Matlab Installer..."
  rm -rf matlab.app.tgz
}

# Does /usr/local/bin exist? If not, add it

function local_bin_check () {
  if [ ! -d "/usr/local/bin" ] ; then
    printf "%s\n" "/usr/local/bin does NOT exist; let's add it..."
    mkdir -pv /usr/local/bin
fi
}

# Create symlink for Matlab

function symlink_matlab () {
  printf "%s\n" "Creating symlink..."
  ln -s /Applications/MATLAB9.4.app/bin/matlab /usr/local/bin/matlab
}

# Launch Matlab from terminal

function launch_matlab () {
  printf "%s\n" "Launching Matlab..."
  matlab -nodesktop
}

# Main function

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
