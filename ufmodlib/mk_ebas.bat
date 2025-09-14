@echo off
rem Make the uFMOD libraries for Emergence BASIC (EBASIC)
rem Target OS: Win32

rem *** CONFIG START
rem *** Check the Readme docs for a complete reference
rem *** on configuring the following options

rem Pathes:
SET UF_MASM=C:\tools\masm32
SET UF_NASM=C:\tools\nasm
SET UF_FASM=C:\tools\fasm
SET UF_LINK=C:\tools\masm32\bin

rem Select compiler: MASM, NASM or FASM
SET UF_ASM=FASM

rem Select mixing rate: 22050, 44100 or 48000 (22.05 KHz, 44.1 KHz or 48 KHz)
SET UF_FREQ=48000

rem Set volume ramping mode (interpolation): NONE, WEAK or STRONG
SET UF_RAMP=STRONG

rem Set build mode: NORMAL or UNSAFE
SET UF_MODE=NORMAL
rem *** CONFIG END

if %UF_ASM%==MASM goto MASM
if %UF_ASM%==NASM goto NASM
if %UF_ASM%==FASM goto FASM
echo %UF_ASM% not supported
goto TheEnd

:MASM
if not exist "%UF_MASM%\bin\ml.exe" goto Err2
"%UF_MASM%\bin\ml" /DWINMM /c /coff /nologo /DEBAS /Df%UF_FREQ% /D%UF_RAMP% /DANSI /D%UF_MODE% /Fo ufmod.obj src\masm.asm
if not exist ufmod.obj goto TheEnd
goto MkLb

:NASM
if not exist "%UF_NASM%\nasmw.exe" goto Err3
"%UF_NASM%\nasmw" -O4 -t -fwin32 -dWINMM -dEBAS -df%UF_FREQ% -d%UF_RAMP% -dANSI -d%UF_MODE% -isrc\ -oufmod.obj src\nasm.asm
if not exist ufmod.obj goto TheEnd
goto MkLb

:FASM
if not exist "%UF_FASM%\fasm.exe" goto Err4
echo UF_OUTPUT equ WINMM            >tmp.asm
echo UF_FREQ   equ %UF_FREQ%       >>tmp.asm
echo UF_RAMP   equ %UF_RAMP%       >>tmp.asm
echo UF_UFS    equ ANSI            >>tmp.asm
echo UF_MODE   equ %UF_MODE%       >>tmp.asm
echo UF_FMT    equ 0               >>tmp.asm
echo VB6       equ 0               >>tmp.asm
echo PBASIC    equ 0               >>tmp.asm
echo EBASIC    equ 1               >>tmp.asm
echo BLITZMAX  equ 0               >>tmp.asm
echo NOLINKER  equ 0               >>tmp.asm
echo macro xtrn smb,arg,nm { extrn '__imp__' # `smb # '@' # `arg as nm:DWORD } >>tmp.asm
echo macro thnk nm { nm equ [nm] } >>tmp.asm
echo include 'src\eff.inc'         >>tmp.asm
echo include 'src\fasm.asm'        >>tmp.asm
"%UF_FASM%\fasm" tmp.asm ufmod.obj
del tmp.asm
if not exist ufmod.obj goto TheEnd

:MkLib
if not exist "%UF_LINK%\link.exe" goto Err1
"%UF_LINK%\link" -lib /NOLOGO /OUT:uFMOD.lib ufmod.obj
del *.obj
goto TheEnd

:Err1
echo Couldn't find link.exe  in %UF_LINK%\
goto TheEnd
:Err2
echo Couldn't find ml.exe    in %UF_MASM%\bin\
goto TheEnd
:Err3
echo Couldn't find nasmw.exe in %UF_NASM%\
goto TheEnd
:Err4
echo Couldn't find fasm.exe  in %UF_FASM%\

:TheEnd
pause
@echo on
cls
