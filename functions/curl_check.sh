#!/usr/bin/env bash
# Install `curl` if not present (Debian-based OSs)
# Query `dpkg` for `curl`, installing it via apt if not available
 
curl_check () {
  if ! dpkg-query --show --showformat='${Status}' curl 2>/dev/null | grep --quiet "ok installed"; then
    printf "%s\\n" "Curl is NOT installed. Let's install it..."

    apt-get install --yes curl
fi
}

curl_check
