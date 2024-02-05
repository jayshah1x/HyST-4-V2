`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.02.2024 11:57:05
// Design Name: 
// Module Name: top
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


module top(
    input clk,
          reset,
          enable
    );
    
    parameter MATRIX_SIZE = 4;
    parameter ARRAY_SIZE = 2 * MATRIX_SIZE - 1;
    parameter REG_WIDTH = 16; // system type
    parameter DATA_WIDTH = 16;
    parameter VECTOR = 2;
    parameter BRAM_DEPTH = 2;
    
    
    wire [ BRAM_DEPTH-1: 0] address;
    wire write_mode;
    wire compute_ready;
    wire enable_cu;
    wire [ REG_WIDTH*MATRIX_SIZE-1: 0] data_bram_mat1[VECTOR-1:0], data_bram_mat2;
    
    wire [ REG_WIDTH-1: 0] left_0[VECTOR-1:0], left_1[VECTOR-1:0], left_2[VECTOR-1:0], left_3[VECTOR-1:0], left_4[VECTOR-1:0], left_5[VECTOR-1:0], left_6[VECTOR-1:0];
    wire [ REG_WIDTH-1: 0] top_0[VECTOR-1:0], top_1[VECTOR-1:0], top_2[VECTOR-1:0], top_3[VECTOR-1:0], top_4[VECTOR-1:0], top_5[VECTOR-1:0], top_6[VECTOR-1:0];
    wire compute_start_top, compute_start_left_v0, compute_start_left_v1;
    
    wire [DATA_WIDTH-1:0] out_b_7[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] out_b_6[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] out_b_5[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] out_b_4[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] out_r_4[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] out_r_5[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] out_r_6[VECTOR - 1:0];
    //BRAM for Mat_1
     Mat_1 mat_1_instance (
          .clka(clk),    // input wire clka
          .ena(enable),      // input wire ena
          .wea(0),      // input wire [0 : 0] wea
          .addra(address),  // input wire [2 : 0] addra
          .dina(0),    // input wire [63 : 0] dina
          .douta(data_bram_mat2)  // output wire [63 : 0] douta
        );
    //BRAM for Mat_2 Vector-0
    MAT_2_v_0 mat_2_v0_instance (
          .clka(clk),    // input wire clka
          .ena(enable),      // input wire ena
          .wea(0),      // input wire [0 : 0] wea
          .addra(address),  // input wire [2 : 0] addra
          .dina(0),    // input wire [63 : 0] dina
          .douta(data_bram_mat1[0])  // output wire [63 : 0] douta
        );

    //BRAM for Mat_2 Vector-1
    MAT_2_v_1 mat_2_v1_instance (
      .clka(clk),    // input wire clka
      .ena(enable),      // input wire ena
      .wea(0),      // input wire [0 : 0] wea
      .addra(address),  // input wire [2 : 0] addra
      .dina(0),    // input wire [63 : 0] dina
      .douta(data_bram_mat1[1])  // output wire [63 : 0] douta
    );
    //Control Unit for BRAM
    control_unit#(
    .BRAM_DEPTH(2)
     ) cu(.clk(clk), .reset(reset), .enable(enable), .enable_cu(enable_cu), .compute_ready(compute_ready), .write_mode(write_mode), .address(address));
     
    //DATA Decoder for MAT_2 Vector-0
    Data_decoder dd_instance_mat2_v0(clk, enable_cu, data_bram_mat1[0], reset, left_0[0], left_1[0], left_2[0], left_3[0], left_4[0], left_5[0], left_6[0], compute_start_left_v0);
    
    //DATA Decoder for MAT_2 Vector-1
    Data_decoder dd_instance_mat2_v1(clk, enable_cu, data_bram_mat1[1], reset, left_0[1], left_1[1], left_2[1], left_3[1], left_4[1], left_5[1], left_6[1] , compute_start_left_v1);

    //DATA Decoder for MAT_1
    Data_decoder dd_instance_mat1(clk, enable_cu, data_bram_mat2, reset, top_0[0], top_1[0], top_2[0], top_3[0], top_4[0], top_5[0], top_6[0], compute_start_top);
    
    //MatMul Module
    systolic_module systolic_instance(clk,left_0,left_1,left_2,left_3,left_4, left_5, left_6,top_0[0],top_1[0],top_2[0],top_3[0],top_4[0], top_5[0],  top_6[0], out_b_7, out_b_6,out_b_5, out_b_4, out_r_4, out_r_5, out_r_6);
    
    //ILA
    ila_output ila_output_instance (
        .clk(clk), // input wire clk
    
    
        .probe0(out_b_7[0]), // input wire [15:0]  probe0  
        .probe1(out_b_6[0]), // input wire [15:0]  probe1 
        .probe2(out_b_5[0]), // input wire [15:0]  probe2 
        .probe3(out_b_4[0]), // input wire [15:0]  probe3 
        .probe4(out_r_4[0]), // input wire [15:0]  probe4 
        .probe5(out_r_5[0]), // input wire [15:0]  probe5 
        .probe6(out_r_6[0]) // input wire [15:0]  probe6
    );
endmodule
