@echo off
rem This batch file attempts to compile the WINMM example.
rem Compiling it in this way makes the final executable a bit smaller.
rem Works only with Delphi versions 5-7. All newer versions aren't able
rem to compile the example from the command line. Use the IDE instead.

dcc32 -Q System.pas SysInit.pas -M -Y -Z -$D-
dcc32 -Q test.dpr -$O+
pause
cls
