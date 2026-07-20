@echo off
setlocal
set BDS=C:\Program Files (x86)\Embarcadero\Studio\22.0
call "%BDS%\bin\rsvars.bat"
set ROOT=%~dp0..
set DUNITX=%BDS%\source\DunitX
set OUTDIR=%ROOT%\artifacts\win32
if not exist "%OUTDIR%\dcu" mkdir "%OUTDIR%\dcu"

echo === Natia.Core Win32 ===
dcc32 -B -E"%OUTDIR%" -N0"%OUTDIR%\dcu" -U"%ROOT%\src\core\domain;%ROOT%\src\core\contracts;%ROOT%\src\core\application;%ROOT%\src\core\inmemory" "%ROOT%\src\core\Natia.Core.dpr"
if errorlevel 1 exit /b 1

echo === Natia.Core.Tests Win32 ===
dcc32 -B -E"%OUTDIR%" -N0"%OUTDIR%\dcu" -U"%DUNITX%;%ROOT%\src\core\domain;%ROOT%\src\core\contracts;%ROOT%\src\core\application;%ROOT%\src\core\inmemory;%ROOT%\tests\core" -NS"System;Xml;Xml.Win;System.Win;Data;Datasnap;Web;Soap;Winapi;DUnitX" "%ROOT%\tests\core\Natia.Core.Tests.dpr"
if errorlevel 1 exit /b 1

echo === Run tests Win32 ===
"%OUTDIR%\Natia.Core.Tests.exe"
exit /b %ERRORLEVEL%
