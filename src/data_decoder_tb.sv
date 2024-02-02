`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.02.2024 23:11:03
// Design Name: 
// Module Name: data_decoder_tb
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


module data_decoder_tb(

    );
    
    
    localparam REG_WIDTH = 16,
              MATRIX_SIZE = 4,
              ARRAY_SIZE = 2*MATRIX_SIZE - 1,
              BRAM_DEPTH = MATRIX_SIZE*REG_WIDTH,
              OUTPUT_WIDTH = ARRAY_SIZE*REG_WIDTH;
   
    reg enable;
    reg clk;
    reg [BRAM_DEPTH-1: 0] data_bram;
    reg reset;
    
    wire [REG_WIDTH-1:0] out_0;
    wire [REG_WIDTH-1:0] out_1;
    wire [REG_WIDTH-1:0] out_2;
    wire [REG_WIDTH-1:0] out_3;
    wire [REG_WIDTH-1:0] out_4;
    wire [REG_WIDTH-1:0] out_5;
    wire [REG_WIDTH-1:0] out_6;
    wire compute_start;
    
    always #5 clk = ~clk;
    
    initial begin
        enable = 0;
        clk = 0;
        data_bram = 0;
        reset = 1;
    end

              
    Data_decoder data_decoder_instance(clk, enable, data_bram, reset, out_0, out_1, out_2, out_3, out_4, out_5, out_6, compute_start);
    
    initial begin
        #200
        #15
        reset = 0;
        
        #10
        reset = 0;
        
        #10
        enable = 1;
        data_bram = 64'hFFFFFFFFFFFFFFFF;
    
    end
    
endmodule
