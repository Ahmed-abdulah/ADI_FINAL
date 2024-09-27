

module VECTORING_CORDIC_block #(parameter NUM_STAGES=1 , WIDTH=16)(
input wire       clk,
input wire       rst,
input wire signed [WIDTH-1:0] X_in,
input wire signed [WIDTH-1:0] Y_in,

input wire signed [WIDTH-1:0] THETA_IN,


output reg signed [WIDTH-1:0] X_out,
output reg signed [WIDTH-1:0] Y_out ,
output reg signed [WIDTH-1:0] THETA_out
    );
// LUT FOR arctan:

wire [WIDTH-1:0] atan_value [0: 15];

assign atan_value[0]  = 16'b00000_1100_1001_101; // arctan(2^-0)  = arctan(1)     = 0.785398163 = 12.7031
assign atan_value[1]  = 16'b00000_0111_0111_101; // arctan(2^-1)  = arctan(0.5)   = 0.463647609 = 7.4326
assign atan_value[2]  = 16'b00000_0011_1110_101; // arctan(2^-2)  = arctan(0.25)  = 0.244978663 = 3.9130
assign atan_value[3]  = 16'b00000_0010_0001_000; // arctan(2^-3)  = arctan(0.125) = 0.124354995 = 2.0351
assign atan_value[4]  = 16'b00000_0001_0000_010; // arctan(2^-4)  = arctan(0.0625)= 0.062418810 = 1.0238
assign atan_value[5]  = 16'b00000_0000_1000_001; // arctan(2^-5)  = arctan(0.03125)= 0.031239833 = 0.5127
assign atan_value[6]  = 16'b00000_0000_0100_000; // arctan(2^-6)  = arctan(0.015625)= 0.015623729 = 0.2563
assign atan_value[7]  = 16'b00000_0000_0010_000; // arctan(2^-7)  = arctan(0.0078125)= 0.007812341 = 0.1281
assign atan_value[8]  = 16'b00000_0000_0001_000; // arctan(2^-8)  = arctan(0.00390625)= 0.003906230 = 0.0640
assign atan_value[9]  = 16'b00000_0000_0000_100; // arctan(2^-9)  = arctan(0.001953125)= 0.001953123 = 0.0320
assign atan_value[10] = 16'b00000_0000_0000_010; // arctan(2^-10) = arctan(0.0009765625)= 0.000976562 = 0.0160
assign atan_value[11] = 16'b00000_0000_0000_001; // arctan(2^-11) = arctan(0.00048828125)= 0.000488281 = 0.0080
assign atan_value[12] = 16'b00000_0000_0000_000; // arctan(2^-12) = 0.000244141 = ~0
assign atan_value[13] = 16'b00000_0000_0000_000; // arctan(2^-13) = 0.000122070 = ~0
assign atan_value[14] = 16'b00000_0000_0000_000; // arctan(2^-14) = 0.000061035 = ~0
assign atan_value[15] = 16'b00000_0000_0000_000; // arctan(2^-15) = 0.000030518 = ~0

genvar i;

wire signed [WIDTH-1:0] theta_wire [0:NUM_STAGES];
wire signed [WIDTH-1:0] X_wire     [0:NUM_STAGES];
wire signed [WIDTH-1:0] Y_wire     [0:NUM_STAGES];


 assign X_wire[0] = X_in;
 assign Y_wire[0] = Y_in;
 assign theta_wire[0] = THETA_IN;
generate
    for (i =0 ; i < NUM_STAGES ;i=i+1 ) begin
     
         VECTORING_CORDIC #(.I(i) , .WIDTH (WIDTH)) u_cordic (
                .clk(clk),
                .rst(rst),
                .X0(X_wire[i]),  
                .Y0(Y_wire[i]),  
                .X_N(X_wire[i+1]), 
                .Y_N(Y_wire[i+1]),
                .atan(atan_value[i]),
                .theta_0(theta_wire[i]),
                .THETA_N(theta_wire[i+1])
            );
    end
endgenerate

 

always @(posedge clk , negedge rst) begin
    if (!rst) begin
        X_out<='b0;
        Y_out<='b0;
        THETA_out<='b0;

    end
    else begin
        X_out<=X_wire[NUM_STAGES]>>>11;
        Y_out<= Y_wire[NUM_STAGES]>>>11;
        THETA_out<=theta_wire[NUM_STAGES];
    end
end
endmodule
