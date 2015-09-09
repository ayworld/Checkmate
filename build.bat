@echo off

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

rem These booleans are for comilation steps
set bBuild=false
set bInstaller=false
set bRunInstaller=false
set bClean=false

rem Get current working directory
set cwd=%~dp0

rem Beginning of setup script
rem All functions point back here for next build phase
:begin
echo.
if exist "%cwd%src\release\Checkmate.exe" (
	if exist "%cwd%checkmate_win32_bin\release\checkmate_setup.exe" (
		if "%bRunInstaller%" NEQ "true" (
			set bBuild=true
			set bInstaller=true
			goto run
		)
	) else (
		if "%bInstaller%" NEQ "true" (
			set bBuild=true
			goto installer
		)
	)
) else if "%bBuild%" EQU "false" (
	goto build
)
if "%bBuild%" EQU "false" goto build
if "%bInstaller%" EQU "false" goto installer
if "%bRunInstaller%" EQU "false" goto run
if "%bClean%" EQU "false" goto clean
goto finish

rem Builds the application
:build
echo Building Checkmate
%make% -f Makefile.win %makej%
set bBuild=true
goto begin

rem Builds the installer
:installer
echo Compiling installer
%make% -f Makefile.win installer
set bInstaller=true
goto begin

rem Runs the installer based on user choice
:run
set /p in="Do you want to launch the installer? (Y/N): "
if "%in%" EQU "Y" (
	%make% -f Makefile.win install
) else if "%in%" EQU "y" (
	%make% -f Makefile.win install
)
set bRunInstaller=true
goto begin

rem Runs cleanup based on user choice
:clean
set /p in="Do you want to clean up? (Y/N): "
if "%in%" EQU "Y" (
	%make% -f Makefile.win clean
) else if "%in%" EQU "y" (
	%make% -f Makefile.win clean
)
set bClean=true
goto begin

rem Final phase. A simple goodbye letter
:finish
echo Compilation complete!
pause
exit
