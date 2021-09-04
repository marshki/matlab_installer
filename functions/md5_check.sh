#!/usr/bin/env bash
# Compare md5 hashes

source_hash="8e2dc3b7c652fe284ea556ea9c478297"
destination_hash="8e2dc3b7c652fe284ea556ea9c478297"

md5_check () { 
  printf "%s\n" "Comparing hashes..."
  printf "%s\n" "$source_hash"
  printf "%s\n" "$destination_hash"

  if [ "$source_hash" = "$destination_hash" ]
    then
      printf "%s\n" "Same."
  else
      printf "%s\n" "Different."
fi	
} 

md5_check
