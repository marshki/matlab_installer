#!/usr/bin/env bash 
# Iterate through array; 
# tell me what you find (match/no-match) 

# Array 
MATLAB_APP=(
MATLAB.app 
MATLAB7.5.app 
MATLAB8.0.app 
MATLAB8.3.app 
MATLAB8.5.app
MATLAB8.6.app
MATLAB9.0.app
MATLAB9.1.app
MATLAB9.2.app
MATLAB9.3.app
MATLAB9.4.app
)

matlab_check() { 
  # is MATLAB*.*.app installed in /Applications?  
  # iterate through array & tell me what you find 

  for MATLAB in "${MATLAB_APP[@]}"; 
  do  
    if [ -d "/Applications/$MATLAB" ]; then 
      printf "%s\\n" "$MATLAB EXISTS" 
    else 
      printf "%s\\n" "$MATLAB DOES NOT EXIST in /Applications."  
fi   
done 
} 

matlab_check 
