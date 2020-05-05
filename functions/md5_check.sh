#!/usr/bin/env bash

# Confirm that the destination file matches the source using checksum via md5.
# For reference: https://stackoverflow.com/questions/17988090/what-are-the-differences-between-md5-binary-mode-and-text-mode

# Step 1:
# The source file's md5 hash.

#SOURCE_HASH="22ea13c9a8b64b5defefa545f7374617"
SOURCE_HASH="861cb132f3833936211e0df59b53c511" 

# Step 2: 
# Download source file. 

SOURCE_FILE="https://raw.githubusercontent.com/marshki/matlab_installer/master/src/linux/matlab_install_linux.sh"

get_source_file () {
  printf "%s\\n" "Retrieving source file..."

  wget --progress=bar --tries=3 --wait=5 --continue $SOURCE_FILE --output-document=/usr/local/matlab_linux_tui.sh
}

# Step 3: 
# Generate md5 hash for downloaded file.

get_destination_hash () { 
  
  printf "%s\\n" "Retrieving hash..."
  DESTINATION_HASH="$(md5sum /usr/local/matlab_linux_tui.sh |awk '{print $1}')"
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
