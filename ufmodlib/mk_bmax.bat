@echo off
rem Make the uFMOD modules for BlitzMax
rem Target OS: Win32

rem *** CONFIG START
rem *** (Check the Readme docs for a complete reference
rem *** on configuring the following options)

rem Pathes:
SET UF_FASM=C:\tools\fasm
SET UF_ARCH=ar

rem Select mixing rate: 22050, 44100 or 48000 (22.05 KHz, 44.1 KHz or 48 KHz)
SET UF_FREQ=48000

rem Set volume ramping mode (interpolation): NONE, WEAK or STRONG
SET UF_RAMP=STRONG

rem Set build mode: NORMAL or UNSAFE
SET UF_MODE=NORMAL
rem *** CONFIG END

if not exist "%UF_FASM%\fasm.exe" goto Err1
echo UF_OUTPUT          equ WINMM                   >tmp.asm
echo UF_FREQ            equ %UF_FREQ%              >>tmp.asm
echo UF_RAMP            equ %UF_RAMP%              >>tmp.asm
echo UF_UFS             equ ANSI                   >>tmp.asm
echo UF_MODE            equ %UF_MODE%              >>tmp.asm
echo UF_FMT             equ 0                      >>tmp.asm
echo VB6                equ 0                      >>tmp.asm
echo PBASIC             equ 0                      >>tmp.asm
echo EBASIC             equ 0                      >>tmp.asm
echo BLITZMAX           equ 1                      >>tmp.asm
echo NOLINKER           equ 0                      >>tmp.asm
echo uFMOD_Jump2Pattern equ _uFMOD_Jump2Pattern    >>tmp.asm
echo uFMOD_Pause        equ _uFMOD_Pause           >>tmp.asm
echo uFMOD_Resume       equ _uFMOD_Resume          >>tmp.asm
echo uFMOD_GetTime      equ _uFMOD_GetTime         >>tmp.asm
echo uFMOD_GetStats     equ _uFMOD_GetStats        >>tmp.asm
echo uFMOD_GetRowOrder  equ _uFMOD_GetRowOrder     >>tmp.asm
echo uFMOD_GetTitle     equ _uFMOD_GetTitle        >>tmp.asm
echo uFMOD_SetVolume    equ _uFMOD_SetVolume       >>tmp.asm
echo uFMOD_FreeSong     equ _BB_Stop               >>tmp.asm
echo macro xtrn smb,arg,nm { extrn '__imp__' # `smb # '@' # `arg as nm:DWORD } >>tmp.asm
echo macro thnk nm         { nm equ [nm] }         >>tmp.asm
echo include 'src\eff.inc'                         >>tmp.asm
echo include 'src\fasm.asm'                        >>tmp.asm
"%UF_FASM%\fasm" tmp.asm ufmod.o
echo UF_OUTPUT          equ OPENAL                  >tmp.asm
echo UF_FREQ            equ %UF_FREQ%              >>tmp.asm
echo UF_RAMP            equ %UF_RAMP%              >>tmp.asm
echo UF_UFS             equ ANSI                   >>tmp.asm
echo UF_MODE            equ %UF_MODE%              >>tmp.asm
echo UF_FMT             equ 0                      >>tmp.asm
echo VB6                equ 0                      >>tmp.asm
echo PBASIC             equ 0                      >>tmp.asm
echo EBASIC             equ 0                      >>tmp.asm
echo BLITZMAX           equ 1                      >>tmp.asm
echo NOLINKER           equ 0                      >>tmp.asm
echo uFMOD_Jump2Pattern equ _uFMOD_OALJump2Pattern >>tmp.asm
echo uFMOD_Pause        equ _uFMOD_OALPause        >>tmp.asm
echo uFMOD_Resume       equ _uFMOD_OALResume       >>tmp.asm
echo uFMOD_GetTime      equ _uFMOD_OALGetTime      >>tmp.asm
echo uFMOD_GetStats     equ _uFMOD_OALGetStats     >>tmp.asm
echo uFMOD_GetRowOrder  equ _uFMOD_OALGetRowOrder  >>tmp.asm
echo uFMOD_GetTitle     equ _uFMOD_OALGetTitle     >>tmp.asm
echo uFMOD_SetVolume    equ _uFMOD_OALSetVolume    >>tmp.asm
echo uFMOD_FreeSong     equ _BB_OALStop            >>tmp.asm
echo macro xtrn smb,arg,nm { extrn '__imp__' # `smb # '@' # `arg as nm:DWORD } >>tmp.asm
echo macro thnk nm         { nm equ [nm] }         >>tmp.asm
echo include 'src\eff.inc'                         >>tmp.asm
echo include 'src\fasm.asm'                        >>tmp.asm
"%UF_FASM%\fasm" tmp.asm oalufmod.o
echo UF_OUTPUT          equ DIRECTSOUND             >tmp.asm
echo UF_FREQ            equ %UF_FREQ%              >>tmp.asm
echo UF_RAMP            equ %UF_RAMP%              >>tmp.asm
echo UF_UFS             equ ANSI                   >>tmp.asm
echo UF_MODE            equ %UF_MODE%              >>tmp.asm
echo UF_FMT             equ 0                      >>tmp.asm
echo VB6                equ 0                      >>tmp.asm
echo PBASIC             equ 0                      >>tmp.asm
echo EBASIC             equ 0                      >>tmp.asm
echo BLITZMAX           equ 1                      >>tmp.asm
echo NOLINKER           equ 0                      >>tmp.asm
echo uFMOD_Jump2Pattern equ _uFMOD_DSJump2Pattern  >>tmp.asm
echo uFMOD_Pause        equ _uFMOD_DSPause         >>tmp.asm
echo uFMOD_Resume       equ _uFMOD_DSResume        >>tmp.asm
echo uFMOD_GetTime      equ _uFMOD_DSGetTime       >>tmp.asm
echo uFMOD_GetStats     equ _uFMOD_DSGetStats      >>tmp.asm
echo uFMOD_GetRowOrder  equ _uFMOD_DSGetRowOrder   >>tmp.asm
echo uFMOD_GetTitle     equ _uFMOD_DSGetTitle      >>tmp.asm
echo uFMOD_SetVolume    equ _uFMOD_DSSetVolume     >>tmp.asm
echo uFMOD_FreeSong     equ _BB_DSStop             >>tmp.asm
echo macro xtrn smb,arg,nm { extrn '__imp__' # `smb # '@' # `arg as nm:DWORD } >>tmp.asm
echo macro thnk nm         { nm equ [nm] }         >>tmp.asm
echo include 'src\eff.inc'                         >>tmp.asm
echo include 'src\fasm.asm'                        >>tmp.asm
"%UF_FASM%\fasm" tmp.asm dsufmod.o
del tmp.asm
if not exist ufmod.o goto TheEnd
"%UF_ARCH%" rc ufmod.release.win32.a    ufmod.o
"%UF_ARCH%" rc oalufmod.release.win32.a oalufmod.o
"%UF_ARCH%" rc dsufmod.release.win32.a  dsufmod.o
copy ufmod.release.win32.a    ufmod.release.win32.x86.a
copy oalufmod.release.win32.a oalufmod.release.win32.x86.a
copy dsufmod.release.win32.a  dsufmod.release.win32.x86.a
del *.o
goto TheEnd
:Err1
echo Couldn't find fasm.exe in %UF_FASM%\
:TheEnd
pause
@echo on
cls
