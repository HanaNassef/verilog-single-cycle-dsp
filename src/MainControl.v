`timescale 1ns / 1ps
module MainControl(
    input  wire [5:0] Opcode,
    output reg        RegDst,
    output reg        RegWrite,
    output reg        ALUSrc,
    output reg        MemtoReg,
    output reg        MemRead,
    output reg        MemWrite,
    output reg        Branch,
    output reg [1:0]  ALUOp,
    // DSP signals
    output reg        dsporALU,
    output reg [4:0]  dspcontrol
);

always @(*) begin
    // defaults
    RegDst     = 0;
    ALUSrc     = 0;
    MemtoReg   = 0;
    RegWrite   = 0;
    MemRead    = 0;
    MemWrite   = 0;
    Branch     = 0;
    ALUOp      = 2'b00;
    dsporALU   = 0;
    dspcontrol = 5'b00000;

    case (Opcode)
        6'd0: begin  // R-type ALU
            RegDst   = 1;
            RegWrite = 1;
            ALUOp    = 2'b10;
        end

        6'd35: begin // lw
            ALUSrc   = 1;
            MemtoReg = 1;
            RegWrite = 1;
            MemRead  = 1;
            ALUOp    = 2'b00;
        end

        6'd43: begin // sw
            ALUSrc   = 1;
            MemWrite = 1;
            ALUOp    = 2'b00;
        end

        6'd4: begin  // beq
            Branch   = 1;
            ALUOp    = 2'b01;
        end

        6'd8: begin  // addi (ADDED)
            ALUSrc   = 1;      // Use immediate value
            RegWrite = 1;      // Write result to register
            RegDst   = 0;      // rt field is destination
            MemtoReg = 0;      // ALU result to register
            ALUOp    = 2'b00;  // Use addition operation
        end

        // Custom DSP instruction opcode=1
        6'd1: begin
            dsporALU   = 1;
            dspcontrol = 5'b00001;
            RegWrite   = 1;
            RegDst     = 1;
            MemtoReg   = 0;
        end
    endcase
end
endmodule