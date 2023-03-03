ISODIR=${PWD}/iso
BOOTDIR=${ISODIR}/boot
GRUBDIR=${BOOTDIR}/grub
CFG=${GRUBDIR}/grub.cfg
KERNEL=bare_bones

all: binary iso-img

binary:
	gprbuild -P bare_bones --config=zfp_rts/i686-elf.cgpr

iso-img: binary
	@echo "Building .iso image from ELF file..." 
	@mkdir -p ${GRUBDIR}
	@cp ${KERNEL}.elf ${BOOTDIR}/${KERNEL}.elf
	@echo 'set timeout=0'                    > ${CFG}
	@echo 'set default=0'                   >> ${CFG}
	@echo ''                                >> ${CFG}
	@echo 'menuentry "Ada Bare" {'          >> ${CFG}
	@echo "  multiboot /boot/${KERNEL}.elf" >> ${CFG}
	@echo '}'                               >> ${CFG}
	@grub-mkrescue --output=${KERNEL}.iso ${ISODIR}
	@rm -rf ${ISODIR}

.PHONY: clean clean-all

clean:
	rm -f ${KERNEL}.iso
	rm -f ${KERNEL}.elf
	gprclean -P bare_bones
	
clean-all:
	rm -f ${KERNEL}.iso
	rm -f ${KERNEL}.elf
	gprclean -P bare_bones -r
	
