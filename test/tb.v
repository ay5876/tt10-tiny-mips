`timescale 1ns/1ps
`default_nettype none

module tb;

  reg clk;
  reg rst_n;
  reg ena;

  reg  [7:0] ui_in;
  wire [7:0] uo_out;

  reg  [7:0] uio_in;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Clock (100 kHz equivalent in sim, doesn't matter)
  initial clk = 0;
  always #5 clk = ~clk;

  // DUT
  tt_um_ay5876_tinymips user_project (
      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

  initial begin
    // init
    ena    = 1'b1;
    ui_in  = 8'h00;
    uio_in = 8'h00;

    // reset pulse
    rst_n = 1'b0;
    repeat (5) @(posedge clk);
    rst_n = 1'b1;

   // give cocotb plenty of time (gate-level sim is slower)
repeat (20000) @(posedge clk);
$finish;
  end

  // VCD dump (optional; cocotb will also generate one)
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

endmodule

`default_nettype wire
