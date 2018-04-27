#!/bin/bash

# Ping CNS local web.

LOCAL_WEB="128.122.112.23"

# Is local web pingable? If not, exit.

function ping_local_web () {

printf "%s\n" "Pinging local web..."

if ping -c 1 "$LOCAL_WEB" &> /dev/null; then
  printf "%s\n" "1; reachable. Continuing..."
else
  printf "%s\n" "0; unreachable. Exiting." >&2
  exit 1
fi
}

ping_local_web
