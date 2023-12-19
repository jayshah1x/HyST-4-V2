`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.12.2023 15:10:36
// Design Name: 
// Module Name: systolic_tb
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


module systolic_tb(

    );
    
    parameter MATRIX_SIZE = 4;
    parameter ARRAY_SIZE = 2 * MATRIX_SIZE - 1;
    parameter REG_WIDTH = 16; // system type
    parameter DATA_WIDTH = 16;
    parameter VECTOR = 1;
    
    reg clk = 0; 
    
    reg [MATRIX_SIZE*DATA_WIDTH-1:0] a_row_1;
    reg [MATRIX_SIZE*DATA_WIDTH-1:0] a_row_2;
    reg [MATRIX_SIZE*DATA_WIDTH-1:0] a_row_3;
    reg [MATRIX_SIZE*DATA_WIDTH-1:0] a_row_4;
    
    reg [MATRIX_SIZE*DATA_WIDTH-1:0] b_row_1;
    reg [MATRIX_SIZE*DATA_WIDTH-1:0] b_row_2;
    reg [MATRIX_SIZE*DATA_WIDTH-1:0] b_row_3;
    reg [MATRIX_SIZE*DATA_WIDTH-1:0] b_row_4;
    
    reg [ARRAY_SIZE*DATA_WIDTH-1:0] temp_row_1;
    reg [ARRAY_SIZE*DATA_WIDTH-1:0] temp_row_2;
    
    
    wire [DATA_WIDTH-1:0] input_left0[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] input_left1[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] input_left2[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] input_left3[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] input_left4[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] input_left5[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] input_left6[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] input_top0[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] input_top1[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] input_top2[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] input_top3[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] input_top4[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] input_top5[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] input_top6[VECTOR - 1:0]; 
    wire [DATA_WIDTH-1:0] out_b_7[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] out_b_6[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] out_b_5[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] out_b_4[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] out_r_4[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] out_r_5[VECTOR - 1:0];
    wire [DATA_WIDTH-1:0] out_r_6[VECTOR - 1:0];
    
    reg [2:0] state;
    
    
    systolic_module systolic_tb(clk,input_left0,input_left1,input_left2,input_left3,input_left4, input_left5, input_left6,input_top0,input_top1,input_top2,input_top3,input_top4, input_top5,  input_top6, out_b_7, out_b_6,out_b_5, out_b_4, out_r_4, out_r_5, out_r_6);
    
   initial begin
    a_row_1 = 0; a_row_2 = 0;a_row_3 = 0;a_row_4 = 0;
    b_row_1 = 0; b_row_2 = 0;b_row_3 = 0;b_row_4 = 0;
    temp_row_1 = 0;
    temp_row_2 = 0;
    state = 'b011;
   end
   
   initial begin
    #10
        a_row_1 = {16'h01, 16'h01, 16'h01, 16'h01};
        a_row_2 = {16'h02, 16'h01, 16'h01, 16'h01};
        a_row_3 = {16'h01, 16'h01, 16'h01, 16'h01};
        a_row_4 = {16'h01, 16'h01, 16'h01, 16'h01}; //B
         
        b_row_1 = {16'h01, 16'h01, 16'h01, 16'h01};
        b_row_2 = {16'h02, 16'h02, 16'h02, 16'h02};
        b_row_3 = {16'h03, 16'h03, 16'h03, 16'h03};
        b_row_4 = {16'h04, 16'h04, 16'h04, 16'h04}; //A tranpose
        
      
//   #55 
   
//        b_row_1 = {16'h01, 16'h02, 16'h01, 16'h01};
//        b_row_2 = {16'h01, 16'h01, 16'h01, 16'h01};
//        b_row_3 = {16'h01, 16'h01, 16'h01, 16'h01};
//        b_row_4 = {16'h01, 16'h01, 16'h01, 16'h01}; //B
         
//        a_row_1 = {16'h01, 16'h02, 16'h03, 16'h04};
//        a_row_2 = {16'h01, 16'h02, 16'h03, 16'h04};
//        a_row_3 = {16'h01, 16'h02, 16'h03, 16'h04};
//        a_row_4 = {16'h01, 16'h02, 16'h03, 16'h04}; //A
   end
   
   always #5 clk = ~clk;
   
   initial begin
   
   
    #15
       
       temp_row_1 = (112'd0 | ({a_row_1[63:48], a_row_2[63:48], a_row_3[63:48], a_row_4[63:48]})<<16*state );
       //temp_row_2 = (112'd0 | ({b_row_1[63:48], b_row_2[63:48], b_row_3[63:48], b_row_4[63:48]})<<16*state );
       //Test no transpose
       temp_row_2 = (112'd0 | ({b_row_1[63:48], b_row_1[47:32], b_row_1[31:16], b_row_1[15:0]})<<16*state );
       state = state - 'b1;
        
    #10
        
        temp_row_1 = (112'd0 | ({a_row_1[47:32], a_row_2[47:32], a_row_3[47:32], a_row_4[47:32]})<<16*state );
//        temp_row_2 = (112'd0 | ({b_row_1[47:32], b_row_2[47:32], b_row_3[47:32], b_row_4[47:32]})<<16*state );
        //Test no transpose
       temp_row_2 = (112'd0 | ({b_row_2[63:48], b_row_2[47:32], b_row_2[31:16], b_row_2[15:0]})<<16*state );
        state = state - 'b1;
        
    #10
        
        temp_row_1 = (112'd0 | ({a_row_1[31:16], a_row_2[31:16], a_row_3[31:16], a_row_4[31:16]})<<16*state );
//        temp_row_2 = (112'd0 | ({b_row_1[31:16], b_row_2[31:16], b_row_3[31:16], b_row_4[31:16]})<<16*state );
        //Test no transpose
        temp_row_2 = (112'd0 | ({b_row_3[63:48], b_row_3[47:32], b_row_3[31:16], b_row_3[15:0]})<<16*state );
        state = state - 'b1;
        
    #10;
        
        temp_row_1 = (112'd0 | ({a_row_1[15:0], a_row_2[15:0], a_row_3[15:0], a_row_4[15:0]})<<16*state );
//        temp_row_2 = (112'd0 | ({b_row_1[15:0], b_row_2[15:0], b_row_3[15:0], b_row_4[15:0]})<<16*state );
        //Test no transpose
        temp_row_2 = (112'd0 | ({b_row_4[63:48], b_row_4[47:32], b_row_4[31:16], b_row_4[15:0]})<<16*state );
        state = 'd3;
        
    #10
        temp_row_1 = 0;
        temp_row_2 = 0;
        
        
//    #10
       
//       temp_row_1 = (112'd0 | ({a_row_1[63:48], a_row_2[63:48], a_row_3[63:48], a_row_4[63:48]})<<16*state );
//       temp_row_2 = (112'd0 | ({b_row_1[63:48], b_row_2[63:48], b_row_3[63:48], b_row_4[63:48]})<<16*state );
//       state = state - 'b1;
        
//    #10
        
//        temp_row_1 = (112'd0 | ({a_row_1[47:32], a_row_2[47:32], a_row_3[47:32], a_row_4[47:32]})<<16*state );
//        temp_row_2 = (112'd0 | ({b_row_1[47:32], b_row_2[47:32], b_row_3[47:32], b_row_4[47:32]})<<16*state );
//        state = state - 'b1;
        
//    #10
        
//        temp_row_1 = (112'd0 | ({a_row_1[31:16], a_row_2[31:16], a_row_3[31:16], a_row_4[31:16]})<<16*state );
//        temp_row_2 = (112'd0 | ({b_row_1[31:16], b_row_2[31:16], b_row_3[31:16], b_row_4[31:16]})<<16*state );
//        state = state - 'b1;
        
//    #10;
        
//        temp_row_1 = (112'd0 | ({a_row_1[15:0], a_row_2[15:0], a_row_3[15:0], a_row_4[15:0]})<<16*state );
//        temp_row_2 = (112'd0 | ({b_row_1[15:0], b_row_2[15:0], b_row_3[15:0], b_row_4[15:0]})<<16*state );
//        state = 'd4;
        
//    #10
//        temp_row_1 = 0;
//        temp_row_2 = 0;
        
   end
   
   
   
(*DONT_TOUCH="YES"*) assign input_left6[0] = temp_row_1[15:0]; 
(*DONT_TOUCH="YES"*) assign input_left5[0] = temp_row_1[31:16]; 
(*DONT_TOUCH="YES"*) assign input_left4[0] = temp_row_1[47:32]; 
(*DONT_TOUCH="YES"*) assign input_left3[0] = temp_row_1[63:48]; 
(*DONT_TOUCH="YES"*) assign input_left2[0] = temp_row_1[79:64]; 
(*DONT_TOUCH="YES"*) assign input_left1[0] = temp_row_1[95:80]; 
(*DONT_TOUCH="YES"*) assign input_left0[0] = temp_row_1[111:96]; 

(*DONT_TOUCH="YES"*) assign input_top6[0] = temp_row_2[15:0]; 
(*DONT_TOUCH="YES"*) assign input_top5[0] = temp_row_2[31:16]; 
(*DONT_TOUCH="YES"*) assign input_top4[0] = temp_row_2[47:32]; 
(*DONT_TOUCH="YES"*) assign input_top3[0] = temp_row_2[63:48]; 
(*DONT_TOUCH="YES"*) assign input_top2[0] = temp_row_2[79:64]; 
(*DONT_TOUCH="YES"*) assign input_top1[0] = temp_row_2[95:80];
(*DONT_TOUCH="YES"*) assign input_top0[0] = temp_row_2[111:96]; 
    
endmodule
