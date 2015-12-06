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
		goto build
	) else if "%1" EQU "-i" (
		goto buildInstaller
	) else if "%1" EQU "-r" (
		goto runInstaller
	) else if "%1" EQU "-c" (
		goto clean
	)
) else (
	goto error
)

:build
title Building Checkmate...
echo Building Checkmate...
%MAKE% -f Makefile.win %THREADS% build-bat
rem separating these two from the build. Causes it to fuck up for some reason
rem when using multi-threading for compiling.
%MAKE% -f Makefile.win copy_dlls copy_binaries

:buildInstaller
title Building installer...
echo Building installer...
%MAKE% -f Makefile.win installer
goto end

:runInstaller
title Running installer...
echo Running installer...
%MAKE% -f Makefile.win install
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
echo.
pause
exit

:end
title Complete!
echo Compilation complete!
pause
