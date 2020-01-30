@echo off

setlocal

call "%~dp0\build.bat"

CD "%~dp0\build\tests\"

"..\au3unit.exe" %*
