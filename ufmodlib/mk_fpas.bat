@echo off
rem Make the uFMOD libraries for FreePascal
rem Target OS: Win32

rem *** CONFIG START
rem *** Check the Readme docs for a complete reference
rem *** on configuring the following options

rem Pathes:
SET UF_FASM=C:\tools\fasm

rem Select mixing rate: 22050, 44100 or 48000 (22.05 KHz, 44.1 KHz or 48 KHz)
SET UF_FREQ=48000

rem Set volume ramping mode (interpolation): NONE, WEAK or STRONG
SET UF_RAMP=STRONG

rem Select strings encoding: ANSI or UNICODE
SET UF_UFS=ANSI

rem Set build mode: NORMAL or UNSAFE
SET UF_MODE=NORMAL
rem *** CONFIG END

if not exist "%UF_FASM%\fasm.exe" goto Err1
echo UF_OUTPUT          equ WINMM                  >tmp.asm
echo UF_FREQ            equ %UF_FREQ%             >>tmp.asm
echo UF_RAMP            equ %UF_RAMP%             >>tmp.asm
echo UF_UFS             equ %UF_UFS%              >>tmp.asm
echo UF_MODE            equ %UF_MODE%             >>tmp.asm
echo UF_FMT             equ 0                     >>tmp.asm
echo VB6                equ 0                     >>tmp.asm
echo PBASIC             equ 0                     >>tmp.asm
echo EBASIC             equ 0                     >>tmp.asm
echo BLITZMAX           equ 0                     >>tmp.asm
echo NOLINKER           equ 0                     >>tmp.asm
echo uFMOD_PlaySong     equ _uFMOD_PlaySong_12    >>tmp.asm
echo uFMOD_Jump2Pattern equ _uFMOD_Jump2Pattern_4 >>tmp.asm
echo uFMOD_Pause        equ _uFMOD_Pause_0        >>tmp.asm
echo uFMOD_Resume       equ _uFMOD_Resume_0       >>tmp.asm
echo uFMOD_GetTime      equ _uFMOD_GetTime_0      >>tmp.asm
echo uFMOD_GetStats     equ _uFMOD_GetStats_0     >>tmp.asm
echo uFMOD_GetRowOrder  equ _uFMOD_GetRowOrder_0  >>tmp.asm
echo uFMOD_GetTitle     equ _uFMOD_GetTitle_0     >>tmp.asm
echo uFMOD_SetVolume    equ _uFMOD_SetVolume_4    >>tmp.asm
echo macro xtrn smb,arg,nm { extrn `smb as nm:DWORD } >>tmp.asm
echo macro thnk nm         {}                         >>tmp.asm
echo include 'src\eff.inc'                        >>tmp.asm
echo include 'src\fasm.asm'                       >>tmp.asm
"%UF_FASM%\fasm" tmp.asm libufmod.o
echo UF_OUTPUT          equ OPENAL                 >tmp.asm
echo UF_FREQ            equ %UF_FREQ%             >>tmp.asm
echo UF_RAMP            equ %UF_RAMP%             >>tmp.asm
echo UF_UFS             equ %UF_UFS%              >>tmp.asm
echo UF_MODE            equ %UF_MODE%             >>tmp.asm
echo UF_FMT             equ 0                     >>tmp.asm
echo VB6                equ 0                     >>tmp.asm
echo PBASIC             equ 0                     >>tmp.asm
echo EBASIC             equ 0                     >>tmp.asm
echo BLITZMAX           equ 0                     >>tmp.asm
echo NOLINKER           equ 0                     >>tmp.asm
echo uFMOD_OALPlaySong  equ _uFMOD_OALPlaySong_16 >>tmp.asm
echo uFMOD_Jump2Pattern equ _uFMOD_Jump2Pattern_4 >>tmp.asm
echo uFMOD_Pause        equ _uFMOD_Pause_0        >>tmp.asm
echo uFMOD_Resume       equ _uFMOD_Resume_0       >>tmp.asm
echo uFMOD_GetTime      equ _uFMOD_GetTime_0      >>tmp.asm
echo uFMOD_GetStats     equ _uFMOD_GetStats_0     >>tmp.asm
echo uFMOD_GetRowOrder  equ _uFMOD_GetRowOrder_0  >>tmp.asm
echo uFMOD_GetTitle     equ _uFMOD_GetTitle_0     >>tmp.asm
echo uFMOD_SetVolume    equ _uFMOD_SetVolume_4    >>tmp.asm
echo macro xtrn    smb,arg,nm { extrn `smb as nm:DWORD } >>tmp.asm
echo macro oalxtrn smb,nm     { extrn `smb as nm:DWORD } >>tmp.asm
echo macro thnk    nm         {}                         >>tmp.asm
echo include 'src\eff.inc'                        >>tmp.asm
echo include 'src\fasm.asm'                       >>tmp.asm
"%UF_FASM%\fasm" tmp.asm liboalufmod.o
echo UF_OUTPUT          equ DIRECTSOUND            >tmp.asm
echo UF_FREQ            equ %UF_FREQ%             >>tmp.asm
echo UF_RAMP            equ %UF_RAMP%             >>tmp.asm
echo UF_UFS             equ %UF_UFS%              >>tmp.asm
echo UF_MODE            equ %UF_MODE%             >>tmp.asm
echo UF_FMT             equ 0                     >>tmp.asm
echo VB6                equ 0                     >>tmp.asm
echo PBASIC             equ 0                     >>tmp.asm
echo EBASIC             equ 0                     >>tmp.asm
echo BLITZMAX           equ 0                     >>tmp.asm
echo NOLINKER           equ 0                     >>tmp.asm
echo uFMOD_DSPlaySong   equ _uFMOD_DSPlaySong_16  >>tmp.asm
echo uFMOD_Jump2Pattern equ _uFMOD_Jump2Pattern_4 >>tmp.asm
echo uFMOD_Pause        equ _uFMOD_Pause_0        >>tmp.asm
echo uFMOD_Resume       equ _uFMOD_Resume_0       >>tmp.asm
echo uFMOD_GetTime      equ _uFMOD_GetTime_0      >>tmp.asm
echo uFMOD_GetStats     equ _uFMOD_GetStats_0     >>tmp.asm
echo uFMOD_GetRowOrder  equ _uFMOD_GetRowOrder_0  >>tmp.asm
echo uFMOD_GetTitle     equ _uFMOD_GetTitle_0     >>tmp.asm
echo uFMOD_SetVolume    equ _uFMOD_SetVolume_4    >>tmp.asm
echo macro xtrn    smb,arg,nm { extrn `smb as nm:DWORD } >>tmp.asm
echo macro thnk    nm         {}                         >>tmp.asm
echo include 'src\eff.inc'                        >>tmp.asm
echo include 'src\fasm.asm'                       >>tmp.asm
"%UF_FASM%\fasm" tmp.asm libdsufmod.o
del tmp.asm
goto TheEnd

:Err1
echo Couldn't find fasm.exe in %UF_FASM%\

:TheEnd
pause
@echo on
cls
