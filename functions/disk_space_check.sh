#!/usr/bin/env bash
# Available disk space check.
# df on locally-mounted file systems (kbs) | awk to get 2nd line, 1st field
# available space  

check_disk_space() {
  local required_space=14680064
  local available_space=$(df --local -k --output=avail /usr/local |awk 'FNR == 2 {print $1}')

  if [ "$available_space" -lt "$required_space" ]; then
    printf "%s\n" "ERROR: Not enough free disk space. Exiting." >&2
    exit 1
fi
}

check_disk_space
