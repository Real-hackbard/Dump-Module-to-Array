@echo off
rem Make the uFMOD purelibraries for PureBasic
rem Target OS: Win32

rem *** CONFIG START
rem *** Check the Readme docs for a complete reference
rem *** on configuring the following options

rem Pathes:
SET UF_MASM=C:\tools\masm32
SET UF_NASM=C:\tools\nasm
SET UF_FASM=C:\tools\fasm
SET UF_LIBRARYMAKER=LibraryMaker

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
SET UF_ASM=/c /coff /nologo /DPUREBASIC /Df%UF_FREQ% /D%UF_RAMP% /DANSI /D%UF_MODE% /Fo
"%UF_MASM%\bin\ml" /DWINMM       %UF_ASM% src\ufmod.obj    src\masm.asm
"%UF_MASM%\bin\ml" /DOPENAL      %UF_ASM% src\oalufmod.obj src\masm.asm
"%UF_MASM%\bin\ml" /DDIRECTSOUND %UF_ASM% src\dsufmod.obj  src\masm.asm
if not exist src\ufmod.obj goto TheEnd
goto MkLib

:NASM
if not exist "%UF_NASM%\nasmw.exe" goto Err3
SET UF_ASM=-O4 -t -fwin32 -dPUREBASIC -df%UF_FREQ% -d%UF_RAMP% -dANSI -d%UF_MODE% -isrc\
"%UF_NASM%\nasmw" %UF_ASM% -dWINMM       -osrc\ufmod.obj    src\nasm.asm
"%UF_NASM%\nasmw" %UF_ASM% -dOPENAL      -osrc\oalufmod.obj src\nasm.asm
"%UF_NASM%\nasmw" %UF_ASM% -dDIRECTSOUND -osrc\dsufmod.obj  src\nasm.asm
if not exist src\ufmod.obj goto TheEnd
goto MkLib

:FASM
if not exist "%UF_FASM%\fasm.exe" goto Err4
echo UF_OUTPUT equ WINMM            >tmp.asm
echo UF_FREQ   equ %UF_FREQ%       >>tmp.asm
echo UF_RAMP   equ %UF_RAMP%       >>tmp.asm
echo UF_UFS    equ ANSI            >>tmp.asm
echo UF_MODE   equ %UF_MODE%       >>tmp.asm
echo UF_FMT    equ 0               >>tmp.asm
echo VB6       equ 0               >>tmp.asm
echo PBASIC    equ 1               >>tmp.asm
echo EBASIC    equ 0               >>tmp.asm
echo BLITZMAX  equ 0               >>tmp.asm
echo NOLINKER  equ 0               >>tmp.asm
echo macro xtrn smb,arg,nm { extrn '__imp__' # `smb # '@' # `arg as nm:DWORD } >>tmp.asm
echo macro thnk nm         { nm equ [nm] } >>tmp.asm
echo include 'src\eff.inc'         >>tmp.asm
echo include 'src\fasm.asm'        >>tmp.asm
"%UF_FASM%\fasm" tmp.asm src\ufmod.obj
echo UF_OUTPUT equ OPENAL           >tmp.asm
echo UF_FREQ   equ %UF_FREQ%       >>tmp.asm
echo UF_RAMP   equ %UF_RAMP%       >>tmp.asm
echo UF_UFS    equ ANSI            >>tmp.asm
echo UF_MODE   equ %UF_MODE%       >>tmp.asm
echo UF_FMT    equ 0               >>tmp.asm
echo VB6       equ 0               >>tmp.asm
echo PBASIC    equ 1               >>tmp.asm
echo EBASIC    equ 0               >>tmp.asm
echo BLITZMAX  equ 0               >>tmp.asm
echo NOLINKER  equ 0               >>tmp.asm
echo macro xtrn    smb,arg,nm { extrn '__imp__' # `smb # '@' # `arg as nm:DWORD } >>tmp.asm
echo macro oalxtrn smb,nm     { extrn '__imp__' # `smb as nm:DWORD } >>tmp.asm
echo macro thnk    nm         { nm equ [nm] } >>tmp.asm
echo include 'src\eff.inc'         >>tmp.asm
echo include 'src\fasm.asm'        >>tmp.asm
"%UF_FASM%\fasm" tmp.asm src\oalufmod.obj
echo UF_OUTPUT equ DIRECTSOUND      >tmp.asm
echo UF_FREQ   equ %UF_FREQ%       >>tmp.asm
echo UF_RAMP   equ %UF_RAMP%       >>tmp.asm
echo UF_UFS    equ ANSI            >>tmp.asm
echo UF_MODE   equ %UF_MODE%       >>tmp.asm
echo UF_FMT    equ 0               >>tmp.asm
echo VB6       equ 0               >>tmp.asm
echo PBASIC    equ 1               >>tmp.asm
echo EBASIC    equ 0               >>tmp.asm
echo BLITZMAX  equ 0               >>tmp.asm
echo NOLINKER  equ 0               >>tmp.asm
echo macro xtrn smb,arg,nm { extrn '__imp__' # `smb # '@' # `arg as nm:DWORD } >>tmp.asm
echo macro thnk nm         { nm equ [nm] } >>tmp.asm
echo include 'src\eff.inc'         >>tmp.asm
echo include 'src\fasm.asm'        >>tmp.asm
"%UF_FASM%\fasm" tmp.asm src\dsufmod.obj
del tmp.asm
if not exist src\ufmod.obj goto TheEnd

:MkLib
"%UF_LIBRARYMAKER%" src\ufmod.desc    /COMPRESSED
"%UF_LIBRARYMAKER%" src\oalufmod.desc /COMPRESSED
"%UF_LIBRARYMAKER%" src\dsufmod.desc  /COMPRESSED
del src\*.obj
del *.log
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
