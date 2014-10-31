# Checkmate
The readme file for Checkmate and build instructions

## Table of Contents
* [Getting tools](#gettings-tools)
* [Libs You Need](#libs-you-need)
* [Compiler](#compiler)
* [Contributors](#contributors)

## Getting Tools

Checkmate is built using MinGW32 compiler from Qt via QMAKE. Please be sure you have that package of Qt installed onto the system before attempting to compile Checkmate.

To build, you need three different tools:

1. Qt - Compiler and IDE (For programming and graphical UI building)
2. GnuMake for Win32 (For compiling and generating exe)
3. Inno Setup (For building installer via iss install script)
4. MinGW (Contains g++ compiler for Qt project)
5. Visual Studio 2013+ (Express will do fine. Needed for building compiler)

Internet shortcuts are provided for all four tools, but not the tools themselves.  

compiler.exe will use GnuMake if you've installed it onto your system. If it cannot be found via compiler.ini, then it will default to the current directory the compiler is run in.

It's simple, install Qt, install Inno Setup, install GnuMake, and lastly, install VS 2013 (Express Edition will do fine), run build_compiler.cmd then run compiler.exe

## Libs You Need
You will need several libraries that are included in Qt.  
Follow this structure:

```
checkmate_win32_bin\bin\platforms\qwindows32.dll
checkmate_win32_bin\bin\icudt52.dll
checkmate_win32_bin\bin\icuin52.dll
checkmate_win32_bin\bin\icuuc52.dll
checkmate_win32_bin\bin\libgcc_s_dw2-1.dll
checkmate_win32_bin\bin\libstdc++-6.dll
checkmate_win32_bin\bin\libwinpthread-1.dll
checkmate_win32_bin\bin\Qt5Core.dll
checkmate_win32_bin\bin\Qt5Gui.dll
checkmate_win32_bin\bin\Qt5Widgets.dll
```

This will allow the compiler to successfully build the installer  
The compiler will pull all of these for you straight from the Qt directory you have setup in your compiler.ini config file

## Compiler
As of build tool v3, codenamed "compiler", everything is done with just opening compiler.exe. You may need to configure compiler.ini, so look at ini.txt for instructions on how the ini configuration file works for the compiler.

Make sure both Qt and Inno Setup are installed on the system. If you installed them in a different directory, edit compiler.ini to reflect those locations.

GnuMake is also read if you have it pasted in the project's root directory, so you don't have to install it. Just make sure the compiler can see it in the root directory or you point to it through compiler.ini

## Contributors
[Pazuzu156](https://github.com/pazuzu156)
