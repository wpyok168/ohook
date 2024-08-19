OPT=-Os -Wall
CFLAGS=-fno-ident
LDFLAGS=-L. -nostartfiles -nostdlib -lkernel32 -lshlwapi -ladvapi32 -Wl,--exclude-all-symbols,--enable-stdcall-fixup,--dynamicbase,--nxcompat,--subsystem,windows:6.0

PREFIX32=C:/mingw32/bin/
PREFIX64=C:/mingw64/bin/

CC32=gcc -Wl,-e_DllMain -municode
CC64=gcc -Wl,-eDllMain -municode

all: sppc32.dll sppc64.dll sppcplus32.dll sppcplus64.dll

sppc32.dll: sppc.c sppc32.res.o libsppcs32.a
	$(PREFIX32)$(CC32) $(OPT) $< sppc.def sppc32.res.o -shared -o $@ $(CFLAGS) $(LDFLAGS) -lsppcs32
	strip -s $@

sppc64.dll: sppc.c sppc64.res.o libsppcs64.a
	$(PREFIX64)$(CC64) $(OPT) $< sppc.def sppc64.res.o -shared -o $@ $(CFLAGS) $(LDFLAGS) -lsppcs64
	strip -s $@

sppcplus32.dll: sppc.c sppcplus32.res.o libsppcs32.a
	$(PREFIX32)$(CC32) -DPLUS_BUILD $(OPT) $< sppc.def sppcplus32.res.o -shared -o $@ $(CFLAGS) $(LDFLAGS) -lsppcs32
	strip -s $@

sppcplus64.dll: sppc.c sppcplus64.res.o libsppcs64.a
	$(PREFIX64)$(CC64) -DPLUS_BUILD $(OPT) $< sppc.def sppcplus64.res.o -shared -o $@ $(CFLAGS) $(LDFLAGS) -lsppcs64
	strip -s $@

sppc32.res.o: sppc.rc
	$(PREFIX32)windres --codepage=65001 $< $@

sppc64.res.o: sppc.rc
	$(PREFIX64)windres --codepage=65001 $< $@

sppcplus32.res.o: sppc.rc
	$(PREFIX32)windres --codepage=65001 -DPLUS_BUILD $< $@

sppcplus64.res.o: sppc.rc
	$(PREFIX64)windres --codepage=65001 -DPLUS_BUILD $< $@

libsppcs32.a:
	$(PREFIX32)dlltool -k -dsppcs32.def -llibsppcs32.a

libsppcs64.a:
	$(PREFIX64)dlltool -k -dsppcs64.def -llibsppcs64.a

clean:
	rm -f *.dll *.res.o *.a
