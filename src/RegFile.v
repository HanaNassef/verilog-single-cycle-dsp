module RegFile(clock, RegWrite, ReadReg1, ReadReg2, WriteReg, WriteData, ReadData1, ReadData2);

	input clock;
	input RegWrite;
	
	input [4:0] ReadReg1, ReadReg2, WriteReg;
	input [31:0] WriteData;
		
	output [31:0] ReadData1, ReadData2;
	
	reg [31:0] reg_mem [0:31];
	initial begin
		reg_mem[0] <= 903;
        reg_mem[1] <= 7258;
        reg_mem[2] <= 10307;
        reg_mem[3] <= 16337;
        reg_mem[4] <= 18674;
        reg_mem[5] <= 22441;
        reg_mem[6] <= 23075;
        reg_mem[7] <= 26502;
        reg_mem[8] <= 27068;
        reg_mem[9] <= 25007;
        reg_mem[10] <= 23858;
        reg_mem[11] <= 20088;
        reg_mem[12] <= 17932;
        reg_mem[13] <= 10485;
        reg_mem[14] <= 7986;
        reg_mem[15] <= 1485;
        reg_mem[16] <= -5307;
        reg_mem[17] <= -11447;
        reg_mem[18] <= -16598;
        reg_mem[19] <= -19816;
        reg_mem[20] <= -23373;
        reg_mem[21] <= -26060;
        reg_mem[22] <= -27187;
        reg_mem[23] <= -26813;
        reg_mem[24] <= -25547;
        reg_mem[25] <= -21259;
        reg_mem[26] <= -19401;
        reg_mem[27] <= -14270;
        reg_mem[28] <= -8661;
        reg_mem[29] <= -4456;
        reg_mem[30] <= -877;
        reg_mem[31] <= 1651;

	end
	assign ReadData1 = reg_mem[ReadReg1];
	assign ReadData2 = reg_mem[ReadReg2];
	
	always @(posedge clock) begin
		if (RegWrite == 1)
			reg_mem[WriteReg] = WriteData;
	end	
endmodule