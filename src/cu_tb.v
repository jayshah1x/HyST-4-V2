`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.01.2024 11:22:57
// Design Name: 
// Module Name: cu_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cu_tb(

    );
    
    reg clk = 0, reset = 1, enable = 0;
    wire enable_cu, compute_ready, write_mode;
    wire [1:0] address;
    
    
    control_unit#(
    .BRAM_DEPTH(2)
     ) cu(.clk(clk), .reset(reset), .enable(enable), .enable_cu(enable_cu), .compute_ready(compute_ready), .write_mode(write_mode), .address(address));
    
    
    always #5 clk = ~clk;
    
 initial begin
 #200
 reset = 0;
 enable = 1;
 
 #50 
 enable = 0;
 end
    
    
    
endmodule