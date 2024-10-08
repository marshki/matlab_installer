#!/usr/bin/env bash
# The site serving up this URL uses a dated SSL/TSL certificate
# which prevents checking HTTP response codes.
# As a workaround, let's check the connection status instead.

url="https://localweb.cns.nyu.edu:443/sys/mat-archive-8-2016/macos/MATLAB9.11.app.tgz"

wget_workaround() {
  # Capture the connection status
  connection_status=$(wget --spider --server-response "$url" 2>&1 \
  | awk '/:443.../ {print $5}')

  if [ "$connection_status" = "connected." ]; then
    printf "%s\n" "Server IS reachable."
  else
    printf "%s\n" "Error: Server is NOT reachable."
    exit 1
  fi
}

wget_workaround
