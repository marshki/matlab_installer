#!/usr/bin/env bash

# Confirm that the destination file matches the source using checksum via md5.
# For reference: https://stackoverflow.com/questions/17988090/what-are-the-differences-between-md5-binary-mode-and-text-mode

# Step 1:
# The source file's md5 hash.

SOURCE_HASH="22ea13c9a8b64b5defefa545f7374617"

# Step 2: 
# Download source file. 

SOURCE_FILE="https://raw.githubusercontent.com/marshki/matlab_installer/master/src/linux/matlab_install_linux.sh"

get_source_file () {
  printf "%s\\n" "Retrieving source file..."

  wget --progress=bar --tries=3 --wait=5 --continue $SOURCE_FILE --output-document=/usr/local/matlab_linux_tui.sh
}

# Step 3: 
# Generate md5 hash for downloaded file.

get_download_hash () { 
  
  printf "%s\\n" "Retrieving hash..."
  DOWNLOAD_HASH="$(md5sum /usr/local/matlab_tui.sh |awk '{print $1}')"
} 

# Step 4: 
# Compare hashes.

md5_check () { 
  printf "%s\\n" "Comparing hashes..."

  if [ "$source" = "$destination" ]
    then
      printf "%s\\n" "Same."
  else
      printf "%s\\n" "Different."
fi	
} 

md5_check	
