#!/bin/bash

# Map Matlab version to download URL

MATLAB_8.5_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab8.5.tgz"
MATLAB_8.6_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab8.6.tgz"
MATLAB_9.0_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.0.tgz"
MATLAB_9.1_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.1.tgz"
MATLAB_9.2_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.2.tgz"
MATLAB_9.3_INSTALLER="http://localweb.cns.nyu.edu/unixadmin/mat-distro-12-2014/linux/matlab9.3.tgz"

function show_menu(){
    date
    printf "%s\n" "------------------------------"
    printf "%s\n" "  Matlab Installer for Linux  "
    printf "%s\n" "  Main Menu                   "
    printf "%s\n" "------------------------------"
        printf "%s\n" "  1. Matlab 8.5"
        printf "%s\n" "  1. Matlab 8.6"
        printf "%s\n" "  1. Matlab 9.0"
        printf "%s\n" "  1. Matlab 9.1"
        printf "%s\n" "  1. Matlab 9.2"
        printf "%s\n" "  1. Matlab 9.3"

}
