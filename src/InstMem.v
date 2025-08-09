module InstMem(
    input  wire        clock,
    input  wire [31:0] address,
    output reg  [31:0] inst
);

    // 128 × 32-bit instruction memory
    reg [31:0] Mem [0:127];

    initial begin
        // load hex file, addresses 0 ? 6
        $readmemh("instructions.mem", Mem, 0, 37);
    end

    always @(posedge clock) begin
        inst <= Mem[address[31:2]];
    end
endmodule