#!/bin/bash 
# Install wget if not present (Debian-based OSs) 

# Query dpkg to get status of package, if count equals zero, install via apt
 
wget_check () {
  if [ "$(dpkg-query --show --showformat='${Status}' wget 2>/dev/null | grep --count "ok installed")" -eq "0" ]; then
    printf "%s\\n" "WGET IS NOT INSTALLED. LET'S INSTALL IT..."
    apt-get install wget
fi
}

wget_check
