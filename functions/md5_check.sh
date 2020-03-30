#!/bin/bash

# Place holder. 
# Confirm that the destination file matches the source using checksum via md5.
# For reference: https://stackoverflow.com/questions/17988090/what-are-the-differences-between-md5-binary-mode-and-text-mode

file1=$(md5 "$1")
file2=$(md5 "$2")

if [ "$file1" = "$file2" ]
then
    printf "%s\\n" "Same."
else
    printf "%s\\n" "Different."
fi		
