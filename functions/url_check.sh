#!/usr/bin/env bash 
# check if URL is available 

#url="https://www.nyu.edu/its/software/vpn/anyconnect-macos-4.4.00243-predeploy-k9.dmg"
url="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz"
#url="https://geekberg.info" 
#url="https://google.com" 

url_check(){ 
  # make this variable local 
  curl --head --silent --show-error --fail $url > /dev/null

  if [ $? -ne "0" ] ; then
    printf "%s\\n" "BAD URL"
  else
    printf "%s\\n" "GOOD URL"
fi
} 

url_check 



# Develop test around header response code 
#curl -Is http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz|head -n 1
#HTTP/1.1 200 OK
#curl -Is http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz|head -n 1
#HTTP/1.1 302 Found
