#!/usr/bin/env bash
# Run as sudo b/c the file is being written to /usr/local

# Confirm that the destination file matches the source using checksum via md5.
# For reference: https://stackoverflow.com/questions/17988090/what-are-the-differences-between-md5-binary-mode-and-text-mode

# Step 1:
# The source file's md5 hash.

SOURCE_HASH="8e2dc3b7c652fe284ea556ea9c478297"

# Step 2: 
# Download source file. 

SOURCE_FILE="https://gist.githubusercontent.com/marshki/25306338cc74d38fa1f99ad7a3e90578/raw/c8acfd61c9c3ca142e03d376bbeafbc9f82cfc7e/nyu_hpc_sshfs.md"

get_source_file () {

  printf "%s\\n" "Retrieving source file..."

  wget --progress=bar --tries=3 --wait=5 --continue $SOURCE_FILE --output-document=/usr/local/nyu_hpc_sshfs.md
}

# Step 3: 
# Generate md5 hash for downloaded file.

get_destination_hash () { 
  
  printf "%s\\n" "Retrieving hash..."
  DESTINATION_HASH="$(md5sum /usr/local/nyu_hpc_sshfs.md |awk '{print $1}')"
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
