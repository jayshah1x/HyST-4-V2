`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.02.2024 22:57:22
// Design Name: 
// Module Name: Data_decoder
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

(*DONT_TOUCH = "YES"*)
module Data_decoder#(
    parameter REG_WIDTH = 16,
              MATRIX_SIZE = 4,
              ARRAY_SIZE = 2*MATRIX_SIZE - 1,
              BRAM_DEPTH = MATRIX_SIZE*REG_WIDTH,
              OUTPUT_WIDTH = ARRAY_SIZE*REG_WIDTH
)(
input clk,
input enable,
input [BRAM_DEPTH-1: 0] data_bram,
input reset,

output  [REG_WIDTH-1:0] out_0,
output  [REG_WIDTH-1:0] out_1,
output  [REG_WIDTH-1:0] out_2,
output  [REG_WIDTH-1:0] out_3,
output  [REG_WIDTH-1:0] out_4,
output  [REG_WIDTH-1:0] out_5,
output  [REG_WIDTH-1:0] out_6,
output reg compute_start
    );
    
    reg [3:0] state;
    reg [OUTPUT_WIDTH-1:0] o_left_inputs;
    
    initial begin
    state = 0;
    o_left_inputs = 0;
    
    end
    
    always@(posedge clk) begin
        if(reset) begin
            compute_start <= 0;
            o_left_inputs <= 0 ;
        end
        else begin
            if(enable) begin
                 o_left_inputs <= {OUTPUT_WIDTH{1'b0}} | data_bram << (REG_WIDTH*state);
                if(state < MATRIX_SIZE-1) begin
                    state <= state + 1;
                end
                else begin
                    state <= 0;
                end
    end        
        end
    end
    
    
    assign out_0[REG_WIDTH-1:0] = o_left_inputs[REG_WIDTH-1:0];
    assign out_1[REG_WIDTH-1:0] = o_left_inputs[2*REG_WIDTH-1:REG_WIDTH];
    assign out_2[REG_WIDTH-1:0] = o_left_inputs[3*REG_WIDTH-1:2*REG_WIDTH];
    assign out_3[REG_WIDTH-1:0] = o_left_inputs[4*REG_WIDTH-1:3*REG_WIDTH];
    assign out_4[REG_WIDTH-1:0] = o_left_inputs[5*REG_WIDTH-1:4*REG_WIDTH];
    assign out_5[REG_WIDTH-1:0] = o_left_inputs[6*REG_WIDTH-1:5*REG_WIDTH];
    assign out_6[REG_WIDTH-1:0] = o_left_inputs[7*REG_WIDTH-1:6*REG_WIDTH];
endmodule
