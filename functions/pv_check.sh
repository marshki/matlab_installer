#!/usr/bin/env bash

# Is pv installed? If not, install it.
# Add silent install so it doesn't break the dialog box.

script=$(basename "$0")
program="MATLAB INSTALLER"

pv_check () {

  if [ "$(dpkg-query --show --showformat='${Status}' pv 2>/dev/null | grep --count "ok installed")" -eq "0" ]; then
    dialog --backtitle "$script" --title "$program" --infobox "PV IS NOT INSTALLED. LET'S INSTALL IT..." >&2 10 40
    apt-get install --yes pv
fi
}

pv_check
