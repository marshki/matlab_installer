# Matlab Installer

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/c7574e6abc1840ab95a0f622170a9af1)](https://www.codacy.com/app/marshki/matlab_installer?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=marshki/matlab_installer&amp;utm_campaign=Badge_Grade)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/hyperium/hyper/master/LICENSE)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity)
[![Open Source Love svg3](https://badges.frapsoft.com/os/v3/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/)

Bash script to retrieve, install, and symlink various versions of [Matlab](https://www.mathworks.com/products/matlab.html). 
Also incldued script to update stale network license strings (`add_lics.sh`).     

Open to members of New York University's [Center for Brain Imaging](http://cbi.nyu.edu/), [Center for Neural Science](http://www.cns.nyu.edu/), and [Department of Psychology](http://www.psych.nyu.edu/psychology.html) on the Meyer network.   

Tested to run on Linux ([Debian-based OSs](https://www.debian.org/derivatives/#list)) and currently-supported versions of Mac OS X.  

## Getting Started

~~For sysadmins~~, we assume that you: 

- [ ] are affiliated with an institution that has a valid `Total Academic Headcount License` agreement with Math Works;  

- [ ] may access a network license server to validate local MATLAB installs;  

- [ ] can access a networked file server; and   

- [ ] deployed MATLAB locally on a `Mac OS X` and/or `Linux` client. 

After you've deployed MATLAB on a local client, tar it with, e.g.: 

`tar czf matlab9.5.tgz matlab9.5` 
 
and place the tar on your web server. Then modify the installer scripts to reflect your institution's environment. 

~~For sysadmins~~ AND ~~end users~~: 

__Pre-flight checklist__ (the script will check for the following conditions):
 
  * root privileges  

  * adeqaute free disk space (14 GBs)

  * [curl](https://curl.haxx.se/docs/manpage.html)

  * access to the Meyer network.  

**_NOTE:_** If you want the TUI version, you'll need to add the `dialog` and `pv` packages via [Apt](https://wiki.debian.org/Apt) with: 

`apt-get install --yes dialog pv` prior to executing the script. 

__Liftoff:__

Grab the script for your OS from `/src` in this repository, then, with elevated privileges, call the script:  

* `sudo bash matlab_install_linux.sh (Linux)`, or: `sudo bash matlab_install_osx.sh` (OS X) to auto-install the most recent version of Matlab. 

* `sudo bash matlab_mult_install_osx.sh` (OS X) will launch a text-based menu. From there, follow on-screen prompts:

![Alt text](https://github.com/marshki/matlab_installer/blob/master/docs/matlab_multi.png "multi-install")

* `bash matlab_linux_tui.sh` (Linux) will launch a text-based user interface and do the driving for you: 

![Alt text](https://github.com/marshki/matlab_installer/blob/master/docs/ping_cns.png "ping")|![Alt text](https://github.com/marshki/matlab_installer/blob/master/docs/retrieve_matlab.png "retrieve")

## TODO

- [x] Script network license file updater script for Linux and OS X.  
- [ ] add `pv` and `dialog` checks in Linux tui installer 
- [ ] disk space function check 
- [ ] inclue FYI on how to set up MATLAB out of the box 

## History 
v.0.2 20180211

## License 
[LICENSE](https://github.com/marshki/matlab_installer/blob/master/LICENSE). 

## Acknowledgments
`wget` + `dialog` progress bar built off of gist from [here](https://gist.github.com/Gregsen/7822421). 
 
