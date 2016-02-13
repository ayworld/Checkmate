@echo off
color 0A
rem Handle paths

set QT=C:\Qt\5.4\mingw491_32\bin
set MINGW=C:\MinGW\bin
set MAKE=%MINGW%\mingw32-make.exe
set PATH=%MINGW%;%QT%;%PATH%
set CWD=%~dp0

rem Handle flags

if "%1" NEQ "" (
	if "%1" EQU "-j" (
		if "%2" NEQ "" (
			set THREADS=-j%2 -e CMPL=j%2
		) else (
			set makej=-j1 -e CMPL=j1
		)
	) else if "%1" EQU "-f" (
		set DEBUG=release
		goto build
	) else if "%1" EQU "-i" (
		goto buildInstaller
	) else if "%1" EQU "-r" (
		goto runInstaller
	) else if "%1" EQU "-c" (
		goto clean
	) else if "%1" EQU "-d" (
		set DEBUG=debug
		goto build
	)
) else (
	goto error
)

:build
if "%1" EQU "-v" (
	set VERSION=%2
) else (
	if "%3" NEQ "" (
		set VERSION=%4
	) else (
		set /p VERSION="What's the version? "
	)
)
title Building Checkmate...
echo Building Checkmate...
%MAKE% -f Makefile.win %THREADS% -e DEBUG=%DEBUG% build-bat
rem separating these two from the build. Causes it to fuck up for some reason
rem when using multi-threading for compiling.
if "%DEBUG%" EQU "debug" (
	%MAKE% -f Makefile.win copy_dlls_d copy_binaries_d
) else (
	%MAKE% -f Makefile.win copy_dlls copy_binaries
)

:buildInstaller
title Building installer...
echo Building installer...
if "%DEBUG%" NEQ "" (
	%MAKE% -f Makefile.win installer_d -e VERSION=%VERSION% -e BUILD=_debug
) else (
	%MAKE% -f Makefile.win installer -e VERSION=%VERSION%
)
goto end

:runInstaller
title Running installer...
echo Running installer...
if exist "%CWD%checkmate_win32_bin\release\checkmate_setup.exe" (
	%MAKE% -f Makefile.win install
) else (
	echo Installer not found, cannot install!
	pause
	exit
)
goto end

:clean
title Cleaning up...
echo Cleaning up...
%MAKE% -f Makefile.win clean
goto end

:error
@echo off
title == ERROR ==
echo Did you forget to run the script with another one of the batch scripts?
echo You can run make.bat with one of the switches if you so wish
echo.
echo -j NUM - Compiles checkmate
echo -i - Force Compiles installer (By default, make.bat builds installer when building checkmate)
echo -f - Force rebuild of checkmate and installer
echo -c - Cleans up checkmate binaries
echo -r - Runs the installer
echo -d - Builds a debug version
echo.
pause
exit

:end
title Complete!
echo Compilation complete!
pause
