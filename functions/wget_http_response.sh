#!/urs/bin/env bash
# `wget` HTTP response code check for `dialog` TUI.
#  - `200` is only acceptalbe response code.

script=$(basename "$0")
program="MATLAB INSTALLER"

local_web="www.cns.nyu.edu/mac/matlab9.11.tgz"

local_web_check() {
  local status_code

  status_code=$(wget --spider --server-response "$local_web" 2>&1 | awk '/HTTP\/1.1/{print $2}' | head -1)

  if [ "$status_code" -ne "200" ] ; then
    dialog --backtitle "$script" --title "$program" --infobox "ERROR: CNS LOCAL WEB IS NOT REACHABLE. EXITING." >&2 10 40
    exit 1

  else
    dialog --backtitle "$script" --title "$program" --infobox "CNS LOCAL WEB IS REACHABLE. CONTINUING..." >&2 10 40
fi
}

local_web_check
