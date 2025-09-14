# Dump-Module-to-Array_

</br>

```ruby
Compiler    : Delphi10 Seattle, 10.1 Berlin, 10.2 Tokyo, 10.3 Rio, 10.4 Sydney, 11 Alexandria, 12 Athens
Components  : uFMOD.pas
Discription : Play Module from Array Code.
Last Update : 09/2025
License     : Freeware
```

</br>

This is an example of converting an XM Chiptune File into an [array](https://en.wikipedia.org/wiki/Array_(data_structure)) and implementing it in a code project. Choose your programming language and create a dump. You can then integrate the code into your project, play and control it with the [uFMOD library](https://ufmod.sourceforge.io/).

This is more advantageous than embedding an audio file in an executable and accessing it from the resources area. The executable is smaller and won't trigger virus alerts because it's data records, not an additional file.

Is useful for advanced users, willing to squeeze every single byte out of their applications. The general idea is to extract only those features you do mean to use in your application, recompile the uFMOD library from source and obtain the smallest possible footprint.

</br>

![Dump Module to Array](https://github.com/user-attachments/assets/d5b5e91f-a85a-40f2-a0fa-caceaf7505cb)

</br>

As you can see, the last parameter is expected to be a filename, specifying the XM file you plan to use in your application. Additional options:

* ### /Dm:  
  produces a hex dump from the given [XM file](https://en.wikipedia.org/wiki/XM_(file_format)), suitable for [MASM32](https://www.masm32.com/) and [TASM](https://www.ticalc.org/archives/files/fileinfo/250/25051.html). Neither of them have any use in Unix, but the syntax is also suitable for FASM and NASM. However, both [FASM](https://flatassembler.net/download.php) and [NASM](https://nasm32.com/) support embedding binary content from a file directly. So, the only real use of this option in Unix has to do with /M (see below).
* ### /Dd:
  and /Dc produce hex dumps in Pascal (Delphi, Kylix, FreePascal) or C/C++ format respectively.
* ### /Ds:
  generates a hex dump in [RCDATA](https://learn.microsoft.com/de-de/windows/win32/menurc/rcdata-resource) format, used in resource scripts. Some resource script compilers don't support the Microsoft's id RCDATA "filename" syntax. No real use in Unix.
Specify /Di to disable all the information functions: ```uFMOD_GetStats, uFMOD_GetRowOrder, uFMOD_GetTitle and uFMOD_GetTime```. Removing them reduces the library size and makes it somewhat faster.
* ### /Dp:
  removes uFMOD_Pause and uFMOD_Resume functions and makes [uFMOD](https://ufmod.sourceforge.io/) ignore the XM_SUSPENDED flag. If you don't plan to use pause/resume features, add this option to the command line and save some more bytes.
uFMOD_SetVolume not only makes the library bigger, but also consumes some additional CPU time. Just use /Dv to turn it off and recover some bytes and clock cycles ;)
* ### /Dj:
  disables the Jump2Pattern feature. This is an advanced feature, not used in most applications. Check the "Reducing the executable file size" section for more information on using Jump2Pattern.
Not going to play files - only memory arrays? Then, you'd probably like to use /Df in order to make the library smaller.
* ### /Dl:
  (lower-case letter L) makes uFMOD ignore the XM_NOLOOP flag (and makes the library smaller and faster, as expected).
Finally, a really insane optimization option is available only for assembly coders. There are some byte chunks inside every XM file, which are reserved for future use or just holding metadata (comments, adds and so on). /M marks all such 'holes' in the hex dump and makes them available for something more useful, like storing code and/or data right inside the XM track.

The above commands produce an assembly dump with all the 'holes' properly outlined and cleared by default. The EFF.INC header contains the XM effects actually used in the given XM file and some additional flags to disable pause/resume, volume control, Jump2Pattern, loading files and XM_NOLOOP. Copy EFF.INC to ufmodlib/src/ and recompile the library (check the following section for a quick guide). Enjoy your own extremely optimized uFMOD build, but keep in mind that it contains a subset of XM effects. So, it will play normally only the given XM file!

### Code Example:  
```pascal
const
   xm : array[1..12172] of Byte = (
     $45,$78,$74,$65,$6E,$64,$65,$64,$20,$4D,$6F,$64,$75,$6C,$65,$3A,
     $20,$43,$68,$69,$70,$65,$78,$32,$20,$52,$65,$6D,$69,$78,$20,$20,
     $20,$20,$20,$20,$20,$1A,$58,$4D,$4C,$69,$54,$45,$00,$00,$00,$00,
     $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$01,$14,$01,$00,$00,
     $05,$00,$00,$00,$16,$00,$04,$00,$30,$00,$01,$00,$06,$00,$7D,$00,
     ......
);

begin
   Ufmod_Playsong(@xm,length(xm),xm_memory);
   StatusBar1.Panels[0].Text := 'play';
   Timer1.Enabled := true;
```

</br>

# uFMOD:  
uFMOD (or µFMOD) is an open-source XM player library written in assembly language, intended for size- and speed-critical applications, click free, highly reliable, easy to use, multiplatform. Usage examples available for most popular programming languages and compilers.

### Main Features:  
* Extremely small size. According to specialized programming sites wasm.ru and Democoder.ru, uFMOD is the most compact XM player available. Moreover, it requires very little dynamic memory to run.
* High speed. It is able to perform smoothly, without buffer underrun, even in very slow environments.
* HiFi playback. uFMOD supports all standard XM effects and many non-standard. It uses linear interpolation and channel swapping to avoid clicks. Sampling rate: 22.05, 44.1 and 48 KHz for optimal performance on modern hardware.
* Support for ADPCM-compressed samples.
* Support for up to 64 channels.
* High reliability. It is safe to attempt playing damaged or otherwise corrupt XM files - uFMOD won't crash.
* Driver-independent volume control, pause/resume and other features for crossplatform development. The exactly same API is available for all of the supported platforms.
* Dependency-free. No additional libraries are needed. For instance, the Linux/OSS version is completely static and doesn't require the LIBC library. Win32 version don't use any CRT code either.
* The release includes XMStrip, a utility tool to reduce the size of an XM file. This tool can also attempt to recover damaged or corrupted XM files.

### Reducing the executable file size:  
Use Array to optimize the library and make it smaller.

When embedding the XM track directly into the executable or attaching it as a raw binary resource, it's sometimes worth it trying to optimize the XM itself. Modplug Player features ADPCM compression, which makes the XM somewhat smaller, but it's a lossy compression! Use XMStrip for lossless (in terms of sound quality) size optimization.

If you're sure all XM tracks your application is going to use are valid (not damaged or otherwise modified), rebuild the library in UNSAFE mode.

Use strip and [sstrip](https://www.muppetlabs.com/~breadbox/software/elfkickers.html) to remove unnecessary data introduced by the compiler/linker. Whole sections may sometimes be removed without breaking the executable.

Packers, such as [UPX](https://upx.github.io/), make executables smaller.

Take a look at "[A Whirlwind Tutorial on Creating Really Teensy ELF Executables for Linux](https://www.muppetlabs.com/~breadbox/software/tiny/teensy.html)" by Brian Raiter for additional size optimization tips (most tips are suitable for FreeBSD as well).


uFMOD Home : https://ufmod.sourceforge.io/  
XM Archive : https://modarchive.org/
