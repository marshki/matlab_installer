#!/usr/bin/env bash 
# check if URL is available 

url="https://www.nyu.edu/its/software/vpn/anyconnect-macos-4.4.00243-predeploy-k9.dmg"
#url="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz"

#curl -IsSf https://www.nyu.edu/its/software/vpn/anyconnect-macos-4.4.00243-predeploy-k9.dmg > /dev/null
#curl --head --silent --show-error --fail https://www.nyu.edu/its/software/vpn/anyconnect-macos-4.4.00243-predeploy-k9.dmg > /dev/null
#curl -sSf http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz > /dev/null


url_check() { 

  if [ "curl --head --silent --show-error --fail $url > /dev/null" -ne "0" ] ; then 
    printf "%s\\n" "URL GOOD" 
  else 
    printf "%s\\n" "URL BAD" 

  fi 
} 

url_check 

#if curl --output /dev/null --silent --head --fail "$url"; then
#  echo "URL exists: $url"
#else
#  echo "URL does not exist: $url"
#fi
