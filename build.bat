@echo off
set /p THREADS="How many threads do you want to run for compilation? "
set /p VERSION="What is the version? "
make.bat -j %THREADS% -v %VERSION%
