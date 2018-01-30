#!/bin/bash

### Map Matlab version to download URL ###

MATLAB_8.5_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab8.5.tgz"
MATLAB_8.6_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab8.6.tgz"
MATLAB_9.0_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.0.tgz"
MATLAB_9.1_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.1.tgz"
MATLAB_9.2_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.2.tgz"
MATLAB_9.3_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.3.tgz"

#### Display pause prompt ####
# Suspend processing of script; display message prompting user to press [Enter] key to continue
# $1-> Message (optional)

function pause(){
    local message="$@"
    [ -z $message ] && message="Press [Enter] key to continue:  "
    read -p "$message" readEnterKey
}

#### Menu ####
function show_menu () {
    date
    printf "%s\n" "------------------------------"
    printf "%s\n" "  Matlab Installer for Linux  "
    printf "%s\n" "  Main Menu                   "
    printf "%s\n" "------------------------------"
        printf "%s\n" "  1. Install Matlab 8.5"
        printf "%s\n" "  2. Install Matlab 8.6"
        printf "%s\n" "  3. Install Matlab 9.0"
        printf "%s\n" "  4. Install Matlab 9.1"
        printf "%s\n" "  5. Install Matlab 9.2"
        printf "%s\n" "  6. Install Matlab 9.3"
        printf "%s\n" "  7. Quit"
}

#### Input ####

function read_input(){
    local c
    read -p "Enter your choice [ 1-7 ]:  " c
    case $c in
        1) ;;
        2) ;;
        3) ;;
        4) ;;
        5) ;;
        6) ;;
        7) ;;
        *)
           printf "%s\n"  "Select an Option (1 to 7):  "
           pause
    esac
}

#### Ignore CTRL+C, CTRL+Z and quit signals using the trap ####

trap '' SIGINT SIGQUIT SIGTSTP

#### Main logic ####
# Display menu; wait for user input
while true
do
    clear
    show_menu
    read_input
done
