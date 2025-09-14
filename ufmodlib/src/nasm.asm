; NASM.ASM
; --------
; uFMOD public source code release.

; *** This stub allows compiling uFMOD sources using NASM (nasmw.exe)

; %error directive in NASM causes multiple prompts to appear due to
; multiple passes :( So, we'd better avoid using %error.

ifdef OMF
	COFF EQU 0
	[segment text CLASS=CODE align=4 USE32]
else
	COFF EQU 1
	[segment .text align=4]
endif

ifdef WINMM
	DRIVER_WINMM       EQU 1
	DRIVER_OPENAL      EQU 0
	DRIVER_DIRECTSOUND EQU 0
else
	ifdef OPENAL
		DRIVER_WINMM       EQU 0
		DRIVER_OPENAL      EQU 1
		DRIVER_DIRECTSOUND EQU 0
	else
		DRIVER_WINMM       EQU 0
		DRIVER_OPENAL      EQU 0
		DRIVER_DIRECTSOUND EQU 1
	endif
endif

ifdef NONE
	RAMP_NONE       EQU 1
	volumerampsteps EQU 64
	volumeramps_pow EQU 6
else
	ifdef WEAK
		RAMP_NONE       EQU 0
		volumerampsteps EQU 16
		volumeramps_pow EQU 4
	else
		RAMP_NONE       EQU 0
		volumerampsteps EQU 128
		volumeramps_pow EQU 7
	endif
endif

ifdef f44100
	FSOUND_MixRate EQU 44100
	FREQ_40HZ_p    EQU 1DB8Bh
	FREQ_40HZ_f    EQU 3B7160h
else
	ifdef f22050
		FSOUND_MixRate EQU 22050
		FREQ_40HZ_p    EQU 3B716h
		FREQ_40HZ_f    EQU 76E2C0h
	else
		FSOUND_MixRate EQU 48000
		FREQ_40HZ_p    EQU 1B4E8h
		FREQ_40HZ_f    EQU 369D00h
	endif
endif

ifdef ANSI
	UCODE EQU 0
else
	UCODE EQU 1
endif

ifdef BENCHMARK
	BENCHMARK_ON EQU 1
	CHK4VALIDITY EQU 1
else
	ifdef UNSAFE
		BENCHMARK_ON EQU 0
		CHK4VALIDITY EQU 0
	else
		BENCHMARK_ON EQU 0
		CHK4VALIDITY EQU 1
	endif
endif

ifdef PUREBASIC
	PBASIC EQU 1
	EXTERN _PB_StringBase
else
	PBASIC EQU 0
endif

ifdef VISUALBASIC
	VB6 EQU 1
else
	VB6 EQU 0
endif

ifdef EBAS
	EBASIC EQU 1
else
	EBASIC EQU 0
endif

ifdef DLL
	FMT_DLL EQU 1
else
	FMT_DLL EQU 0
endif

BLITZMAX EQU 0

%include "eff.inc"
%include "equs.inc"

if COFF
%define DllEntry _DllEntry@12
%define uFMOD_PlaySong _uFMOD_PlaySong@12
%define uFMOD_DSPlaySong _uFMOD_DSPlaySong@16
%define uFMOD_OALPlaySong _uFMOD_OALPlaySong@16
%define uFMOD_Pause _uFMOD_Pause@0
%define uFMOD_Resume _uFMOD_Resume@0
%define uFMOD_GetTime _uFMOD_GetTime@0
%define uFMOD_GetStats _uFMOD_GetStats@0
%define uFMOD_GetTitle _uFMOD_GetTitle@0
%define uFMOD_SetVolume _uFMOD_SetVolume@4
%define uFMOD_GetRowOrder _uFMOD_GetRowOrder@0
%define uFMOD_Jump2Pattern _uFMOD_Jump2Pattern@4

EXTERN __imp__WaitForSingleObject@8
%define WaitForSingleObject [__imp__WaitForSingleObject@8]
EXTERN __imp__CloseHandle@4
%define CloseHandle [__imp__CloseHandle@4]
EXTERN __imp__CreateThread@24
%define CreateThread [__imp__CreateThread@24]
EXTERN __imp__SetThreadPriority@8
%define SetThreadPriority [__imp__SetThreadPriority@8]
EXTERN __imp__HeapAlloc@12
%define HeapAlloc [__imp__HeapAlloc@12]
EXTERN __imp__HeapCreate@12
%define HeapCreate [__imp__HeapCreate@12]
EXTERN __imp__HeapDestroy@4
%define HeapDestroy [__imp__HeapDestroy@4]
EXTERN __imp__Sleep@4
%define Sleep [__imp__Sleep@4]

if DRIVER_WINMM
	EXTERN __imp__waveOutClose@4
	%define waveOutClose [__imp__waveOutClose@4]
	EXTERN __imp__waveOutGetPosition@12
	%define waveOutGetPosition [__imp__waveOutGetPosition@12]
	EXTERN __imp__waveOutOpen@24
	%define waveOutOpen [__imp__waveOutOpen@24]
	EXTERN __imp__waveOutPrepareHeader@12
	%define waveOutPrepareHeader [__imp__waveOutPrepareHeader@12]
	EXTERN __imp__waveOutReset@4
	%define waveOutReset [__imp__waveOutReset@4]
	EXTERN __imp__waveOutUnprepareHeader@12
	%define waveOutUnprepareHeader [__imp__waveOutUnprepareHeader@12]
	EXTERN __imp__waveOutWrite@12
	%define waveOutWrite [__imp__waveOutWrite@12]
endif

if DRIVER_OPENAL
	EXTERN __imp__alBufferData
	%define alBufferData [__imp__alBufferData]
	EXTERN __imp__alDeleteBuffers
	%define alDeleteBuffers [__imp__alDeleteBuffers]
	EXTERN __imp__alGenBuffers
	%define alGenBuffers [__imp__alGenBuffers]
	EXTERN __imp__alGetError
	%define alGetError [__imp__alGetError]
	EXTERN __imp__alGetSourcei
	%define alGetSourcei [__imp__alGetSourcei]
	EXTERN __imp__alSourcei
	%define alSourcei [__imp__alSourcei]
	EXTERN __imp__alSourcePlay
	%define alSourcePlay [__imp__alSourcePlay]
	EXTERN __imp__alSourceQueueBuffers
	%define alSourceQueueBuffers [__imp__alSourceQueueBuffers]
	EXTERN __imp__alSourceStop
	%define alSourceStop [__imp__alSourceStop]
	EXTERN __imp__alSourceUnqueueBuffers
	%define alSourceUnqueueBuffers [__imp__alSourceUnqueueBuffers]
endif

if XM_FILE_ON
	if UCODE
		EXTERN __imp__CreateFileW@28
		%define CreateFile [__imp__CreateFileW@28]
	else
		EXTERN __imp__CreateFileA@28
		%define CreateFile [__imp__CreateFileA@28]
	endif
	EXTERN __imp__ReadFile@20
	%define ReadFile [__imp__ReadFile@20]
	EXTERN __imp__SetFilePointer@16
	%define SetFilePointer [__imp__SetFilePointer@16]
endif

if XM_RC_ON
	EXTERN __imp__FindResourceA@12
	%define FindResource [__imp__FindResourceA@12]
	EXTERN __imp__LoadResource@8
	%define LoadResource [__imp__LoadResource@8]
	EXTERN __imp__SizeofResource@8
	%define SizeofResource [__imp__SizeofResource@8]
endif
else
EXTERN WaitForSingleObject
EXTERN CloseHandle
EXTERN CreateThread
EXTERN SetThreadPriority
EXTERN HeapAlloc
EXTERN HeapCreate
EXTERN HeapDestroy
EXTERN Sleep

if DRIVER_WINMM
	EXTERN waveOutClose
	EXTERN waveOutGetPosition
	EXTERN waveOutOpen
	EXTERN waveOutPrepareHeader
	EXTERN waveOutReset
	EXTERN waveOutUnprepareHeader
	EXTERN waveOutWrite
endif

if DRIVER_OPENAL
	EXTERN alBufferData
	EXTERN alDeleteBuffers
	EXTERN alGenBuffers
	EXTERN alGetError
	EXTERN alGetSourcei
	EXTERN alSourcei
	EXTERN alSourcePlay
	EXTERN alSourceQueueBuffers
	EXTERN alSourceStop
	EXTERN alSourceUnqueueBuffers
endif

if XM_FILE_ON
	if UCODE
		EXTERN CreateFileW
		CreateFile EQU CreateFileW
	else
		EXTERN CreateFileA
		CreateFile EQU CreateFileA
	endif
	EXTERN ReadFile
	EXTERN SetFilePointer
endif

if XM_RC_ON
	EXTERN FindResourceA
	FindResource EQU FindResourceA
	EXTERN LoadResource
	EXTERN SizeofResource
endif
endif

%define PUBLIC GLOBAL
%define OFFSET
%define PTR

%macro EXPORTcc 2
	if %1
		GLOBAL %2
		%2:
	endif
%endmacro

if COFF
else
	[segment _TEXT CLASS=CODE align=4 USE32]
endif
include "ufmod.asm"
include "core.asm"

if COFF
	[segment .bss align=16]
else
	[segment _BSS CLASS=BSS align=16 USE32]
endif

_mod          resb uF_MOD_size
mmt           resd 3
hHeap         resd 1
hThread       resd 1
hWaveOut      resd 1
uFMOD_FillBlk resd 1
SW_Exit       resd 1
MixBuf        resb FSOUND_BlockSize*8
ufmod_noloop  resb 1
ufmod_pause_  resb 1
mix_endflag   resb 2
mmf           resd 4
ufmod_vol     resd 1
uFMOD_fopen   resd 1
uFMOD_fread   resd 1
uFMOD_fclose  resd 1
if DRIVER_WINMM
	         resd 1
	databuf  resd FSOUND_BufferSize
	MixBlock resb uF_WMMBlock_size
endif
if DRIVER_OPENAL
	databuf  resd totalblocks
endif
if INFO_API_ON
	RealBlock resd 1
	time_ms   resd 1
	tInfo     resb uF_STATS_size*totalblocks
	if UCODE
		szTtl resb 44
	else
		szTtl resb 24
	endif
endif
DummySamp resb uF_SAMP_size
if BENCHMARK_ON
	bench_t_lo resd 1
	GLOBAL _uFMOD_tsc
	_uFMOD_tsc resd 1
endif
