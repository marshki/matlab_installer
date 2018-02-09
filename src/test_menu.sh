#!/bin/bash

PS3=("Enter the number of the Matlab version to install: ")

MATLAB_VERSIONS=(
"Matlab 1"
"Matlab 2"
"Matlab 3"
"Quit"
)

select opt in "${MATLAB_VERSIONS[@]}"

do
    case $opt in
        "Matlab 1")
            printf "%s\n" "You selected Matlab 1"
            ;;
        "Matlab 2")
            printf "%s\n" "You selected Matlab 2"
            ;;
        "Matlab 3")
            printf "%s\n" "You selected Matlab 3"
            ;;
        "Quit")
            break
            ;;
        *) printf "%s\n" "Invalid Option";;
    esac
done
