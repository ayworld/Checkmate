@echo off
set /p THREADS="How many threads do you want to run for compilation? "
make.bat -j %THREADS%
