#!/usr/bin/env bash 
# MATLAB_VERSION=( MATLAB{9.{4..0},8.{6,5,3,0},{7.5,}}.app )

MATLAB_VERSION=(
    #MATLAB9.4.app
    #MATLAB9.3.app
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



# RC 0 = found
# RC 1 = not found
matlab_check() {
    for MATLAB in "${MATLAB_VERSION[@]}"; do
        if [ -d "/Applications/${MATLAB}" ]; then
            printf "%s\\n" "Found ${MATLAB}, continuing..."
            return 0
        fi
    done
    
    printf "%s\\n" "DID NOT FIND ANY VERSIONS OF MATLAB INSTALLED. EXITING." 
    return 1
}

matlab_check
#echo rc is $? 
