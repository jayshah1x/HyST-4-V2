`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2024 21:59:43
// Design Name: 
// Module Name: top_tb
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


module top_tb(

    );
    reg clk, reset, enable;
    
    top top_instance( clk, reset, enable);
    
    
    always #5 clk = ~clk;
    
    
    initial begin
        clk = 0;
        reset = 1;
        enable = 0;
        
        
        #15
        reset = 0;
        enable = 1;
    end
    
    
    
endmodule
