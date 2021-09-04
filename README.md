# MATLAB Installer

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/c7574e6abc1840ab95a0f622170a9af1)](https://www.codacy.com/app/marshki/matlab_installer?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=marshki/matlab_installer&amp;utm_campaign=Badge_Grade)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity)
https://img.shields.io/github/last-commit/marshki/matlab_installer?style=plastic
[!last-commit](https://img.shields.io/github/last-commit/marshki/matlab_installer?style=plastic)[https://img.shields.io/github/last-commit/marshki/matlab_installer?style=plastic]
[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/hyperium/hyper/master/LICENSE)
[![Open Source Love svg3](https://badges.frapsoft.com/os/v3/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)

Bash script to retrieve, install, and symlink various versions of [MATLAB](https://www.mathworks.com/products/matlab.html):

|Version     |Release Name|
|------------|------------|
|MATLAB 9.0  |R2016a      |
|MATLAB 9.1  |R2016b      |
|MATLAB 9.2  |R2017a      |
|MATLAB 9.3  |R2017b      |
|MATLAB 9.4  |R2018a      |
|MATLAB 9.5  |R2018b      |
|MATLAB 9.6  |R2019a      |
|MATLAB 9.7  |R2019b      |
|MATLAB 9.9  |R2020b      |

Also included: script to update stale network license strings.     

Open to members of New York University's [Center for Brain Imaging](http://cbi.nyu.edu/), [Center for Neural Science](http://www.cns.nyu.edu/), and [Department of Psychology](http://www.psych.nyu.edu/psychology.html) on the Meyer network.   

Tested to run on GNU/Linux ([Debian-based OSs](https://www.debian.org/derivatives/#list)) and currently-supported versions of macOS.  

## EZ Install

**macOS:** `curl https://raw.githubusercontent.com/marshki/matlab_installer/master/src/macOS/macOS_installer.sh | caffeinate sudo bash`

**GNU/LINUX (Debian-based distros):** 
`wget https://raw.githubusercontent.com/marshki/matlab_installer/master/src/linux/linux_installer.sh && sudo bash linux_installer.sh` 

## Getting Started

**For sysadmins who want to replicate this process**, we assume the following of you: 

- [ ] are affiliated with an institution that has a valid `Total Academic Headcount License` agreement with Math Works

- [ ] may access a network license server to validate local MATLAB installs  

- [ ] can access a networked file server   

- [ ] deployed MATLAB locally on a `macOS` and/or `GNU/Linux` client 

On your local client, tar up the MATLAB install with, e.g.: 

`tar czf matlab9.5.tgz matlab9.5` 
 
and place the file on your web server for distribution.  

If needed, modify the installer script(s) to reflect your institution's environment. 

**For sysadmins** AND **end users**: 

__Pre-flight checklist__ (the script will check for the following conditions):
 
- [ ] root privileges   

- [ ] adequate free disk space (30 GBs)

- [ ] [curl](https://curl.haxx.se/docs/manpage.html) or [wget](https://www.gnu.org/software/wget/)

- [ ]  access to the the appropriate local network

**_NOTE:_** If you want the TUI version, you'll need to add the `dialog` package via [Apt](https://wiki.debian.org/Apt) with: 

`apt-get install --yes dialog` prior to executing the script. 

__Liftoff:__

Grab the script for your OS from `/src` in this repository, then, with elevated privileges, call the script (*[caffeinate](https://ss64.com/osx/caffeinate.html) will prevent macOS from going to sleep during the installation)*:  

* `sudo bash linux_installer.sh (Linux)`, or: `caffeinate -i sudo bash macOS_installer.sh` (macOS) to auto-install the most recent version of Matlab. 

* `caffeinate -i sudo bash macOS_multi_installer.sh` (macOS) will launch a text-based menu. From there, follow on-screen prompts:

![Alt text](https://github.com/marshki/matlab_installer/blob/master/docs/matlab_multi.png "multi-install")

* `bash linux_installer_tui.sh` (Linux) will launch a text-based user interface and do the driving for you: 

![Alt text](https://github.com/marshki/matlab_installer/blob/master/docs/wget_result.png "http response")|![Alt text](https://github.com/marshki/matlab_installer/blob/master/docs/wget_retrieve.png "retrieve")

## History 
v.0.3 2019.05.16

## License 
[LICENSE](https://github.com/marshki/matlab_installer/blob/master/LICENSE). 

## Acknowledgments
`wget` + `dialog` progress bar built off of gist from [here](https://gist.github.com/Gregsen/7822421). 
