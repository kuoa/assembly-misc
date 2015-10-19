CC = mipsel-unknown-elf-gcc
AS = mipsel-unknown-elf-as
LD = mipsel-unknown-elf-ld
DU = mipsel-unknown-elf-objdump

SYS_OBJS = reset.o \
		   giet.o \
		   common.o \
		   ctx_handler.o \
		   drivers.o \
		   exc_handler.o \
		   irq_handler.o \
		   sys_handler.o

APP_OBJS = stdio.o main.o

GIET ?= ../../giet

SYS_PATH = $(GIET)/sys
APP_PATH = $(GIET)/app

SYS_CFLAGS = -Wall -ffreestanding -mno-gpopt -mips32 -I$(SYS_PATH) -I.
APP_CFLAGS = -Wall -ffreestanding -mno-gpopt -mips32 -I$(APP_PATH) -I.


all: sys.bin app.bin

sys.bin: $(SYS_OBJS)
	$(LD) -o $@ -T sys.ld $(SYS_OBJS)

reset.o: reset.s
	$(AS) -mips32 -o $@ $<

giet.o: giet.s
	$(AS) -mips32 -o giet.o $(SYS_PATH)/giet.s

%.o: $(SYS_PATH)/%.c
	$(CC) $(SYS_CFLAGS) -c -o $@ $<

app.bin: $(APP_OBJS)
	$(LD) -o $@ -T app.ld $(APP_OBJS)

main.o: main.c
	$(CC) $(APP_CFLAGS) -c -o $@ $<

stdio.o: $(APP_PATH)/stdio.c
	$(CC) $(APP_CFLAGS) -c -o $@ $<


#objdump make rule
objdump: $(SYS_OBJS:=.txt) $(APP_OBJS:=.txt) sys.bin.txt app.bin.txt

%.o.txt: %.o
	$(DU) -D $< > $@

%.bin.txt: %.bin
	$(DU) -D $< > $@


#objdump clean rule
cleanobj:
	rm -f $(SYS_OBJS:=.txt) $(APP_OBJS:=.txt) sys.bin.txt app.bin.txt


#general clean rule
clean:
	rm -f *.o *.bin proc0*;
	rm -f $(SYS_OBJS:=.txt) $(APP_OBJS:=.txt) sys.bin.txt app.bin.txt
