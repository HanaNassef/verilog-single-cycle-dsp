// dsp_unit.v
module dsp_unit(
    input  wire         clk,
    input  wire         reset,
    input  wire [4:0]   dsp_control,    // 5-bit control signal
    input  wire [31:0]  sample_in,      // 32-bit input sample
    output wire [31:0]  filtered_out    // 32-bit filtered output
);
    // 32-bit signed shift-register chain
    reg signed [31:0] sample_reg0;
    reg signed [31:0] sample_reg1;
    reg signed [31:0] sample_reg2;
    reg signed [31:0] sample_reg3;

    // Divide each tap by 4 (arithmetic shift right)
    wire signed [31:0] scaled0 = sample_reg0 >>> 2;
    wire signed [31:0] scaled1 = sample_reg1 >>> 2;
    wire signed [31:0] scaled2 = sample_reg2 >>> 2;
    wire signed [31:0] scaled3 = sample_reg3 >>> 2;

    // Sum of four taps
    wire signed [31:0] sum = scaled0 + scaled1 + scaled2 + scaled3;

    // Shift-in new sample only when dsp_control==00001
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sample_reg0 <= 32'd0;
            sample_reg1 <= 32'd0;
            sample_reg2 <= 32'd0;
            sample_reg3 <= 32'd0;
        end else if (dsp_control == 5'b00001) begin
            sample_reg0 <= sample_in;
            sample_reg1 <= sample_reg0;
            sample_reg2 <= sample_reg1;
            sample_reg3 <= sample_reg2;
        end
    end

    assign filtered_out = sum;
endmodule
