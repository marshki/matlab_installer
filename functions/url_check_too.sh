#!/usr/bin/env bash 
# quick and dirty HTTP status code of URL  

#### Test around header response code, e.g.: #### 

# GOOD: 
# wget --spider --server-response https://geekberg.info 2>&1 | awk '/^  HTTP/{print $2}'|head -1 
# 200

# BAD: 
# wget --spider --server-response http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz 2>&1 \ 
# | awk '/^  HTTP/{print $2}' |head -1
# 302

#url="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz"
#url="https://www.google.com" 
#url="https://geekberg.info" 
url="https://www.nyu.edu/its/software/vpn/anyconnect-macos-4.4.00243-predeploy-k9.dmg://www.nyu.edu/its/software/vpn/anyconnect-macos-4.4.00243-predeploy-k9.dmg" 

wget_check() { 
  # wget to check HTTP status code; error message if it fails
  
  status_code=$(wget --spider --server-response $url 2>&1 | awk '/^ HTTP/{print $2}' | head -1)  

  if [ "$status_code" -ne "200" ] ; then 
    printf "%s\\n" "BAD URL" 
  else 
    printf "%s\\n" "GOOD URL" 
fi 
} 

wget_check

#curl_check(){ 
  # curl to check HTTP status code; error message if it fails  

  #status_code=$(curl --output /dev/null --silent --head --write-out '%{http_code}\n' $url)

  #if [ $status_code -ne "200" ] ; then 
    #printf "%s\\n" "BAD URL" 
  #else 
    #printf "%s\\n" "GOOD URL" 
#fi 
#} 

#curl_check 
