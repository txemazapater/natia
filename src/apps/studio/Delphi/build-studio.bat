@echo off
REM NATIA Studio — reference native client (Sprint 0 visual embryo)
call "C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\rsvars.bat"
cd /d "%~dp0"
if not exist "Win64\Debug" mkdir "Win64\Debug"
if not exist "Win32\Debug" mkdir "Win32\Debug"
set VISUAL_UNITS=..\..\..\visual;..\..\..\visual\providers
echo === Win64 ===
dcc64 -B -Q -NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell -E.\Win64\Debug -N.\Win64\Debug -U"%VISUAL_UNITS%;%BDSCOMMONDIR%\Dcp" -I"%VISUAL_UNITS%" -R"%BDSCOMMONDIR%\Bpl" NatiaStudio.dpr
if errorlevel 1 exit /b 1
echo === Win32 ===
dcc32 -B -Q -NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell -E.\Win32\Debug -N.\Win32\Debug -U"%VISUAL_UNITS%;%BDSCOMMONDIR%\Dcp" -I"%VISUAL_UNITS%" -R"%BDSCOMMONDIR%\Bpl" NatiaStudio.dpr
if errorlevel 1 exit /b 1
echo BUILD OK
exit /b 0
