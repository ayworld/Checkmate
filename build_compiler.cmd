@echo off

set config=Release
set cwd=%CD%
set outputdir=%cwd%
set commonflags=/p:Configuration=%config%;AllowUnsafeBlocks=true /p:CLSCompliant=False
set msbuild="%WINDIR%\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"

:build
echo -----------------------------------------------------
echo Building compiler..
%msbuild% compiler_src\compiler.sln %commonflags% /tv:4.0 /p:TargetFrameworkVersion=v4.0 /p:Platform="Any Cpu" /p:OutputPath="%cwd%" /fl /flp:LogFile=clog.txt
if errorlevel 1 goto build-error
del compiler.pdb
echo.

:done
echo.
echo ------------------------------------------------------
echo Compile finished...
echo A log has also been written with full details on compilation
pause
goto exit

:build-error
echo failed to compile
pause
exit

:exit
