@echo off
rem Rebuild import libs
rem -------------------
rem Place the implib.inc file here before recompiling the libs.
rem It is available in the ImpLib package: http://implib.sourceforge.net/

rem Set FASM compiler location:
SET FASM=C:\tools\fasm

if not exist "%FASM%\fasm.exe" goto Err1

rem Build the VB6 libraries
"%FASM%\fasm" defs\vb_dsound.def ..\..\lib\vb_dsound.lib
"%FASM%\fasm" defs\vb_winmm.def ..\..\lib\vb_winmm.lib

rem Build the OpenAL MS-COFF library
"%FASM%\fasm" defs\openal32.def ..\..\..\Examples\Masm32\OpenAL\openal32.lib
if errorlevel 1 goto TheEnd
copy ..\..\..\Examples\Masm32\OpenAL\openal32.lib ..\..\..\Examples\Nasm\OpenAL\openal32.lib
copy ..\..\..\Examples\Masm32\OpenAL\openal32.lib ..\..\..\Examples\Fasm\OpenAL\openal32.lib
copy ..\..\..\Examples\Masm32\OpenAL\openal32.lib ..\..\..\Examples\C\OpenAL\src\openal32.lib
copy ..\..\..\Examples\Masm32\OpenAL\openal32.lib ..\..\..\Examples\FreePascal\OpenAL\libopenal32.a

rem Build the OpenAL library for BlitzMax
"%FASM%\fasm" defs\bm_openal.def ..\..\..\Examples\BlitzMax\lib\libopenal32.a
if errorlevel 1 goto TheEnd

rem Build the DirectSound import library for BlitzMax
"%FASM%\fasm" defs\bm_dsound.def ..\..\..\Examples\BlitzMax\lib\libdsound.a

goto TheEnd
:Err1
echo Couldn't find fasm.exe in %FASM%
:TheEnd
pause
@echo on
cls
