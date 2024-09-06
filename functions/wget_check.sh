#!/usr/bin/env bash
# Install `wget` if not present (Debian-based OSs)
# Query `dpkg` for `wget`, installing it via apt if not available

wget_check() {
  if [ "$(dpkg-query --show --showformat='${Status}' wget 2>/dev/null \
    | grep --count "ok installed")" -eq "0" ]; then
    printf "%s\n" "WGET IS NOT INSTALLED. LET'S INSTALL IT..."
    apt-get install wget
fi
}
