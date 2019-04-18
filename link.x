ENTRY(__start)

PHDRS {
    load PT_LOAD;
}

SECTIONS {
    . = 0x80001000;

    .text : {
        *(.boot.text)
        *(.text)
        *(.text*)
		*(.gnu.linkonce.t*)
    } :load

    .rodata : {
        *(.rodata*)
		*(.gnu.linkonce.r*)
    } :load

    .data  : {
        *(.data*)
        *(.gnu.linkonce.d*)
    } :load

    .bss (NOLOAD) : {
        *(COMMON)
        *(.bss)
        *(.gnu.linkonce.b*)
    }

    .stack (NOLOAD) : {
        __stack_bottom = .;
        . += 16384;
        __stack_top = .;
    }

	/DISCARD/ : {
        *(.MIPS.abiflags)
        *(.reginfo)
		*(.comment)
		*(.eh_frame)
	}
}

ASSERT(__start == 0x80001000, "Error: ___start not load base");
