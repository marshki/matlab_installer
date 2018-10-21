#!/usr/bin/env bash
# Ping to test if site is responding to ICMP requests.  
# This isn't bulletproof--if the server is configured to NOT respond to requests, 
# you can get a false negative. 

# Is URL available? If not, exit.

url="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz"

ping_local_web() {
  printf "%s\\n" "PINGING CNS LOCAL WEB..."

  if ping -c 1 $url &> /dev/null; then
    printf "%s\\n" "CNS LOCAL WEB IS REACHABLE. CONTINUING..."
  else
    printf "%s\\n" "ERROR: CNS LOCAL WEB IS NOT REACHABLE. EXITING." >&2
    exit 1
fi
}

ping_local_web
