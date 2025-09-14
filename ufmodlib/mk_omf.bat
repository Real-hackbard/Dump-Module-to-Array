@echo off
rem Make the uFMOD libraries in OMF format
rem Target OS: Win32

rem *** CONFIG START
rem *** Check the Readme docs for a complete reference
rem *** on configuring the following options

rem Pathes:
SET UF_TASM=C:\tools\TASM
SET UF_MASM=C:\tools\masm32
SET UF_NASM=C:\tools\nasm
SET UF_TLIB=C:\tools\TASM\bin

rem Select compiler: TASM, MASM or NASM
rem (Choose TASM or NASM for Delphi compatibility)
SET UF_ASM=NASM

rem Select output format: OBJ or LIB
SET UF_FMT=OBJ

rem Select mixing rate: 22050, 44100 or 48000 (22.05 KHz, 44.1 KHz or 48 KHz)
SET UF_FREQ=48000

rem Set volume ramping mode (interpolation): NONE, WEAK or STRONG
SET UF_RAMP=STRONG

rem Select strings encoding: ANSI or UNICODE
SET UF_UFS=ANSI

rem Set build mode: NORMAL or UNSAFE
SET UF_MODE=NORMAL
rem *** CONFIG END

if %UF_ASM%==TASM goto TASM
if %UF_ASM%==MASM goto MASM
if %UF_ASM%==NASM goto NASM
echo %UF_ASM% not supported
goto TheEnd

:MASM
if not exist "%UF_MASM%\bin\ml.exe" goto Err2
SET UF_ASM=/c /nologo /DOMF /Df%UF_FREQ% /D%UF_RAMP% /D%UF_UFS% /D%UF_MODE% /Fo
"%UF_MASM%\bin\ml" /DWINMM       %UF_ASM% ufmod.obj    src\masm.asm
"%UF_MASM%\bin\ml" /DOPENAL      %UF_ASM% oalufmod.obj src\masm.asm
"%UF_MASM%\bin\ml" /DDIRECTSOUND %UF_ASM% dsufmod.obj  src\masm.asm
if not exist ufmod.obj goto TheEnd
echo Object file not compatible with Delphi. Use TASM or NASM to compile a Delphi-friendly version.
goto MkLb

:NASM
if not exist "%UF_NASM%\nasmw.exe" goto Err3
SET UF_ASM=-O5 -t -fobj -dOMF -df%UF_FREQ% -d%UF_RAMP% -d%UF_UFS% -d%UF_MODE% -isrc\
"%UF_NASM%\nasmw" %UF_ASM% -dWINMM       -oufmod.obj    src\nasm.asm
"%UF_NASM%\nasmw" %UF_ASM% -dOPENAL      -ooalufmod.obj src\nasm.asm
"%UF_NASM%\nasmw" %UF_ASM% -dDIRECTSOUND -odsufmod.obj  src\nasm.asm
if not exist ufmod.obj goto TheEnd
bin\o4delphi ufmod.obj
bin\o4delphi oalufmod.obj
bin\o4delphi dsufmod.obj
goto MkLb

:TASM
if not exist "%UF_TASM%\bin\tasm32.exe" goto Err4
SET UF_ASM=/mx /m4 /zn /q /df%UF_FREQ%=1 /d%UF_RAMP%=1 /d%UF_UFS%=1 /d%UF_MODE%=1 /isrc\ src\masm.asm
"%UF_TASM%\bin\tasm32" /dWINMM=1       %UF_ASM%, ufmod.obj
"%UF_TASM%\bin\tasm32" /dOPENAL=1      %UF_ASM%, oalufmod.obj
"%UF_TASM%\bin\tasm32" /dDIRECTSOUND=1 %UF_ASM%, dsufmod.obj
if not exist ufmod.obj goto TheEnd
goto MkLb

:MkLb
if %UF_FMT%==OBJ goto TheEnd
if not exist "%UF_TLIB%\tlib.exe" goto Err1
if exist ufmod.lib    rm ufmod.lib
if exist oalufmod.lib rm oalufmod.lib
if exist dsufmod.lib  rm dsufmod.lib
"%UF_TLIB%\tlib" ufmod.lib    +ufmod.obj
"%UF_TLIB%\tlib" oalufmod.lib +oalufmod.obj
"%UF_TLIB%\tlib" dsufmod.lib  +dsufmod.obj
del *.obj
goto TheEnd

:Err1
echo Couldn't find tlib.exe   in %UF_TLIB%\
goto TheEnd
:Err2
echo Couldn't find ml.exe     in %UF_MASM%\bin\
goto TheEnd
:Err3
echo Couldn't find nasmw.exe  in %UF_NASM%\
goto TheEnd
:Err4
echo Couldn't find tasm32.exe in %UF_TASM%\bin\

:TheEnd
pause
@echo on
cls
