#!/urs/bin/env bash
# `wget` HTTP response code check for `dialog` TUI.
#  - `200` is only acceptalbe response code.

script=$(basename "$0")
program="MATLAB INSTALLER"

local_web="https://localweb.cns.nyu.edu:443/sys/mat-archive-8-2016/macos/MATLAB9.11.app.tgz"

# wget --spider -S "https://geekberg.info" 2>&1 | grep "HTTP/" | awk '{print $2}'


local_web_check() {
  local status_code=$(wget --spider -server-response "$local_web" 2>&1 \
  | awk '/HTTP\/1.1/{print $2}' | head -1)

  if [ "$status_code" -ne "200" ] ; then
    dialog --backtitle "$script" --title "$program" --infobox "Error: CNS local web is NOT reachable. Exiting." >&2 10 40
    exit 1
  else
    dialog --backtitle "$script" --title "$program" --infobox "CNS local web IS reachable. Continuing..." >&2 10 40
fi
}

local_web_check
