@echo off
call "C:\Program Files (x86)\Embarcadero\Studio\22.0\bin\rsvars.bat"
cd /d "%~dp0"
if not exist "Win64\Debug" mkdir "Win64\Debug"
set VISUAL_UNITS=..\..\src\visual;..\..\src\visual\providers
set NATIA_ASSETS_ROOT=%~dp0..\..\assets
dcc64 -B -Q -NSSystem;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win;Vcl;Vcl.Imaging -E.\Win64\Debug -N.\Win64\Debug -U"%VISUAL_UNITS%;%BDSCOMMONDIR%\Dcp" -I"%VISUAL_UNITS%" Natia.Visual.Tests.dpr
if errorlevel 1 exit /b 1
.\Win64\Debug\Natia.Visual.Tests.exe
exit /b %ERRORLEVEL%
