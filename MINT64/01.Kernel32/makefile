# file		makefile
# date		2008/12/14
# author	kkamagui 
# brief		º¸È£ ¸ðµå Ä¿³ÎÀ» ºôµåÇÏ±â À§ÇÑ make ÆÄÀÏ

################################################################################
# ºôµå È¯°æ ¹× ±ÔÄ¢ ¼³Á¤ 
################################################################################
# ÄÄÆÄÀÏ·¯ ¹× ¸µÄ¿ Á¤ÀÇ
NASM32 = nasm
GCC32 = /opt/CrossCompiler/bin/x86_64-pc-linux-gcc -c -m32 -ffreestanding
LD32 =  /opt/CrossCompiler/bin/x86_64-pc-linux-ld -melf_i386 -T ../elf_i386.x -nostdlib -e Main -Ttext 0x10200

# ¹ÙÀÌ³Ê¸® ÀÌ¹ÌÁö »ý¼ºÀ» À§ÇÑ OBJCOPY ¿É¼Ç Á¤ÀÇ
OBJCOPY32 =  /opt/CrossCompiler/bin/x86_64-pc-linux-objcopy -j .text -j .data -j .rodata -j .bss -S -O binary

# µð·ºÅÍ¸® Á¤ÀÇ
OBJECTDIRECTORY = Temp
SOURCEDIRECTORY	= Source

################################################################################
# ºôµå Ç×¸ñ ¹× ºôµå ¹æ¹ý ¼³Á¤
################################################################################
# ±âº»ÀûÀ¸·Î ºôµå¸¦ ¼öÇàÇÒ ¸ñ·Ï
all: prepare Kernel32.bin

# ¿ÀºêÁ§Æ® ÆÄÀÏÀÌ À§Ä¡ÇÒ µð·ºÅÍ¸®¸¦ »ý¼º
prepare:
	mkdir -p $(OBJECTDIRECTORY)

# Ä¿³Î ¿£Æ®¸® Æ÷ÀÎÆ® ºôµå
$(OBJECTDIRECTORY)/EntryPoint.bin: $(SOURCEDIRECTORY)/EntryPoint.s
	$(NASM32) -o $@ $<

# Ä¿³ÎÀÇ C ¼Ò½º ÆÄÀÏ¿¡ ´ëÇÑ ÀÇÁ¸¼º Á¤º¸ »ý¼º
dep:
	@echo === Make Dependancy File ===
	make -C $(OBJECTDIRECTORY) -f ../makefile InternalDependency
	@echo === Dependancy Search Complete ===

# µð·ºÅÍ¸®¸¦ ¿ÀºêÁ§Æ® ÆÄÀÏ µð·ºÅÍ¸®·Î ÀÌµ¿ÇØ¼­ ÀÇÁ¸¼º ÆÄÀÏ ¹× ½ÇÇà ÆÄÀÏÀ» »ý¼º
ExecuteInternalBuild: dep
	make -C $(OBJECTDIRECTORY) -f ../makefile Kernel32.elf

# Ä¿³Î ÀÌ¹ÌÁö¸¦ ¹ÙÀÌ³Ê¸® ÆÄÀÏ·Î º¯È¯
$(OBJECTDIRECTORY)/Kernel32.elf.bin: ExecuteInternalBuild
	$(OBJCOPY32) $(OBJECTDIRECTORY)/Kernel32.elf $@

# ¿£Æ®¸® Æ÷ÀÎÆ®¿Í Ä¿³ÎÀ» ÇÕÃÄ¼­ º¸È£ ¸ðµå ¹ÙÀÌ³Ê¸® »ý¼º
Kernel32.bin: $(OBJECTDIRECTORY)/EntryPoint.bin $(OBJECTDIRECTORY)/Kernel32.elf.bin
	cat $^ > $@
		
# ¼Ò½º ÆÄÀÏÀ» Á¦¿ÜÇÑ ³ª¸ÓÁö ÆÄÀÏ Á¤¸®	
clean:
	rm -f *.bin
	rm -f $(OBJECTDIRECTORY)/*.*

################################################################################
# Make¿¡ ÀÇÇØ ´Ù½Ã È£ÃâµÇ´Â ºÎºÐ, Temp µð·ºÅÍ¸®¸¦ ±âÁØÀ¸·Î ¼öÇàµÊ
################################################################################
# ºôµåÇÒ C ¼Ò½º ÆÄÀÏ Á¤ÀÇ, Temp µð·ºÅÍ¸®¸¦ ±âÁØÀ¸·Î ¼³Á¤
CENTRYPOINTOBJECTFILE = Main.o
CSOURCEFILES = $(wildcard ../$(SOURCEDIRECTORY)/*.c)
ASSEMBLYSOURCEFILES = $(wildcard ../$(SOURCEDIRECTORY)/*.asm)
COBJECTFILES = $(subst Main.o, , $(notdir $(patsubst %.c,%.o,$(CSOURCEFILES))))
ASSEMBLYOBJECTFILES = $(notdir $(patsubst %.asm,%.o,$(ASSEMBLYSOURCEFILES)))

# .c ÆÄÀÏÀ» .o ÆÄÀÏ·Î ¹Ù²Ù´Â ±ÔÄ¢ Á¤ÀÇ
%.o: ../$(SOURCEDIRECTORY)/%.c
	$(GCC32) -c $<

# .asm ÆÄÀÏÀ» .o ÆÄÀÏ·Î ¹Ù²Ù´Â ±ÔÄ¢ Á¤ÀÇ
%.o: ../$(SOURCEDIRECTORY)/%.asm
	$(NASM32) -f elf32 -o $@ $<

# ½ÇÁ¦ ÀÇÁ¸¼º¿¡ °ü·ÃµÈ ÆÄÀÏÀ» »ý¼º
InternalDependency:
	$(GCC32) -MM $(CSOURCEFILES) > Dependency.dep

# ½ÇÁ¦ Ä¿³Î ÀÌ¹ÌÁö¸¦ ºôµå
Kernel32.elf: $(CENTRYPOINTOBJECTFILE) $(COBJECTFILES) $(ASSEMBLYOBJECTFILES)
	$(LD32) -o $@ $^

# ÇöÀç µð¸¯Åä¸®ÀÇ ÆÄÀÏ Áß, dependency ÆÄÀÏÀÌ ÀÖÀ¸¸é make¿¡ Æ÷ÇÔ	
ifeq (Dependency.dep, $(wildcard Dependency.dep))
include Dependency.dep
endif
