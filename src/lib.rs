#![feature(asm)]
#![feature(naked_functions)]
#![feature(start)]

#![no_std]

extern crate rs64_periph;

use rs64_periph::pif;

#[no_mangle]
pub unsafe extern "C" fn __rust_entry() {
    pif::disable_pif_reset();

    extern "C" {
         fn entry();
    }

    entry();
}

#[link_section = ".boot.text"]
#[no_mangle]
#[naked]
#[start]
pub unsafe extern  "C" fn __start() {
    asm!(
r##"
.extern __stack_top
.extern __rust_entry
.extern _gp
    lui    $$sp, %hi(__stack_top)
    ori    $$sp, $$sp, %lo(__stack_top)

    lui    $$gp, %hi(_gp)
    ori    $$gp, $$gp, %lo(_gp)

    jal    __rust_entry

__hang:
    b      __hang
"##
    );
}
