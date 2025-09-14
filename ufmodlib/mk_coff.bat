@echo off
rem Make the uFMOD libraries in COFF format
rem Target OS: Win32

rem *** CONFIG START
rem *** Check the Readme docs for a complete reference
rem *** on configuring the following options

rem Pathes:
SET UF_MASM=C:\tools\masm32
SET UF_NASM=C:\tools\nasm
SET UF_FASM=C:\tools\fasm
SET UF_LINK=C:\tools\masm32\bin
SET UF_IMPS=C:\tools\masm32\lib

rem Select compiler: MASM, NASM or FASM
rem (Choose FASM for MingW compatibility)
SET UF_ASM=FASM

rem Select output format: OBJ, LIB or DLL
SET UF_FMT=OBJ

rem Select mixing rate: 22050, 44100 or 48000 (22.05 KHz, 44.1 KHz or 48 KHz)
SET UF_FREQ=48000

rem Set volume ramping mode (interpolation): NONE, WEAK or STRONG
SET UF_RAMP=STRONG

rem Select strings encoding: ANSI or UNICODE
SET UF_UFS=ANSI

rem Set build mode: NORMAL, UNSAFE or BENCHMARK
SET UF_MODE=NORMAL
rem *** CONFIG END

if %UF_ASM%==MASM goto MASM
if %UF_ASM%==NASM goto NASM
if %UF_ASM%==FASM goto FASM
echo %UF_ASM% not supported
goto TheEnd

:MASM
if not exist "%UF_MASM%\bin\ml.exe" goto Err2
SET UF_ASM=/c /coff /nologo /Df%UF_FREQ% /D%UF_RAMP% /D%UF_UFS% /D%UF_MODE% /D%UF_FMT% /Fo
"%UF_MASM%\bin\ml" /DWINMM       %UF_ASM% ufmod.obj    src\masm.asm
"%UF_MASM%\bin\ml" /DOPENAL      %UF_ASM% oalufmod.obj src\masm.asm
"%UF_MASM%\bin\ml" /DDIRECTSOUND %UF_ASM% dsufmod.obj  src\masm.asm
if not exist ufmod.obj goto TheEnd
if %UF_FMT%==DLL goto MkDll
echo Object files not compatible with MingW (GCC).
echo Use FASM to compile MingW-friendly versions.
goto MkLb

:NASM
if not exist "%UF_NASM%\nasmw.exe" goto Err3
SET UF_ASM=-O4 -t -fwin32 -df%UF_FREQ% -d%UF_RAMP% -d%UF_UFS% -d%UF_MODE% -d%UF_FMT% -isrc\
"%UF_NASM%\nasmw" %UF_ASM% -dWINMM       -oufmod.obj    src\nasm.asm
"%UF_NASM%\nasmw" %UF_ASM% -dOPENAL      -ooalufmod.obj src\nasm.asm
"%UF_NASM%\nasmw" %UF_ASM% -dDIRECTSOUND -odsufmod.obj  src\nasm.asm
if not exist ufmod.obj goto TheEnd
if %UF_FMT%==DLL goto MkDll
echo Object files not compatible with MingW (GCC).
echo Use FASM to compile MingW-friendly versions.
goto MkLb

:FASM
if not exist "%UF_FASM%\fasm.exe" goto Err4
echo UF_OUTPUT          equ WINMM                  >tmp.asm
echo UF_FREQ            equ %UF_FREQ%             >>tmp.asm
echo UF_RAMP            equ %UF_RAMP%             >>tmp.asm
echo UF_UFS             equ %UF_UFS%              >>tmp.asm
echo UF_MODE            equ %UF_MODE%             >>tmp.asm
echo UF_FMT             equ %UF_FMT%              >>tmp.asm
echo VB6                equ 0                     >>tmp.asm
echo PBASIC             equ 0                     >>tmp.asm
echo EBASIC             equ 0                     >>tmp.asm
echo BLITZMAX           equ 0                     >>tmp.asm
echo NOLINKER           equ 0                     >>tmp.asm
echo DllEntry           equ _DllEntry@12          >>tmp.asm
echo uFMOD_PlaySong     equ _uFMOD_PlaySong@12    >>tmp.asm
echo uFMOD_Jump2Pattern equ _uFMOD_Jump2Pattern@4 >>tmp.asm
echo uFMOD_Pause        equ _uFMOD_Pause@0        >>tmp.asm
echo uFMOD_Resume       equ _uFMOD_Resume@0       >>tmp.asm
echo uFMOD_GetTime      equ _uFMOD_GetTime@0      >>tmp.asm
echo uFMOD_GetStats     equ _uFMOD_GetStats@0     >>tmp.asm
echo uFMOD_GetRowOrder  equ _uFMOD_GetRowOrder@0  >>tmp.asm
echo uFMOD_GetTitle     equ _uFMOD_GetTitle@0     >>tmp.asm
echo uFMOD_SetVolume    equ _uFMOD_SetVolume@4    >>tmp.asm
echo macro xtrn smb,arg,nm { extrn '__imp__' # `smb # '@' # `arg as nm:DWORD } >>tmp.asm
echo macro thnk nm         { nm equ [nm] }        >>tmp.asm
echo include 'src\eff.inc'                        >>tmp.asm
echo include 'src\fasm.asm'                       >>tmp.asm
"%UF_FASM%\fasm" tmp.asm ufmod.obj
echo UF_OUTPUT          equ OPENAL                 >tmp.asm
echo UF_FREQ            equ %UF_FREQ%             >>tmp.asm
echo UF_RAMP            equ %UF_RAMP%             >>tmp.asm
echo UF_UFS             equ %UF_UFS%              >>tmp.asm
echo UF_MODE            equ %UF_MODE%             >>tmp.asm
echo UF_FMT             equ %UF_FMT%              >>tmp.asm
echo VB6                equ 0                     >>tmp.asm
echo PBASIC             equ 0                     >>tmp.asm
echo EBASIC             equ 0                     >>tmp.asm
echo BLITZMAX           equ 0                     >>tmp.asm
echo NOLINKER           equ 0                     >>tmp.asm
echo DllEntry           equ _DllEntry@12          >>tmp.asm
echo uFMOD_OALPlaySong  equ _uFMOD_OALPlaySong@16 >>tmp.asm
echo uFMOD_Jump2Pattern equ _uFMOD_Jump2Pattern@4 >>tmp.asm
echo uFMOD_Pause        equ _uFMOD_Pause@0        >>tmp.asm
echo uFMOD_Resume       equ _uFMOD_Resume@0       >>tmp.asm
echo uFMOD_GetTime      equ _uFMOD_GetTime@0      >>tmp.asm
echo uFMOD_GetStats     equ _uFMOD_GetStats@0     >>tmp.asm
echo uFMOD_GetRowOrder  equ _uFMOD_GetRowOrder@0  >>tmp.asm
echo uFMOD_GetTitle     equ _uFMOD_GetTitle@0     >>tmp.asm
echo uFMOD_SetVolume    equ _uFMOD_SetVolume@4    >>tmp.asm
echo macro xtrn    smb,arg,nm { extrn '__imp__' # `smb # '@' # `arg as nm:DWORD } >>tmp.asm
echo macro oalxtrn smb,nm     { extrn '__imp__' # `smb as nm:DWORD } >>tmp.asm
echo macro thnk    nm         { nm equ [nm] }     >>tmp.asm
echo include 'src\eff.inc'                        >>tmp.asm
echo include 'src\fasm.asm'                       >>tmp.asm
"%UF_FASM%\fasm" tmp.asm oalufmod.obj
echo UF_OUTPUT          equ DIRECTSOUND            >tmp.asm
echo UF_FREQ            equ %UF_FREQ%             >>tmp.asm
echo UF_RAMP            equ %UF_RAMP%             >>tmp.asm
echo UF_UFS             equ %UF_UFS%              >>tmp.asm
echo UF_MODE            equ %UF_MODE%             >>tmp.asm
echo UF_FMT             equ %UF_FMT%              >>tmp.asm
echo VB6                equ 0                     >>tmp.asm
echo PBASIC             equ 0                     >>tmp.asm
echo EBASIC             equ 0                     >>tmp.asm
echo BLITZMAX           equ 0                     >>tmp.asm
echo NOLINKER           equ 0                     >>tmp.asm
echo DllEntry           equ _DllEntry@12          >>tmp.asm
echo uFMOD_DSPlaySong   equ _uFMOD_DSPlaySong@16  >>tmp.asm
echo uFMOD_Jump2Pattern equ _uFMOD_Jump2Pattern@4 >>tmp.asm
echo uFMOD_Pause        equ _uFMOD_Pause@0        >>tmp.asm
echo uFMOD_Resume       equ _uFMOD_Resume@0       >>tmp.asm
echo uFMOD_GetTime      equ _uFMOD_GetTime@0      >>tmp.asm
echo uFMOD_GetStats     equ _uFMOD_GetStats@0     >>tmp.asm
echo uFMOD_GetRowOrder  equ _uFMOD_GetRowOrder@0  >>tmp.asm
echo uFMOD_GetTitle     equ _uFMOD_GetTitle@0     >>tmp.asm
echo uFMOD_SetVolume    equ _uFMOD_SetVolume@4    >>tmp.asm
echo macro xtrn smb,arg,nm { extrn '__imp__' # `smb # '@' # `arg as nm:DWORD } >>tmp.asm
echo macro thnk nm         { nm equ [nm] }        >>tmp.asm
echo include 'src\eff.inc'                        >>tmp.asm
echo include 'src\fasm.asm'                       >>tmp.asm
"%UF_FASM%\fasm" tmp.asm dsufmod.obj
del tmp.asm
if not exist ufmod.obj goto TheEnd
if %UF_FMT%==DLL goto MkDll

:MkLb
if %UF_FMT%==OBJ goto TheEnd
if not exist "%UF_LINK%\link.exe" goto Err1
"%UF_LINK%\link" -lib /NOLOGO /OUT:ufmod.lib    ufmod.obj
"%UF_LINK%\link" -lib /NOLOGO /OUT:oalufmod.lib oalufmod.obj
"%UF_LINK%\link" -lib /NOLOGO /OUT:dsufmod.lib  dsufmod.obj
del *.obj
goto TheEnd

:MkDll
if not exist "%UF_LINK%\link.exe" goto Err1
if not exist "%UF_IMPS%\kernel32.lib" goto Err5
if not exist "%UF_IMPS%\winmm.lib" goto Err5
if not exist "%UF_IMPS%\dsound.lib" goto Err5
SET UF_ASM=/NOLOGO /SUBSYSTEM:WINDOWS /DLL /ENTRY:DllEntry /DEF:src\
"%UF_LINK%\link" %UF_ASM%ufmod.def    ufmod.obj    "%UF_IMPS%\kernel32.lib" "%UF_IMPS%\winmm.lib"
"%UF_LINK%\link" %UF_ASM%oalufmod.def oalufmod.obj "%UF_IMPS%\kernel32.lib" ..\Examples\Masm32\OpenAL\openal32.lib
"%UF_LINK%\link" %UF_ASM%dsufmod.def  dsufmod.obj  "%UF_IMPS%\kernel32.lib" "%UF_IMPS%\dsound.lib"
del *.obj
del *.exp
goto TheEnd

:Err1
echo Couldn't find link.exe   in %UF_LINK%\
goto TheEnd
:Err2
echo Couldn't find ml.exe     in %UF_MASM%\bin\
goto TheEnd
:Err3
echo Couldn't find nasmw.exe  in %UF_NASM%\
goto TheEnd
:Err4
echo Couldn't find fasm.exe   in %UF_FASM%\
goto TheEnd
:Err5
echo Import libs not found in in %US_MASM%\lib\

:TheEnd
pause
@echo on
cls
