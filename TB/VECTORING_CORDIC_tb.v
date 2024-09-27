`timescale 1ns / 1ps



module VECTORING_CORDIC_tb;
parameter I =0;

parameter WIDTH =16;
    reg clk;
    reg rst;
    reg signed [WIDTH-1:0] X0;
    reg signed [WIDTH-1:0] Y0;
    wire signed [WIDTH-1:0] X_N;
    wire signed [WIDTH-1:0] Y_N;
    

    VECTORING_CORDIC #(I) dut (
        .clk(clk),
        .rst(rst),
        .X0(X0),
        .Y0(Y0),
        .X_N(X_N),
        .Y_N(Y_N)
    );

    
always #5 clk = ~clk;


initial begin
    clk=0;
    rst=0;
   #10
   rst=1;
//    X0=WIDTH-1;
//    Y0=3;
    #10
  X0 = 16'b0_0111_0000_0000_000;
  Y0 = 16'b0_0011_0000_0000_000;
    #10
    #20

    $stop;
end
 initial begin
        $monitor("Time: %0t | X_in: %f | Y_in: %f | X_out: %f | Y_out: %f", $time, X0/2.0**11, Y0/2.0**11, X_N/2.0**11, Y_N/2.0**11);
    end

endmodule
