#!/bin/bash 
# Install curl if not present (Debian-based OSs) 

# Query dpkg to get status of package, if count equals zero, install via apt

curl_check () {
  if [ "$(dpkg-query --show --showformat='${Status}' curl 2>/dev/null | grep --count "ok installed")" -eq "0" ]; then
    printf "%s\\n" "CURL IS NOT INSTALLED. LET'S INSTALL IT..."
    apt-get install curl
fi
}

curl_check
