#!/bin/bash
# mjk235 [at] nyu [dot] edu --2017.02.10

LOCAL_WEB="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.5.tgz"

MATLAB=(
Matlab9.5
"http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.5.tgz"
matlab9.5
)

#==============
# Sanity checks
#==============

# Is current UID 0? If not, exit.

root_check () {
  if [ "$EUID" -ne "0" ] ; then
    printf "%s\\n" "ERROR: ROOT PRIVILEGES ARE REQUIRED TO CONTINUE. EXITING." >&2
    exit 1
fi
}

# Is there adequate disk space in /usr/local directory? If not, exit.

check_disk_space () {
  if [ "$(df --local -k --output=avail /usr/local |awk 'FNR == 2 {print $1}')" -le "14680064" ]; then
    printf "%s\\n" "ERROR: NOT ENOUGH FREE DISK SPACE. EXITING." >&2
    exit 1
fi
}

# Is wget installed? It should be, but let's check. 

wget_check () {
  if [ "$(dpkg-query --show --showformat='${Status}' wget 2>/dev/null | grep --count "ok installed")" -eq "0" ]; then
    printf "%s\\n" "WGET IS NOT INSTALLED. LET'S INSTALL IT..."
    apt-get install wget
fi
}

# Is CNS local web available? If not, exit. 

local_web_check() {
  local status_code 
  status_code=$(wget --spider --server-response "$LOCAL_WEB" 2>&1 | awk '/HTTP\/1.1/{print $2}' | head -1)

  if [ "$status_code" -ne "200" ] ; then
    printf "%s\\n" "ERROR: CNS LOCAL WEB IS NOT REACHABLE. EXITING." >&2  
    exit 1 

  else 
    printf "%s\\n" "CNS LOCAL WEB IS REACHABLE. CONTINUING..."
fi
}

sanity_checks () {
  root_check 
  check_disk_space
  wget_check 
  local_web_check
}

sanity_checks 
