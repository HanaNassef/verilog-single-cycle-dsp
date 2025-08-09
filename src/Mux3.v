module Mux3 (ReadData, filter, MemtoReg, WriteData_Reg);

	input [31:0] ReadData, filter;
	input MemtoReg;	
	
	output reg [31:0] WriteData_Reg;
	
	always @(*) begin
		case (MemtoReg)
			0: WriteData_Reg <= filter ;
			1: WriteData_Reg <= ReadData;
		endcase
	end
endmodule