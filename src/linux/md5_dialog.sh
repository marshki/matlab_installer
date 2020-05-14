#!/usr/bin/env bash

script=$(basename "$0")
program="MD5 HASH CHECK"

SOURCE_HASH="8e2dc3b7c652fe284ea556ea9c478297"

# Calculate md5 hash for downloaded file.

get_destination_hash () {

  dialog --backtitle "$script" --title "$program" --infobox "CALCULATING HASH TO VERIFY DOWNLOAD INTEGRITY..." 10 40 ; sleep 2

  DESTINATION_HASH="$(md5sum /usr/local/nyu_hpc_sshfs.md |awk '{print $1}')"
}

# Compare hashes. Exit if different.

md5_check () {

  if [ "$SOURCE_HASH" != "$DESTINATION_HASH" ]
    then
      dialog --backtitle "$script" --title "$program" --infobox "ERROR: HASHES DO NOT MATCH. EXITING." >&2 10 40
      exit 1

  else
      dialog --backtitle "$script" --title "$program" --infobox "HASHES MATCH. CONTINUING..." >&2 10 40; sleep 2
fi
}

main () {
  get_destination_hash
  md5_check
} 

main "$@"
