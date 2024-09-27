module VECTORING_CORDIC #(parameter I = 2 , WIDTH = 16) (
    input wire               clk,
    input wire               rst,
    
    input wire signed  [WIDTH-1:0] theta_0,
    input wire signed  [WIDTH-1:0] atan,

    input wire signed [WIDTH-1:0]  X0, // Input in 1.4.11 format
    input wire signed [WIDTH-1:0]  Y0, // Input in 1.4.11 format
    output reg signed [WIDTH-1:0] X_N, // Output in 1.4.11 format
    output reg signed [WIDTH-1:0] Y_N , // Output in 1.4.11 format
    output reg signed [WIDTH-1:0] THETA_N
);




reg a;

always @(*) begin

    a = Y0[WIDTH-1]; 
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        X_N <= 0;
        Y_N <= 0;
    end else begin

        if (a == 1'b1) begin
           
            X_N <= (X0 - (Y0 >>> I)) ; 
            Y_N <= (Y0 + (X0 >>> I)) ; 
        end else begin
            
            X_N <= (X0 + (Y0 >>> I)) ; 
            Y_N <= (Y0 - (X0 >>> I)) ; 
        end
    end
end


// IMPLEMENATTION OF THETA GENERATOR
always @ (posedge clk , negedge rst)
begin
    if(!rst)
    begin
        THETA_N<='b0;
    end
    else begin
        if (a == 1'b1) begin
            THETA_N<=theta_0 - atan;
        end else begin
            THETA_N<=theta_0 + atan;
        end
    end
end


endmodule