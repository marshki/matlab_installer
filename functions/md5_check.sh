#!/usr/bin/env bash
# Compare md5 hashes

SOURCE_HASH="8e2dc3b7c652fe284ea556ea9c478297"
DESTINATION_HASH="8e2dc3b7c652fe284ea556ea9c478297"

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

md5_check
