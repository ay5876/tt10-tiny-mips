import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_fetch_loop(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="us").start())

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    await ClockCycles(dut.clk, 30)

    seen = set()
    for _ in range(200):
        seen.add(int(dut.uo_out.value))  # uo_out = adr
        await ClockCycles(dut.clk, 1)

    assert 0 in seen and 1 in seen and 2 in seen and 3 in seen
