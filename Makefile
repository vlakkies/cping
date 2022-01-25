#  Install directory
INSTDIR=/usr/local/bin

#  Windoze/Msys/PDCurses
ifeq "$(OS)" "Windows_NT"
cping.exe:cping.c
	gcc --std=gnu99 -Wall -o $@ $^ pdcurses.a -lpthread -lm
clean:
	rm cping.exe
#  All Unices
else
#  OSX
ifeq "$(shell uname)"  "Darwin"
CPING=cping.osx
$(CPING): cping.c
	clang --std=gnu99 -Wall -o $@ $^ -lncurses -lpthread -lm
install:$(CPING)
	cp -a $^ $(INSTDIR)/cping
	chown root $(INSTDIR)/cping
	chmod u+s $(INSTDIR)/cping
#  Linux rPi with piGPIO
else ifneq  "$(wildcard /usr/lib/libpigpio.so)" ""
CPING=cping.rpg
$(CPING): cping.c
	gcc --std=gnu99 -Wall -DpiGPIO -o $@ $^ -l:libncurses.a -l:libtinfo.a -lpigpio -lpthread -lm
install:$(CPING)
	cp -a $^ $(INSTDIR)/cping
	setcap cap_net_raw,cap_sys_rawio,cap_dac_override=ep $(INSTDIR)/cping
#  Linux rPi2
else ifeq "$(shell uname -m)"  "armv6l"
CPING=cping.rpi
$(CPING): cping.c
	gcc --std=gnu99 -Wall -o $@ $^ -l:libncurses.a -l:libtinfo.a -lpthread -lm
install:$(CPING)
	cp -a $^ $(INSTDIR)/cping
	setcap cap_net_raw=ep $(INSTDIR)/cping
#  Linux rPi3
else ifeq "$(shell uname -m)"  "armv7l"
CPING=cping.rpi
$(CPING): cping.c
	gcc --std=gnu99 -Wall -o $@ $^ -l:libncurses.a -l:libtinfo.a -lpthread -lm
install:$(CPING)
	cp -a $^ $(INSTDIR)/cping
	setcap cap_net_raw=ep $(INSTDIR)/cping
#  Linux
else
CPING=cping.lnx
$(CPING): cping.c
	gcc --std=gnu99 -Wall -o $@ $^ -l:libncurses.a -l:libtinfo.a -lpthread -lm
install:$(CPING)
	cp -a $^ $(INSTDIR)/cping
	setcap cap_net_raw=ep $(INSTDIR)/cping
endif
#  Clean
clean:
	rm $(CPING)
endif
