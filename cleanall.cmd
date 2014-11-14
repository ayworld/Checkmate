@echo off
del compiler.exe
del compile_log.txt
del clog.txt
cd compiler_src
rmdir /S /Q bin
rmdir /S /Q obj
cd ../checkmate_win32_bin
rmdir /S /Q updates
rmdir /S /Q release
cd bin
del icudt52.dll
del icuin52.dll
del icuuc52.dll
del libgcc_s_dw2-1.dll
del libstdc++-6.dll
del libwinpthread-1.dll
del Qt5Core.dll
del Qt5Gui.dll
del Qt5Widgets.dll
del Qt5Network.dll
cd platforms
del qwindows.dll
cd ../../../
echo done
pause
