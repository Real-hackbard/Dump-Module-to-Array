; MASM.ASM
; --------
; uFMOD public source code release.

; *** This stub allows compiling uFMOD sources using MASM32 (ml.exe) or TASM (tasm32.exe)

.386
.model flat

; Autodetect target
COFF = 1
ifdef ??version
	COFF = 0
endif
ifdef OMF
	COFF = 0
endif

; TASM is supposed to handle echoes, but it may print 'em multiple times (due to multiple
; passes). So, we'd better echo warnings only in MASM.

DRIVER_DIRECTSOUND = 0
DRIVER_OPENAL      = 0
DRIVER_WINMM       = 0
ifdef WINMM
	DRIVER_WINMM = 1
else
	ifdef OPENAL
		DRIVER_OPENAL = 1
	else
		ifndef DIRECTSOUND
			if COFF
				echo UF_OUTPUT not specified (defaulting to DIRECTSOUND)
			endif
		endif
		DRIVER_DIRECTSOUND = 1
	endif
endif

ifdef f44100
	FSOUND_MixRate = 44100
	FREQ_40HZ_p    = 1DB8Bh
	FREQ_40HZ_f    = 3B7160h
else
	ifdef f22050
		FSOUND_MixRate = 22050
		FREQ_40HZ_p    = 3B716h
		FREQ_40HZ_f    = 76E2C0h
	else
		ifndef f48000
			if COFF
				echo UF_FREQ not specified (defaulting to 48KHz)
			endif
		endif
		FSOUND_MixRate = 48000
		FREQ_40HZ_p    = 1B4E8h
		FREQ_40HZ_f    = 369D00h
	endif
endif

RAMP_NONE = 0
ifdef NONE
	RAMP_NONE       = 1
	volumerampsteps = 64
	volumeramps_pow = 6
else
	ifdef WEAK
		volumerampsteps = 16
		volumeramps_pow = 4
	else
		ifndef STRONG
			if COFF
				echo UF_RAMP not specified (defaulting to STRONG)
			endif
		endif
		volumerampsteps = 128
		volumeramps_pow = 7
	endif
endif

UCODE = 1
ifdef ANSI
	UCODE = 0
else
	ifndef UNICODE
		if COFF
			echo UF_UFS not specified (defaulting to UNICODE)
		endif
	endif
endif

BENCHMARK_ON = 0
ifdef BENCHMARK
	BENCHMARK_ON = 1
endif

CHK4VALIDITY = 1
ifdef UNSAFE
	if COFF
		echo WARNING! Unsafe mod is ON. Library may crash while loading damaged XM tracks!
	endif
	CHK4VALIDITY = 0
endif

PBASIC = 0
ifdef PUREBASIC
	PBASIC = 1
	EXTRN _PB_StringBase:DWORD
endif

VB6 = 0
ifdef VISUALBASIC
	VB6 = 1
endif

EBASIC = 0
ifdef EBAS
	EBASIC = 1
endif

FMT_DLL = 0
ifdef DLL
	FMT_DLL = 1
endif

BLITZMAX = 0

include eff.inc
include equs.inc

if COFF
; MS COFF object format

	DllEntry EQU <_DllEntry@12>
	uFMOD_PlaySong EQU <_uFMOD_PlaySong@12>
	uFMOD_DSPlaySong EQU <_uFMOD_DSPlaySong@16>
	uFMOD_OALPlaySong EQU <_uFMOD_OALPlaySong@16>
	uFMOD_Jump2Pattern EQU <_uFMOD_Jump2Pattern@4>
	uFMOD_Pause EQU <_uFMOD_Pause@0>
	uFMOD_Resume EQU <_uFMOD_Resume@0>
	uFMOD_GetTime EQU <_uFMOD_GetTime@0>
	uFMOD_GetStats EQU <_uFMOD_GetStats@0>
	uFMOD_GetTitle EQU <_uFMOD_GetTitle@0>
	uFMOD_SetVolume EQU <_uFMOD_SetVolume@4>
	uFMOD_GetRowOrder EQU <_uFMOD_GetRowOrder@0>

	EXTERN __imp__WaitForSingleObject@8:DWORD
	WaitForSingleObject equ __imp__WaitForSingleObject@8
	EXTERN __imp__CloseHandle@4:DWORD
	CloseHandle equ __imp__CloseHandle@4
	EXTERN __imp__CreateThread@24:DWORD
	CreateThread equ __imp__CreateThread@24
	EXTERN __imp__SetThreadPriority@8:DWORD
	SetThreadPriority equ __imp__SetThreadPriority@8
	EXTERN __imp__HeapAlloc@12:DWORD
	HeapAlloc equ __imp__HeapAlloc@12
	EXTERN __imp__HeapCreate@12:DWORD
	HeapCreate equ __imp__HeapCreate@12
	EXTERN __imp__HeapDestroy@4:DWORD
	HeapDestroy equ __imp__HeapDestroy@4
	EXTERN __imp__Sleep@4:DWORD
	Sleep equ __imp__Sleep@4

	if DRIVER_WINMM
		EXTERN __imp__waveOutClose@4:DWORD
		waveOutClose equ __imp__waveOutClose@4
		EXTERN __imp__waveOutGetPosition@12:DWORD
		waveOutGetPosition equ __imp__waveOutGetPosition@12
		EXTERN __imp__waveOutOpen@24:DWORD
		waveOutOpen equ __imp__waveOutOpen@24
		EXTERN __imp__waveOutPrepareHeader@12:DWORD
		waveOutPrepareHeader equ __imp__waveOutPrepareHeader@12
		EXTERN __imp__waveOutReset@4:DWORD
		waveOutReset equ __imp__waveOutReset@4
		EXTERN __imp__waveOutUnprepareHeader@12:DWORD
		waveOutUnprepareHeader equ __imp__waveOutUnprepareHeader@12
		EXTERN __imp__waveOutWrite@12:DWORD
		waveOutWrite equ __imp__waveOutWrite@12
	endif

	if DRIVER_OPENAL
		EXTERN __imp__alBufferData:DWORD
		alBufferData equ __imp__alBufferData
		EXTERN __imp__alDeleteBuffers:DWORD
		alDeleteBuffers equ __imp__alDeleteBuffers
		EXTERN __imp__alGenBuffers:DWORD
		alGenBuffers equ __imp__alGenBuffers
		EXTERN __imp__alGetError:DWORD
		alGetError equ __imp__alGetError
		EXTERN __imp__alGetSourcei:DWORD
		alGetSourcei equ __imp__alGetSourcei
		EXTERN __imp__alSourcei:DWORD
		alSourcei equ __imp__alSourcei
		EXTERN __imp__alSourcePlay:DWORD
		alSourcePlay equ __imp__alSourcePlay
		EXTERN __imp__alSourceQueueBuffers:DWORD
		alSourceQueueBuffers equ __imp__alSourceQueueBuffers
		EXTERN __imp__alSourceStop:DWORD
		alSourceStop equ __imp__alSourceStop
		EXTERN __imp__alSourceUnqueueBuffers:DWORD
		alSourceUnqueueBuffers equ __imp__alSourceUnqueueBuffers
	endif

	if XM_RC_ON
		EXTERN __imp__FindResourceA@12:DWORD
		FindResource equ __imp__FindResourceA@12
		EXTERN __imp__LoadResource@8:DWORD
		LoadResource equ __imp__LoadResource@8
		EXTERN __imp__SizeofResource@8:DWORD
		SizeofResource equ __imp__SizeofResource@8
	endif

	if XM_FILE_ON
		if UCODE
			EXTERN __imp__CreateFileW@28:DWORD
			CreateFile equ __imp__CreateFileW@28
		else
			EXTERN __imp__CreateFileA@28:DWORD
			CreateFile equ __imp__CreateFileA@28
		endif
		EXTERN __imp__ReadFile@20:DWORD
		ReadFile equ __imp__ReadFile@20
		EXTERN __imp__SetFilePointer@16:DWORD
		SetFilePointer equ __imp__SetFilePointer@16
	endif

else
; Borland OMF format for Delphi 4 or later
; Take into account the following issues:
;    Delphi doesn't like name decoration!
;    Delphi doesn't like direct dllimport references!
;       (it preferes old style call [<jmp addr>])

EXTRN WaitForSingleObject:NEAR
EXTRN CloseHandle:NEAR
EXTRN CreateThread:NEAR
EXTRN SetThreadPriority:NEAR
EXTRN HeapAlloc:NEAR
EXTRN HeapCreate:NEAR
EXTRN HeapDestroy:NEAR
EXTRN Sleep:NEAR

if DRIVER_WINMM
	EXTRN waveOutClose:NEAR
	EXTRN waveOutGetPosition:NEAR
	EXTRN waveOutOpen:NEAR
	EXTRN waveOutPrepareHeader:NEAR
	EXTRN waveOutReset:NEAR
	EXTRN waveOutUnprepareHeader:NEAR
	EXTRN waveOutWrite:NEAR
endif

if DRIVER_OPENAL
	EXTRN alBufferData:NEAR
	EXTRN alDeleteBuffers:NEAR
	EXTRN alGenBuffers:NEAR
	EXTRN alGetError:NEAR
	EXTRN alGetSourcei:NEAR
	EXTRN alSourcei:NEAR
	EXTRN alSourcePlay:NEAR
	EXTRN alSourceQueueBuffers:NEAR
	EXTRN alSourceStop:NEAR
	EXTRN alSourceUnqueueBuffers:NEAR
endif

if XM_FILE_ON
	if UCODE
		EXTRN CreateFileW:NEAR
		CreateFile EQU CreateFileW
	else
		EXTRN CreateFileA:NEAR
		CreateFile EQU CreateFileA
	endif
	EXTRN ReadFile:NEAR
	EXTRN SetFilePointer:NEAR
endif

if XM_RC_ON
	EXTRN FindResourceA:NEAR
	FindResource EQU FindResourceA
	EXTRN LoadResource:NEAR
	EXTRN SizeofResource:NEAR
endif

endif

; FPU register stack
st0 TEXTEQU <st(0)>
st1 TEXTEQU <st(1)>

EXPORTcc MACRO flag:REQ, symbol:REQ
	if flag
		PUBLIC symbol
		symbol:
	endif
ENDM

.CODE
include ufmod.asm
include core.asm

.DATA?

; Don't change order!
_mod          = $
              db uF_MOD_size dup (?)
mmt           dd ?,?,?
hHeap         dd ?
hThread       dd ?
hWaveOut      dd ? ; HWAVEOUT
uFMOD_FillBlk dd ?
SW_Exit       dd ?
; mix buffer memory block (align 16!)
MixBuf        db FSOUND_BlockSize*8 dup (?)
ufmod_noloop  db ? ; enable/disable restart loop
ufmod_pause_  db ? ; pause/resume
mix_endflag   db ?,?
mmf           dd ?,?,?,?
ufmod_vol     dd ? ; global volume scale
; * LPCALLBACKS *
uFMOD_fopen   dd ?
uFMOD_fread   dd ?
uFMOD_fclose  dd ?
if DRIVER_WINMM
	         dd ? ; unused (align 16)
	databuf  dd FSOUND_BufferSize dup (?)
	MixBlock db uF_WMMBlock_size dup (?)
endif
if DRIVER_OPENAL
	databuf  dd totalblocks dup (?)
endif
if INFO_API_ON
	RealBlock dd ?
	time_ms   dd ?
	tInfo     db uF_STATS_size*totalblocks dup (?)
	; track title
	if UCODE
		szTtl db 44 dup (?)
	else
		szTtl db 24 dup (?)
	endif
endif
DummySamp db uF_SAMP_size dup (?)
if BENCHMARK_ON
	bench_t_lo dd ?
	PUBLIC _uFMOD_tsc
	_uFMOD_tsc dd ? ; a performance counter used in BENCHMARK mode
endif
end
