#!/usr/bin/env bash 
# iterate through array; 
# continue if you find at least one match  

# Array 
MATLAB_VERSION=(
MATLAB9.4.app
MATLAB9.3.app
MATLAB9.2.app
MATLAB9.1.app
MATLAB9.0.app
MATLAB8.6.app
MATLAB8.5.app
MATLAB8.3.app 
MATLAB8.0.app 
MATLAB7.5.app 
MATLAB.app 
)

matlab_check() { 
  # is MATLAB*.*.app installed in /Applications?  
  # iterate through array & tell me what you find 

  for MATLAB in "${MATLAB_VERSION[@]}"; 
  do  
    if [ -d "/Applications/$MATLAB" ]; then 
      printf "%s\\n" "FOUND $MATLAB IN /Applications, CONTINUING..."
      break 
    else 
      printf "%s\\n" "SEARCHING for $MATLAB in /Applications..." 
    fi 
done 
} 

matlab_check 
