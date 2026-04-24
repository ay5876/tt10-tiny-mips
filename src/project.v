`default_nettype none

// TinyTapeout top module MUST start with tt_um_
module tt_um_ay5876_tinymips (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire reset = ~rst_n;

    // MIPS memory interface (byte-wide)
    wire [7:0] memdata;
    wire       memread, memwrite;
    wire [7:0] adr, writedata;

    // Instantiate Brunvand Tiny MIPS core (your mips.v)
    mips #(.WIDTH(8), .REGBITS(3)) dut (
        .clk(clk),
        .reset(reset),
        .memdata(memdata),
        .memread(memread),
        .memwrite(memwrite),
        .adr(adr),
        .writedata(writedata)
    );

    // ----------------------------
    // Tiny ROM program (byte addressable)
    // Program at address 0: J 0
    // J opcode = 000010 => instruction = 0x08000000
    // Little-endian bytes: 00 00 00 08 at addresses 0..3
    // ----------------------------
    function automatic [7:0] rom_byte(input [7:0] a);
        begin
            case (a)
                8'd0: rom_byte = 8'h00;
                8'd1: rom_byte = 8'h00;
                8'd2: rom_byte = 8'h00;
                8'd3: rom_byte = 8'h08;
                default: rom_byte = 8'h00;
            endcase
        end
    endfunction

    // Combinational instruction/data read
    assign memdata = rom_byte(adr);

    // Expose address on output so test can verify fetch activity
    assign uo_out = adr;

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    wire _unused = &{ena, ui_in, uio_in, memread, memwrite, writedata, 1'b0};

endmodule

`default_nettype wire
