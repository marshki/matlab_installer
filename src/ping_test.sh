#!/bin/bash

# Ping CNS local web.

LOCAL_WEB="128.122.112.23"

# Is local web pingable? If not, exit.

function ping_local_web () {

printf "%s\n" "Pinging CNS local web..."

if ping -c 1 "$LOCAL_WEB" &> /dev/null; then
  printf "%s\n" "CNS local web IS reachable. Continuing..."
else
  printf "%s\n" "CNS local web IS NOT reachable. Exiting." >&2
  exit 1
fi
}

ping_local_web
