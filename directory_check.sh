#!/bin/bash
# Check if /usr/local/bin exits
# add dir if it does not

function local_bin_check () {
  if [ ! -d "/usr/local/bin" ] ; then
    printf "%s\n" "/usr/local/bin does NOT exist; let's add it..."
    mkdir -pv /usr/local/bin
fi
}

local_bin_check
