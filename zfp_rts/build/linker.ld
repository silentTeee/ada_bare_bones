OUTPUT_FORMAT(elf32-i386)
/* Tell the linker which startup code to use, we do this as there is no way to do this (well not easily) from the GNAT tools. */
ENTRY (startup)
SECTIONS
{
    . = 0x00100000;

    .text : {
        *(.text)
    }

    .rodata ALIGN (0x1000) : {
        *(.rodata)
    }

    .data ALIGN (0x1000) : {
        *(.data)
    }

    .bss : {
        *(COMMON)
        *(.bss)
    }
}