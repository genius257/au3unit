@echo off

cls

setlocal

REM reg query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set BitVersion=32 || set BitVersion=64

REM IF BitVersion == 32 (set AutoItReg="HKEY_LOCAL_MACHINE\Software\AutoIt v3") ELSE (set AutoItReg="HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AutoIt v3")

REM FOR /F "skip=2 tokens=2,*" %%A IN ('reg query "%AutoItReg:"=%\AutoIt" /v "InstallDir"') DO set "AutoItDir=%%B"

set "AutoItDir=%~dp0\au3pm\autoit"

IF EXIST "%~dp0\build\au3unit.exe" (DEL "%~dp0\build\au3unit.exe")

"%AutoItDir%\Aut2Exe\Aut2exe.exe" /in "%~dp0\au3unit.au3" /out "%~dp0\build\au3unit.exe" /x86 /console

CD "%~dp0\build\"

"au3unit.exe" %*
