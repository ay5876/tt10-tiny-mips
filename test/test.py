import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

def try_read_uo_out_as_int(dut):
    """Return int value if uo_out has only 0/1 bits, else return None."""
    s = dut.uo_out.value.binstr.lower()   # e.g. "01010101" or "0x01x0zz"
    if ('x' in s) or ('z' in s):
        return None
    return int(s, 2)

@cocotb.test()
async def test_fetch_loop(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="us").start())

    # Reset
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 20)
    dut.rst_n.value = 1

    # Wait extra time for gate-level sim to settle (important!)
    await ClockCycles(dut.clk, 200)

    # Collect stable address samples (uo_out = adr)
    seen = set()
    for _ in range(1000):
        v = try_read_uo_out_as_int(dut)
        if v is not None:
            seen.add(v)
            # once we have 0..3, we're done
            if 0 in seen and 1 in seen and 2 in seen and 3 in seen:
                return
        await ClockCycles(dut.clk, 1)

    # If we got here, it never stabilized enough to see 0..3
    assert False, f"uo_out never showed stable 0..3. seen={sorted(seen)[:20]}"
