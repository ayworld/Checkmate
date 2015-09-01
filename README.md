# Checkmate
The readme file for Checkmate and build instructions

## Windows Build
There are 2 things you will need to build Checkmate on Windows.  
1. [GnuWin32 - Make for Windows][1]
2. [Qt 5.4][2]

Checkmate is built with MinGW, so you need to install the MinGW package for Qt. The installer will give you that option. Qt v5.4 is required to compile Checkmate. 5.5 is out, but it's not using 5.5, so just use 5.4.

To compile, make sure MAKE is in your PATH, or just reference to it when executing the command.

```/> make -f Makefile.win```

To clean up the entire build process AND installer run:

```/> make -f Makefile.win clean```

## Linux Build
To build in Linux, the Qt libraries are required. If you have the option to install modules sepearately, the two you will need are:
1. Qt5-Base
2. Qt5-Webkit

To compile checkmate, be sure that you have the build tools for your specific distribution, that includes make and g++

Compile:
```$ make```

Clean up build process
```$ make clean```

Linux also has 2 other commands for the makefile, install and uninstall. Both require root, so be sure to run the install/uninstall commands as root

Install:
```$ make && sudo make install```

Uninstall:
```$ make uninstall```

## Distro Install
### Arch

Checkmate is in the Arch User Repository under [checkmate-git][3]

## Contributors
[Pazuzu156](https://github.com/pazuzu156)

[1]:http://gnuwin32.sourceforge.net/packages/make.htm
[2]:http://www.qt.io/
[3]:https://aur.archlinux.org/packages/checkmate-git/