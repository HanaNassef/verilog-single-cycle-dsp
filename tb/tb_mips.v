`timescale 1ns/1ps

module tb_mips;

  // Clock and Reset
  reg clock;
  reg reset;

  // Internal wires to observe outputs
  wire [31:0] PCin, PCout, inst;
  wire RegDst, RegWrite, ALUSrc, MemtoReg, MemRead, MemWrite, Branch;
  wire [1:0] ALUOp;
  wire dsporALU;           // Added DSP control signal
  wire [4:0] dspcontrol;   // Added DSP control signal
  wire [4:0] WriteReg;
  wire [31:0] ReadData1, ReadData2, Extend32, ALU_B, ShiftOut;
  wire [3:0] ALUCtl;
  wire Zero;
  wire [31:0] ALUOut, Add_ALUOut;
  wire AndGateOut;
  wire [31:0] WriteData_Reg;
  wire [31:0] filter;      // Added filter output signal
  wire [31:0] dspout;      // Added DSP output signal

  // Instantiate the MipsCPU
  MipsCPU uut (
    .clock(clock),
    .reset(reset),
    .PCin(PCin),
    .PCout(PCout),
    .inst(inst),
    .RegDst(RegDst),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .ALUOp(ALUOp),
    .dsporALU(dsporALU),       // Added DSP or ALU control
    .dspcontrol(dspcontrol),   // Added DSP control
    .WriteReg(WriteReg),
    .ReadData1(ReadData1),     // This is the sample_in for DSP
    .ReadData2(ReadData2),
    .Extend32(Extend32),
    .ALU_B(ALU_B),
    .ShiftOut(ShiftOut),
    .ALUCtl(ALUCtl),
    .Zero(Zero),
    .ALUOut(ALUOut),
    .Add_ALUOut(Add_ALUOut),
    .AndGateOut(AndGateOut),
    .WriteData_Reg(WriteData_Reg),
    .filter(filter),           // Added filter signal
    .dspout(dspout)            // Added DSP output signal
  );

  // Clock generation
  always #5 clock = ~clock;  // 10ns period => 100MHz

  initial begin
    // Initialize signals
    clock = 0;
    reset = 1;

    // Dump waveforms for Vivado
    $dumpfile("mips_cpu_tb.vcd");
    $dumpvars(0, tb_mips);

    // Release reset
    #10 reset = 0;

    // Run simulation for 200 ns
    #400;

    // Finish simulation
    $finish;
  end

  // Optional: Monitor DSP signals
  initial begin
    $monitor("Time=%0t, DSP: sample_in=%0d, filtered_out=%0d, dsporALU=%0b, dspcontrol=%0b", 
             $time, ReadData1, dspout, dsporALU, dspcontrol);
  end

endmodule