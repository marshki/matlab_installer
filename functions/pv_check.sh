#!/usr/bin/env bash
# Install `pv` if not present (Debian-based OSs)
# Query `dpkg` for `pv`, installing if via apt if not available
# Note to self: can we use silent install (--quiet/ -qq) so we don't break `dialog` box?

script=$(basename "$0")
program="MATLAB INSTALLER"

pv_check () {
  if ! dpkg-query --show --showformat='${Status}' pv 2>/dev/null | grep --count "ok installed"; then
    dialog --backtitle "$script" --title "$program" --infobox "PV is NOT installed. Let's install it..." >&2 10 40

    apt-get install --yes pv
fi
}

pv_check
