## How it works
This project integrates the Tiny MIPS processor (Brunvand-modified version of the multicycle MIPS from Harris & Harris / Brunvand material) into the TinyTapeout user-project wrapper.  
The wrapper provides a small byte-addressed ROM so the CPU can fetch instructions using the `memdata` bus and the address output `adr`. The instruction fetch occurs over four cycles (FETCH1–FETCH4) because the instruction register is filled one byte at a time.

## How to test
The cocotb test resets the design, runs the clock, and checks that the CPU repeatedly fetches bytes from addresses 0, 1, 2, and 3 (visible on `uo_out`, which is connected to `adr`). This confirms the instruction fetch loop is operating.

## External hardware
None.
