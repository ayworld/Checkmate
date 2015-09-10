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

rem These booleans are for compilation steps
set bBuild=false
set bInstaller=false
set bRunInstaller=false
set bClean=false
set bForceRun=false
set bForceClean=false
set bCopy=false
set bPause=false

rem This if block is to check for make flags
rem -j flag is the number of asynchronous threads
rem -r is for running the installer
rem -f is force rebuild of source only
rem -i is for building the installer
rem -c is for cleaning
set bRebuild=false
if "%1" NEQ "" (
	if "%1" EQU "-j" (
		if "%2" NEQ "" (
			set makej=-j%2 -e CMPL=j%2
		) else (
			set makej=-j1 -e CMPL=j1
		)
	) else if "%1" EQU "-f" (
		set bRebuild=true
	) else if "%1" EQU "-i" (
		set bBuild=true
		set bRunInstaller=true
		set bClean=true
		goto installer
	) else if "%1" EQU "-r" (
		set bBuild=true
		set bInstaller=true
		set bClean=true
		set bForceRun=true
		goto run
	) else if "%1" EQU "-c" (
		set bBuild=true
		set bInstaller=true
		set bRunInstaller=true
		set bForceClean=true
		goto clean
	) else (
		set makej=-j1 -e CMPL=j1
	)
) else (
	set makej=-j1 -e CMPL=j
	set bPause=true
)

rem Get current working directory
set cwd=%~dp0

rem Beginning of setup script
rem All functions point back here for next build phase
:begin
echo.
if exist "%cwd%src\release\Checkmate.exe" (
	if "%bRebuild%" EQU "true" (
		set bInstaller=true
		set bRunInstaller=true
		set bRebuild=false
		set bNoInstall=true
		set bClean=true
		set bCopy=true
		goto build
	) else if "%bNoInstall%" NEQ "true" (
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
%make% -f Makefile.win %makej% build-bat
set bBuild=true
if "%bCopy%" EQU "true" (
	%make% -f Makefile.win copy_dlls copy_binaries
)
goto begin

rem Builds the installer
:installer
echo Compiling installer
%make% -f Makefile.win installer
set bInstaller=true
goto begin

rem Runs the installer based on user choice
:run
if "%bForceRun%" EQU "true" (
	%make% -f Makefile.win install
) else (
	set /p in="Do you want to launch the installer? (Y/N): "
	if "%in%" EQU "Y" (
		%make% -f Makefile.win install
	) else if "%in%" EQU "y" (
		%make% -f Makefile.win install
	)
)
set bRunInstaller=true
goto begin

rem Runs cleanup based on user choice
:clean
if "%bForceClean%" EQU "true" (
	%make% -f Makefile.win clean
) else (
	set /p in="Do you want to clean up? (Y/N): "
	if "%in%" EQU "Y" (
		%make% -f Makefile.win clean
	) else if "%in%" EQU "y" (
		%make% -f Makefile.win clean
	)
)
set bClean=true
goto begin

rem Final phase. A simple goodbye letter
:finish
echo Compilation complete!
if "%bPause%" EQU "true" ( pause )