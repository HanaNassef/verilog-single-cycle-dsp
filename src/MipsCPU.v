module MipsCPU(
    input  wire        clock,
    input  wire        reset,
    // PC
    output wire [31:0] PCin,
    output wire [31:0] PCout,
    // Instruction
    output wire [31:0] inst,

    // Control signals
    output wire        RegDst,
    output wire        RegWrite,
    output wire        ALUSrc,
    output wire        MemtoReg,
    output wire        MemRead,
    output wire        MemWrite,
    output wire        Branch,
    output wire [1:0]  ALUOp,
    output wire        dsporALU,
    output wire [4:0]  dspcontrol,

    // Data path
    output wire [4:0]  WriteReg,
    output wire [31:0] ReadData1,
    output wire [31:0] ReadData2,
    output wire [31:0] Extend32,
    output wire [31:0] ALU_B,
    output wire [31:0] ShiftOut,
    output wire [3:0]  ALUCtl,
    output wire        Zero,
    output wire [31:0] ALUOut,
    output wire [31:0] Add_ALUOut,
    output wire        AndGateOut,
    output wire [31:0] ReadData,
    output wire [31:0] WriteData_Reg,
    output wire [31:0] filter,
    output wire [31:0] dspout
);

    // Program Counter
    PC pc_0(
        .clock(clock),
        .reset(reset),
        .PCin(PCin),
        .PCout(PCout)
    );

    // Instruction Memory
    InstMem instmem_0(
        .clock(clock),
        .address(PCin),
        .inst(inst)
    );

    // Main Control
    MainControl mc(
        .Opcode(inst[31:26]),
        .RegDst(RegDst),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUOp(ALUOp),
        .dsporALU(dsporALU),
        .dspcontrol(dspcontrol)
    );

    // Register Destination Mux
    Mux1 mux1(
        .inst20_16(inst[20:16]),
        .inst15_11(inst[15:11]),
        .RegDst(RegDst),
        .WriteReg(WriteReg)
    );

    // Register File
    RegFile rf(
        .clock(clock),
        .RegWrite(RegWrite),
        .ReadReg1(inst[25:21]),
        .ReadReg2(inst[20:16]),
        .WriteReg(WriteReg),
        .WriteData(WriteData_Reg),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // Sign Extend immediate
    SignExtend se(
        .inst15_0(inst[15:0]),
        .Extend32(Extend32)
    );

    // ALU operand B Mux
    Mux2 mux2(
        .ALUSrc(ALUSrc),
        .ReadData2(ReadData2),
        .Extend32(Extend32),
        .ALU_B(ALU_B)
    );

    // Shift Left 2 (for branch)
    ShiftLeft2 sl2(
        .ShiftIn(Extend32),
        .ShiftOut(ShiftOut)
    );

    // ALU Control
    ALUControl ac(
        .ALUOp(ALUOp),
        .FuncCode(inst[5:0]),
        .ALUCtl(ALUCtl)
    );

    // ALU
    ALU alu(
        .A(ReadData1),
        .B(ALU_B),
        .ALUCtl(ALUCtl),
        .ALUOut(ALUOut),
        .Zero(Zero)
    );

    // Add for branch target
    Add_ALU aalu(
        .PCout(PCout),
        .ShiftOut(ShiftOut),
        .Add_ALUOut(Add_ALUOut)
    );

    // Branch decision
    AndGate ag(
        .Branch(Branch),
        .Zero(Zero),
        .AndGateOut(AndGateOut)
    );

    // PC Mux (PC+4 vs branch target)
    Mux4 m4(
        .PCout(PCout),
        .Add_ALUOut(Add_ALUOut),
        .AndGateOut(AndGateOut),
        .PCin(PCin)
    );

    // Data Memory
    DataMemory dm(
        .clock(clock),
        .address(ALUOut),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .WriteData(ReadData2),
        .ReadData(ReadData)
    );

    // Writeback Mux: filtered/DSP result vs data mem
    Mux3 m3(
        .MemtoReg(MemtoReg),
        .ReadData(ReadData),
        .filter(filter),
        .WriteData_Reg(WriteData_Reg)
    );

    // ALU vs DSP output Mux
    mux_5 m5(
        .ALUout(ALUOut),
        .dspout(dspout),
        .dsporALU(dsporALU),
        .filter(filter)
    );

    // DSP Unit
    dsp_unit du(
        .clk(clock),
        .reset(reset),
        .dsp_control(dspcontrol),
        .sample_in(ReadData1),
        .filtered_out(dspout)
    );
endmodule