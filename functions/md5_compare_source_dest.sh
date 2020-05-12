#!/usr/bin/env bash
# Confirm that destination file matches the source file using checksum via md5.
# GNU/Linux AND macOS
# For reference: https://stackoverflow.com/questions/17988090/what-are-the-differences-between-md5-binary-mode-and-text-mode

# Step 1:
# The source file's md5 hash.

# GNU/Linux
#SOURCE_HASH="8e2dc3b7c652fe284ea556ea9c478297"

# macOS
SOURCE_HASH="74c11e623c4acce27a637d8d89b840d1"

# Step 2: 
# Download source file. 

# GNU/Linux
#SOURCE_FILE="https://gist.githubusercontent.com/marshki/25306338cc74d38fa1f99ad7a3e90578/raw/c8acfd61c9c3ca142e03d376bbeafbc9f82cfc7e/nyu_hpc_sshfs.md"

# macOS
SOURCE_FILE="https://localweb.cns.nyu.edu/mac/MATLAB7.5.app.tgz"

get_source_file () {

  printf "%s\\n" "Retrieving source file..."

  # GNU/Linux
  #wget --progress=bar --tries=3 --wait=5 --continue $SOURCE_FILE --output-document=/usr/local/nyu_hpc_sshfs.md

  # macOS
  curl --progress-bar --retry 3 --retry-delay 5 --keepalive-time 60 --continue-at - "$SOURCE_FILE" --output /Applications/matlab.app.tgz
}

# Step 3: 
# Generate md5 hash for downloaded file.

get_destination_hash () { 
  
  printf "%s\\n" "Retrieving hash..."

  # GNU/Linux
  #DESTINATION_HASH="$(md5sum /usr/local/nyu_hpc_sshfs.md |awk '{print $1}')"

  # macOS
  DESTINATION_HASH="$(md5 -r /Applications/matlab.app.tgz |awk '{print $1}')"
}

# Step 4: 
# Compare hashes.

md5_check () { 
  printf "%s\\n" "Comparing hashes..."
  printf "%s\\n" "$SOURCE_HASH"
  printf "%s\\n" "$DESTINATION_HASH"

  if [ "$SOURCE_HASH" = "$DESTINATION_HASH" ]
    then
      printf "%s\\n" "Same."
  else
      printf "%s\\n" "Different."
fi	
} 

# Wrapper 

main () { 
  get_source_file
  get_destination_hash
  md5_check
}

main "$@" 
