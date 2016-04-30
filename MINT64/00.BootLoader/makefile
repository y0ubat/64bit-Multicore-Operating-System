all: BootLoader.bin

BootLoader.bin: BootLoader.asm
	nasm -o BootLoader.bin BootLoader.asm
	cp BootLoader.bin Disk.img
clean:
	rm -f BootLoader.bin 
