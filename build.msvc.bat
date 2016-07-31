@echo off
title KPF Build Tool
color 0A

rem build env. applications
rem please change according to your setup
set CWD=%~dp0
set QT=C:\Qt\5.6\msvc2013\bin
set MINGW=C:\MinGW\bin
set MAKE=%MINGW%\mingw32-make.exe
set VCPATH=C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC
set QMAKE=%QT%\qmake.exe
set VC="%VCPATH%\vcvarsall.bat"

rem Make sure to get nmake!!!!!
call %VC% x86

rem Just in case you wanna run a certain
rem event manually, use one of the cmd args
rem -b force build
rem -c force clean
if "%1" NEQ "" (
	if "%1" EQU "-b" (
		goto build
	) else if "%1" EQU "-c" (
		goto clean
	) else (
		goto error
	)
)

if exist bin\win32\KPF.exe goto clean

:build
echo.
if "%1" EQU "-v" (
	set VERSION=%2
) else (
	if "%3" NEQ "" (
		set VERSION=%4
	) else (
		set /p VERSION="What's the version? "
	)
)
echo.
echo building makefile
%QMAKE% src\Checkmate.pro -o src\Makefile
echo.
echo compiling binary
cd %CWD%\src
nmake -nologo -f Makefile.Release
cd %CWD%
rem copy /Y src\release\KPF.exe "%CWD%\checkmate_win32_bin\bin\KPF.exe"
copy /Y src\release\Checkmate.exe "%CWD%\checkmate_win32_bin\bin\Checkmate.exe"
echo.
echo copying required libraries
copy /Y %QT%\Qt5Core.dll "%CWD%\checkmate_win32_bin\bin\Qt5Core.dll"
copy /Y %QT%\Qt5Gui.dll "%CWD%\checkmate_win32_bin\bin\Qt5Gui.dll"
copy /Y %QT%\Qt5Widgets.dll "%CWD%\checkmate_win32_bin\bin\Qt5Widgets.dll"
copy /Y %QT%\Qt5Network.dll "%CWD%\checkmate_win32_bin\bin\Qt5Network.dll"
copy /Y %QT%\..\plugins\platforms\qwindows.dll "%CWD%\checkmate_win32_bin\bin\platforms\qwindows.dll"
echo.
echo Building installer...
%MAKE% -f Makefile.win installer_msvc -e VERSION=%VERSION%
echo.
echo Build complete!
goto finish

:clean
echo.
echo Cleaning up binaries
cd "%CWD%\checkmate_win32_bin\bin"
if exist Checkmate.exe del Checkmate.exe
if exist Qt5Core.dll del Qt5Core.dll
if exist Qt5Gui.dll del Qt5Gui.dll
if exist Qt5Widgets.dll del Qt5Widgets.dll
if exist Qt5Network.dll del Qt5Network.dll
if exist platforms\qwindows.dll del platforms\qwindows.dll
cd "%CWD%\checkmate_win32_bin"
rmdir /S /Q release
cd "%CWD%\src"
nmake -f Makefile.Release clean
if exist object_script.Checkmate.Debug del object_script.Checkmate.Debug
if exist object_script.Checkmate.Release del object_script.Checkmate.Release
if exist debug rmdir /S /Q debug
if exist release rmdir /S /Q release
if exist Makefile del Makefile
if exist Makefile.Debug del Makefile.Debug
if exist Makefile.Release del Makefile.Release
cd ..
echo.
echo Cleaning complete
goto finish

:error
echo.
echo Error: "%1" is an invalid command switch!
echo.

:finish
pause
