`timescale 1ns / 1ps

module mux_5 (input [31:0] ALUout,input [31:0] dspout, input dsporALU,
              output reg [31:0] filter);

	always @(*) begin
		case (dsporALU)
			1'b0: filter = ALUout;
			1'b1: filter = dspout;
		endcase
	end

endmodule