#!/usr/bin/env bash 
# A quick and dirty test of a URL's HTTP status code via `wget`.

# Sample URLs + header response codes:

# GOOD: 
#  - wget --spider --server-response https://geekberg.info 2>&1 | awk '/HTTP\/1.1/{print $2}'|head -1
#  - 200

# BAD: 
#  - wget --spider --server-response http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/macos/current-MATLAB.app.tgz 2>&1 \
#      awk '/HTTP\/1.1/{print $2}' |head -1
#  - 302

url="http://localweb.cns.nyu.edu/sys/mat-archive-8-2016/macos/MATLAB9.11.app.tgz"

wget_check() {
    
  status_code=$(wget --spider --server-response $url 2>&1 | awk '/HTTP\/1.1/{print $2}' | head -1)

  printf "%s\n" "$status_code"

  if [ "$status_code" -ne "200" ] ; then
    printf "%s\n" "BAD URL"
  else
    printf "%s\n" "GOOD URL"
fi
}

wget_check
