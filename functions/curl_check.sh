#!/bin/bash 
# Install curl if not present (Debian-based OSs) 

curl_check () {
  if [ "$(dpkg-query --show --showformat='${Status}' curl 2>/dev/null | grep --count "ok installed")" -eq "0" ]; then
    printf "%s\\n" "CURL IS NOT INSTALLED. LET'S INSTALL IT..."
    apt-get install curl
fi
}
