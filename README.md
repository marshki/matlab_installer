# Matlab Installer

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/c7574e6abc1840ab95a0f622170a9af1)](https://www.codacy.com/app/marshki/matlab_installer?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=marshki/matlab_installer&amp;utm_campaign=Badge_Grade)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/hyperium/hyper/master/LICENSE)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity)
[![Open Source Love svg3](https://badges.frapsoft.com/os/v3/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)

Bash script to retrieve, install, and symlink various versions of [Matlab](https://www.mathworks.com/products/matlab.html). 
Also includes script to update stale network license strings (`add_lics.sh`).     

Open to members of New York University's [Center for Brain Imaging](http://cbi.nyu.edu/), [Center for Neural Science](http://www.cns.nyu.edu/), and [Department of Psychology](http://www.psych.nyu.edu/psychology.html) on the Meyer network.   

Tested to run on Linux ([Debian-based OSs](https://www.debian.org/derivatives/#list)) and currently-supported versions of Mac OS X.  

## E-Z Install

**OS X:** `curl https://raw.githubusercontent.com/marshki/matlab_installer/master/src/os_x/matlab_install_osx.sh | sudo bash`

**LINUX:** `curl https://raw.githubusercontent.com/marshki/matlab_installer/master/src/linux/matlab_install_linux.sh | sudo bash`

## Getting Started

**For sysadmins who want to replicate this process**, we assume that you: 

- [ ] are affiliated with an institution that has a valid `Total Academic Headcount License` agreement with Math Works;  

- [ ] may access a network license server to validate local MATLAB installs;  

- [ ] can access a networked file server; and   

- [ ] deployed MATLAB locally on a `Mac OS X` and/or `Linux` client. 

On your local client, tar up the MATLAB install with, e.g.: 

`tar czf matlab9.5.tgz matlab9.5` 
 
and place the file on your web server for distribution.  

If needed, modify the installer script(s) to reflect your institution's environment. 

**For sysadmins** AND **end users**: 

__Pre-flight checklist__ (the script will check for the following conditions):
 
- [ ] root privileges;   

- [ ] adeqaute free disk space (14 GBs); 

- [ ] [curl](https://curl.haxx.se/docs/manpage.html); 

- [ ]  access to the the appropriate local network.  

**_NOTE:_** If you want the TUI version, you'll need to add the `dialog` package via [Apt](https://wiki.debian.org/Apt) with: 

`apt-get install --yes dialog` prior to executing the script. 

__Liftoff:__

Grab the script for your OS from `/src` in this repository, then, with elevated privileges, call the script (*[caffeinate](https://ss64.com/osx/caffeinate.html) will prevent OS X from going to sleep during the installation)*:  

* `sudo bash matlab_install_linux.sh (Linux)`, or: `caffeinate -i sudo bash matlab_install_osx.sh` (OS X) to auto-install the most recent version of Matlab. 

* `caffeinate -i sudo bash matlab_mult_install_osx.sh` (OS X) will launch a text-based menu. From there, follow on-screen prompts:

![Alt text](https://github.com/marshki/matlab_installer/blob/master/docs/matlab_multi.png "multi-install")

* `bash matlab_linux_tui.sh` (Linux) will launch a text-based user interface and do the driving for you: 

![Alt text](https://github.com/marshki/matlab_installer/blob/master/docs/ping_cns.png "ping")|![Alt text](https://github.com/marshki/matlab_installer/blob/master/docs/retrieve_matlab.png "retrieve")

## TODO

- [ ] add `wget` URL check for Linux similar to `local_web_check` function for `matlab_linux_tui.sh`  

- [ ] software checks in Linux scripts should do silent `apt-get` 

- [ ] unit tests? 

## History 
v.0.2 20180211

## License 
[LICENSE](https://github.com/marshki/matlab_installer/blob/master/LICENSE). 

## Acknowledgments
`wget` + `dialog` progress bar built off of gist from [here](https://gist.github.com/Gregsen/7822421). 
