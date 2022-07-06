#!/usr/bin/env bash
# A quick and dirty test of a URL's HTTP status code via `curl`.

# Sample URLs + header response codes:

# GOOD:
#  - curl -Is www.cns.nyu.edu/mac/matlab9.11.tgz|head -n 1
#  - HTTP/1.1 200 OK

# BAD: 
# - curl -Is http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz|head -n 1
# - HTTP/1.1 302 Found
#
# - curl -Is https://www.nyu.edu/its/software/vpn/anyconnect-macos-4.4.00243-predeploy-k9.dmg|head -1
# - HTTP/1.1 401 Authorization Required
# 
# - curl -Is http://citi.net |head -n 1
# - HTTP/1.1 301 Moved Permanently

url="www.cns.nyu.edu/mac/matlab9.11.tgz"

url_check(){
  
  status_code=$(curl --output /dev/null --silent --head --write-out '%{http_code}\n' $url)

  if [ $status_code -ne "200" ] ; then
    printf "%s\n" "BAD URL"
  else
    printf "%s\n" "GOOD URL"
fi
}

url_check
