// dsp_unit_tb.v
`timescale 1ns/1ps

module dsp_unit_tb;
    // Testbench signals, now 32-bit
    reg          clk;
    reg          reset;
    reg  [4:0]   dsp_control;
    reg  [31:0]  sample_in;
    wire [31:0]  filtered_out;

    // Instantiate the DSP unit
    dsp_unit dut (
        .clk(clk),
        .reset(reset),
        .dsp_control(dsp_control),
        .sample_in(sample_in),
        .filtered_out(filtered_out)
    );

    parameter NUM_SAMPLES = 32;

    // Test data arrays (32-bit signed)
    reg signed [31:0] noisy_samples [0:NUM_SAMPLES-1];
    reg signed [31:0] filtered_samples [0:NUM_SAMPLES-1];
    integer i;

    // Clock: 100?MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        noisy_samples[0]  =  903;
        noisy_samples[1]  = 7258;
        noisy_samples[2]  = 10307;
        noisy_samples[3]  = 16337;
        noisy_samples[4]  = 18674;
        noisy_samples[5]  = 22441;
        noisy_samples[6]  = 23075;
        noisy_samples[7]  = 26502;
        noisy_samples[8]  = 27068;
        noisy_samples[9]  = 25007;
        noisy_samples[10] = 23858;
        noisy_samples[11] = 20088;
        noisy_samples[12] = 17932;
        noisy_samples[13] = 10485;
        noisy_samples[14] =  7986;
        noisy_samples[15] =  1485;
        noisy_samples[16] = -5307;
        noisy_samples[17] = -11447;
        noisy_samples[18] = -16598;
        noisy_samples[19] = -19816;
        noisy_samples[20] = -23373;
        noisy_samples[21] = -26060;
        noisy_samples[22] = -27187;
        noisy_samples[23] = -26813;
        noisy_samples[24] = -25547;
        noisy_samples[25] = -21259;
        noisy_samples[26] = -19401;
        noisy_samples[27] = -14270;
        noisy_samples[28] =  -8661;
        noisy_samples[29] =  -4456;
        noisy_samples[30] =   -877;
        noisy_samples[31] =   1651;

        // Initialize control and reset
        reset       = 1;
        dsp_control = 5'b00001;
        sample_in   = 32'd0;

        // Release reset after a couple of cycles
        #20;
        reset = 0;

        // Apply samples
        for (i = 0; i < NUM_SAMPLES; i = i + 1) begin
            @(posedge clk);
            sample_in = noisy_samples[i];
            @(posedge clk);
            @(negedge clk);
            filtered_samples[i] = filtered_out;
        end

        // Display results
        $display("Index\tNoisy\t\tFiltered");
        for (i = 0; i < NUM_SAMPLES; i = i + 1) begin
            $display("%2d:\t%6d\t%6d", i, noisy_samples[i], filtered_samples[i]);
        end

        #20;
        $finish;
    end

    // Optional waveform dump
    initial begin
        $dumpfile("dsp_unit_tb.vcd");
        $dumpvars(0, dsp_unit_tb);
    end
endmodule
