@echo off
echo.

rem This build script is a windows build script
rem This script is used for single click building/installing
rem of Checkmate on your system.
rem Please check the readme for the required prerequisites
rem for building Checkmate on Windows before running this script
rem You can also build and install using:

rem make -f Makefile.win && make -f Makefile.win install && make -f Makefile.win clean

set make="make"
rem Uncomment the following line if make is not in your system PATH
rem set make="C:\Program Files (x86)\GnuWin32\bin\make.exe"

rem This if block is to check for make flags
rem -j flag is the number of asynchronous threads
if "%1" NEQ "" (
	if "%1" EQU "-j" (
		if "%2" NEQ "" (
			set makej=-j%2 -e CMPL=j%2
		) else (
			set makej=-j1 -e CMPL=j1
		)
	) else (
		set makej=-j1 -e CMPL=j1
	)
) else (
	set makej=-j1 -e CMPL=j1
)

rem This script has the ability to output a log file from the build process
rem This simple check checks if the tee command is available. If not, the easiest
rem way to get it is by installing Git
tee --version 2>NUL || goto notee

rem tee found, this builds Checkmate with the logging
:yestee
if exist build.log del build.log
echo Building Checkmate | tee -a build.log
%make% -f Makefile.win %makej% build-bat | tee -a build.log
echo.
echo Compiling installer
%make% -f Makefile.win installer | tee -a build.log
echo.
echo Launching installer | tee -a build.log
%make% -f Makefile.win install | tee -a build.log
echo.
echo Cleaning compiled binaries | tee -a build.log
%make% -f Makefile.win clean | tee -a build.log
echo.
echo Complete! | tee -a build.log
pause
exit

rem tee not found, this builds Checkmate without the logging
:notee
echo Building Checkmate
%make% -f Makefile.win %makej%
echo.
echo Compiling installer
%make% -f Makefile.win installer
echo.
echo Launching installer
%make% -f Makefile.win install
echo.
echo Cleaning compiled binaries
%make% -f Makefile.win clean
echo.
echo Complete!
pause
exit
