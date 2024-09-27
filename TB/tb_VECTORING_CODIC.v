`timescale 1ns/1ps

module tb_VECTORING_CORDIC;

    // Parameters
    parameter NUM_STAGES =12;
    parameter WIDTH     =16;

    // Testbench signals
    reg clk;
    reg rst;
    reg signed [WIDTH-1:0] X_in;
    reg signed [WIDTH-1:0] Y_in;
    reg signed [WIDTH-1:0] THETA_IN;

    wire signed [WIDTH-1:0] X_out;
    wire signed [WIDTH-1:0] Y_out;
    wire signed [WIDTH-1:0] THETA_out;

    // Instantiate the DUT (Device Under Test)
    VECTORING_CORDIC_block #(.NUM_STAGES(NUM_STAGES), .WIDTH(WIDTH)) dut (
        .clk(clk),
        .rst(rst),
        .X_in(X_in),
        .Y_in(Y_in),
        .X_out(X_out),
       .Y_out(Y_out),
       .THETA_IN(THETA_IN),
       .THETA_out(THETA_out)
    );

    // Clock generation
    always #5 clk = ~clk; // 100MHz clock (period = 10ns)

    // Test stimulus
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        X_in = 0;
        Y_in = 0;
        THETA_IN=0;
        // Apply reset
        #10 rst = 1; // Release reset after 10ns
        #10 rst = 0; // Apply reset

        // Wait for reset to propagate
        #20 rst = 1; // Release reset again

        // Test vector 1
        #10 X_in = 16'b0_0111_0000_0000_000;
            Y_in = 16'b0_0011_0000_0000_000;
        #200; // Wait for results

//        // Test vector 2
//        #10 X_in = -'d15;
//        Y_in = 'd30;
//        #100; // Wait for results

//        // Test vector 3
//        #10 X_in = 'd50;
//        Y_in = -'d25;
//        #100; // Wait for results

//        // Test vector 4 (edge case)
//        #10 X_in = 'd0;
//        Y_in = 'd127;
//        #100; // Wait for results

//        // Test vector 5 (zero case)
//        #10 X_in = 'd0;
//        Y_in = 'd0;
//        #100; // Wait for results

     
        $stop;
    end

    // Monitor results
    initial begin
        $monitor("Time: %0t | X_in: %f | Y_in: %f | X_out: %f | Y_out: %f | theta: %b", $time, X_in/2.0**11, Y_in/2.0**11, X_out, Y_out ,THETA_out);
    end

endmodule

