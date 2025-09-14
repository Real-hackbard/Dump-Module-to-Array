; FASM.ASM
; --------
; uFMOD public source code release.

; *** This stub allows compiling uFMOD sources using FASM (fasm.exe)

if UF_OUTPUT eq WINMM
	DRIVER_WINMM       = 1
	DRIVER_OPENAL      = 0
	DRIVER_DIRECTSOUND = 0
else
	if UF_OUTPUT eq OPENAL
		DRIVER_WINMM       = 0
		DRIVER_OPENAL      = 1
		DRIVER_DIRECTSOUND = 0
	else
		if UF_OUTPUT eq DIRECTSOUND
		else
			display 'UF_OUTPUT not specified (defaulting to DIRECTSOUND)',13,10
		end if
		DRIVER_WINMM       = 0
		DRIVER_OPENAL      = 0
		DRIVER_DIRECTSOUND = 1
	end if
end if

if UF_FREQ eq 44100
	FSOUND_MixRate = 44100
	FREQ_40HZ_p    = 1DB8Bh
	FREQ_40HZ_f    = 3B7160h
else
	if UF_FREQ eq 22050
		FSOUND_MixRate = 22050
		FREQ_40HZ_p    = 3B716h
		FREQ_40HZ_f    = 76E2C0h
	else
		if UF_FREQ eq 48000
		else
			display 'UF_FREQ not specified (defaulting to 48KHz)',13,10
		end if
		FSOUND_MixRate = 48000
		FREQ_40HZ_p    = 1B4E8h
		FREQ_40HZ_f    = 369D00h
	end if
end if

if UF_RAMP eq NONE
	RAMP_NONE       = 1
	volumerampsteps = 64
	volumeramps_pow = 6
else
	if UF_RAMP eq WEAK
		RAMP_NONE       = 0
		volumerampsteps = 16
		volumeramps_pow = 4
	else
		if UF_RAMP eq STRONG
		else
			display 'UF_RAMP not specified (defaulting to STRONG)',13,10
		end if
		RAMP_NONE       = 0
		volumerampsteps = 128
		volumeramps_pow = 7
	end if
end if

if UF_UFS eq ANSI
	UCODE = 0
else
	if UF_UFS eq UNICODE
		UCODE = 1
	else
		display 'UF_UFS not specified (defaulting to UNICODE)',13,10
		UCODE = 1
	end if
end if

if UF_MODE eq BENCHMARK
	BENCHMARK_ON = 1
	CHK4VALIDITY = 1
else
	if UF_MODE eq UNSAFE
		display 'WARNING! Unsafe mod is ON. Library may crash while loading damaged XM tracks!',13,10
		BENCHMARK_ON = 0
		CHK4VALIDITY = 0
	else
		BENCHMARK_ON = 0
		CHK4VALIDITY = 1
	end if
end if

if UF_FMT eq DLL
	FMT_DLL = 1
else
	FMT_DLL = 0
end if

include 'equs.inc'

if NOLINKER
else
	format MS COFF

	xtrn WaitForSingleObject, 8, WaitForSingleObject
	xtrn CloseHandle,         4, CloseHandle
	xtrn CreateThread,       24, CreateThread
	xtrn SetThreadPriority,   8, SetThreadPriority
	xtrn HeapAlloc,          12, HeapAlloc
	xtrn HeapCreate,         12, HeapCreate
	xtrn HeapDestroy,         4, HeapDestroy
	xtrn Sleep,               4, Sleep

	if DRIVER_WINMM
		xtrn waveOutClose,            4, waveOutClose
		xtrn waveOutGetPosition,     12, waveOutGetPosition
		xtrn waveOutOpen,            24, waveOutOpen
		xtrn waveOutPrepareHeader,   12, waveOutPrepareHeader
		xtrn waveOutReset,            4, waveOutReset
		xtrn waveOutUnprepareHeader, 12, waveOutUnprepareHeader
		xtrn waveOutWrite,           12, waveOutWrite
	end if

	if DRIVER_OPENAL
		if BLITZMAX
			extrn '_pub_openal_alBufferData' as alBufferData:DWORD
			extrn '_pub_openal_alDeleteBuffers' as alDeleteBuffers:DWORD
			extrn '_pub_openal_alGenBuffers' as alGenBuffers:DWORD
			extrn '_pub_openal_alGetError' as alGetError:DWORD
			extrn '_pub_openal_alGetSourcei' as alGetSourcei:DWORD
			extrn '_pub_openal_alSourcei' as alSourcei:DWORD
			extrn '_pub_openal_alSourcePlay' as alSourcePlay:DWORD
			extrn '_pub_openal_alSourceQueueBuffers' as alSourceQueueBuffers:DWORD
			extrn '_pub_openal_alSourceStop' as alSourceStop:DWORD
			extrn '_pub_openal_alSourceUnqueueBuffers' as alSourceUnqueueBuffers:DWORD
		else
			oalxtrn alBufferData,           alBufferData
			oalxtrn alDeleteBuffers,        alDeleteBuffers
			oalxtrn alGenBuffers,           alGenBuffers
			oalxtrn alGetError,             alGetError
			oalxtrn alGetSourcei,           alGetSourcei
			oalxtrn alSourcei,              alSourcei
			oalxtrn alSourcePlay,           alSourcePlay
			oalxtrn alSourceQueueBuffers,   alSourceQueueBuffers
			oalxtrn alSourceStop,           alSourceStop
			oalxtrn alSourceUnqueueBuffers, alSourceUnqueueBuffers
		end if
	end if

	if XM_FILE_ON
		if UCODE
			xtrn CreateFileW, 28, CreateFile
		else
			xtrn CreateFileA, 28, CreateFile
		end if
		xtrn ReadFile,       20, ReadFile
		xtrn SetFilePointer, 16, SetFilePointer
	end if

	if XM_RC_ON
		xtrn FindResourceA, 12, FindResource
		xtrn LoadResource,   8, LoadResource
		xtrn SizeofResource, 8, SizeofResource
	end if

	if PBASIC
		extrn _PB_StringBase
	end if

	section '.text' code readable executable
end if

thnk WaitForSingleObject
thnk CloseHandle
thnk CreateThread
thnk SetThreadPriority
thnk HeapAlloc
thnk HeapCreate
thnk HeapDestroy
thnk Sleep
thnk waveOutClose
thnk waveOutGetPosition
thnk waveOutOpen
thnk waveOutPrepareHeader
thnk waveOutReset
thnk waveOutUnprepareHeader
thnk waveOutWrite
thnk alBufferData
thnk alDeleteBuffers
thnk alGenBuffers
thnk alGetError
thnk alGetSourcei
thnk alSourcei
thnk alSourcePlay
thnk alSourceQueueBuffers
thnk alSourceStop
thnk alSourceUnqueueBuffers
thnk CreateFile
thnk ReadFile
thnk WriteFile
thnk SetFilePointer
thnk FindResource
thnk LoadResource
thnk SizeofResource

OFFSET equ
PTR    equ
endif  equ end if

macro EXPORTcc flag*, symbol* {
	if flag
		PUBLIC symbol
		symbol:
	end if
}

if BLITZMAX
	PUBLIC uFMOD_FreeSong
	if DRIVER_DIRECTSOUND
		PUBLIC _BB_DSPlayMem
		_BB_DSPlayMem:
			or DWORD PTR [esp+12],1
		PUBLIC _BB_DSPlayFile
		_BB_DSPlayFile:
			or DWORD PTR [esp+12],2
			jmp uFMOD_DSPlaySong
		; EP routine for BlitzMax
		PUBLIC ___bb_dsufmod_dsufmod_
		PUBLIC ___bb_dsufmod_dsufmod
		___bb_dsufmod_dsufmod_:
		___bb_dsufmod_dsufmod:
	end if
	if DRIVER_OPENAL
		PUBLIC _BB_OALPlayMem
		_BB_OALPlayMem:
			or DWORD PTR [esp+12],1
		PUBLIC _BB_OALPlayFile
		_BB_OALPlayFile:
			or DWORD PTR [esp+12],2
			jmp uFMOD_OALPlaySong
		; EP routine for BlitzMax
		PUBLIC ___bb_oalufmod_oalufmod_
		PUBLIC ___bb_oalufmod_oalufmod
		___bb_oalufmod_oalufmod_:
		___bb_oalufmod_oalufmod:
	end if
	if DRIVER_WINMM
		PUBLIC _BB_PlayMem
		_BB_PlayMem:
			or DWORD PTR [esp+12],1
		PUBLIC _BB_PlayFile
		_BB_PlayFile:
			or DWORD PTR [esp+12],2
			jmp uFMOD_PlaySong
		; EP routine for BlitzMax
		PUBLIC ___bb_ufmod_ufmod_
		PUBLIC ___bb_ufmod_ufmod
		___bb_ufmod_ufmod_:
		___bb_ufmod_ufmod:
	end if
	xor eax,eax
	ret
end if

include 'ufmod.asm'
include 'core.asm'

if NOLINKER
	section '.bss' readable writeable
else
	section '.bss' readable writeable align 16
end if

_mod          = $
              rb uF_MOD_size
mmt           rd 3
hHeap         dd ?
hThread       dd ?
hWaveOut      dd ?
uFMOD_FillBlk dd ?
SW_Exit       dd ?
MixBuf        rb FSOUND_BlockSize*8
ufmod_noloop  db ?
ufmod_pause_  db ?
mix_endflag   rb 2
mmf           rd 4
ufmod_vol     dd ?
uFMOD_fopen   dd ?
uFMOD_fread   dd ?
uFMOD_fclose  dd ?
if DRIVER_WINMM
	         dd ?
	databuf  rd FSOUND_BufferSize
	MixBlock rb uF_WMMBlock_size
end if
if DRIVER_OPENAL
	databuf  rd totalblocks
end if
if INFO_API_ON
	RealBlock dd ?
	time_ms   dd ?
	tInfo     rb uF_STATS_size*totalblocks
	if UCODE
		szTtl rb 44
	else
		szTtl rb 24
	end if
end if
DummySamp rb uF_SAMP_size
if BENCHMARK_ON
	bench_t_lo dd ?
	PUBLIC _uFMOD_tsc
	_uFMOD_tsc dd ?
end if
