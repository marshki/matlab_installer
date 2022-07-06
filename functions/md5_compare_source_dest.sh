#!/usr/bin/env bash
# Confirm destination file matches source file using md5 checksum (GNU/Linux, macOS).
# For reference: https://stackoverflow.com/questions/17988090/what-are-the-differences-between-md5-binary-mode-and-text-mode.

# Step 1:
# The source file's md5 hash.

source_hash="8e2dc3b7c652fe284ea556ea9c478297"

# Step 2:
# Download source file.

source_file="https://gist.githubusercontent.com/marshki/25306338cc74d38fa1f99ad7a3e90578/raw/c8acfd61c9c3ca142e03d376bbeafbc9f82cfc7e/nyu_hpc_sshfs.md"

get_source_file () {

  printf "%s\n" "Retrieving source file..."

  # GNU/Linux
  wget --progress=bar --tries=3 --wait=5 --continue $source_file --output-document=/usr/local/nyu_hpc_sshfs.md

  # macOS
  #curl --progress-bar --retry 3 --retry-delay 5 --keepalive-time 60 --continue-at - "$source_file" --output /usr/local/nyu_hpc.sshfd.md
}

# Step 3:
# Generate md5 hash for downloaded file.

get_destination_hash () {
 
  printf "%s\n" "Calculating hash..."

  # GNU/Linux
  destination_hash="$(md5sum /usr/local/nyu_hpc_sshfs.md |awk '{print $1}')"

  # macOS
  #destination_hash="$(md5 -r /usr/local/nyu_hpc_sshfs.md |awk '{print $1}')"
}

# Step 4:
# Compare hashes.

md5_check () {
  printf "%s\n" "Comparing hashes..."
  printf "%s\n" "$source_hash"
  printf "%s\n" "$destination_hash"

  if [ "$source_hash" = "$destination_hash" ]; then
    printf "%s\n" "Same."
  else
    printf "%s\n" "Different."
fi
}

# Wrapper

main () {
  get_source_file
  get_destination_hash
  md5_check
}

main "$@"
