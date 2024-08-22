#!/usr/bin/env bash
# Install `wget` if not present (Debian-based OSs)
# Query `dpkg` for `wget`, installing it via apt if not available

wget_check () {
  if ! dpkg-query --show --showformat='${Status}' wget 2>/dev/null \
  | grep --quiet "ok installed"; then
    printf "%s\\n" "Wget is NOT installed. Let's install it..."

    apt-get install --yes wget
fi
}

wget_check
