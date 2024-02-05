`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2022 19:28:57
// Design Name: 
// Module Name: systolic_module
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
//`ifdef USE_DSP
//    (* use_dsp = "yes" *)
//`else 
//    (* use_dsp = "no" *)
//`endif

//`ifdef DONT_USE_DSP
//    (* use_dsp = "no" *)
//`endif
    (*DONT_TOUCH="YES"*)
module systolic_module(clk,input_left0,input_left1,input_left2,input_left3,input_left4, input_left5, input_left6,input_top0,input_top1,input_top2,input_top3,input_top4, input_top5,  input_top6, out_b_7, out_b_6,out_b_5, out_b_4, out_r_4, out_r_5, out_r_6);
    
    parameter MATRIX_SIZE = 4;
    parameter ARRAY_SIZE = 2 * MATRIX_SIZE - 1;
    parameter REG_WIDTH = 16; // system type
    parameter DATA_WIDTH = 16;
    parameter VECTOR = 2;
    
    (*DONT_TOUCH="YES"*)
    input clk; 
    input [DATA_WIDTH-1:0] input_left0[VECTOR - 1:0];
    input [DATA_WIDTH-1:0] input_left1[VECTOR - 1:0];
    input [DATA_WIDTH-1:0] input_left2[VECTOR - 1:0];
    input [DATA_WIDTH-1:0] input_left3[VECTOR - 1:0];
    input [DATA_WIDTH-1:0] input_left4[VECTOR - 1:0];
    input [DATA_WIDTH-1:0] input_left5[VECTOR - 1:0];
    input [DATA_WIDTH-1:0] input_left6[VECTOR - 1:0];
    input [DATA_WIDTH-1:0] input_top0;
    input [DATA_WIDTH-1:0] input_top1;
    input [DATA_WIDTH-1:0] input_top2;
    input [DATA_WIDTH-1:0] input_top3;
    input [DATA_WIDTH-1:0] input_top4;
    input [DATA_WIDTH-1:0] input_top5;
    input [DATA_WIDTH-1:0] input_top6; 
    output [DATA_WIDTH-1:0] out_b_7[VECTOR - 1:0];
    output [DATA_WIDTH-1:0] out_b_6[VECTOR - 1:0];
    output [DATA_WIDTH-1:0] out_b_5[VECTOR - 1:0];
    output [DATA_WIDTH-1:0] out_b_4[VECTOR - 1:0];
    output [DATA_WIDTH-1:0] out_r_4[VECTOR - 1:0];
    output [DATA_WIDTH-1:0] out_r_5[VECTOR - 1:0];
    output [DATA_WIDTH-1:0] out_r_6[VECTOR - 1:0];
    
   
   (*DONT_TOUCH="YES"*)
    // systolic array
    wire [REG_WIDTH-1:0] array_input_top [ARRAY_SIZE-1:0][VECTOR - 1:0]; //REVIEW THE TYPE AFTER ADDING STREAMING MEMORY
    wire [REG_WIDTH-1:0] array_input_left [ARRAY_SIZE-1:0][VECTOR - 1:0];
    wire [REG_WIDTH-1:0]  c_in_left [ARRAY_SIZE-1:0][VECTOR - 1:0];  // some of them are dummy, TOP AND BOTTOM TAKES THE PREFERNCE OVER LEFT AND RIGHT
    wire [REG_WIDTH-1:0]  c_in_top [ARRAY_SIZE-1:0][VECTOR - 1:0]; // some of them are dummy
    wire [REG_WIDTH-1:0] c_out_right [ARRAY_SIZE-1:0][VECTOR - 1:0]; // some of them are dummy
    wire [REG_WIDTH-1:0] c_out_bottom [ARRAY_SIZE-1:0][VECTOR - 1:0]; //some of them are dummy
    wire [REG_WIDTH-1:0] array_output_bottom [ARRAY_SIZE-1:0][VECTOR - 1:0];
    wire [REG_WIDTH-1:0] array_output_right [ARRAY_SIZE-1:0][VECTOR - 1:0];
    
    
    (*DONT_TOUCH="YES"*)
    // wires/connections in the systolic arrays
    wire [REG_WIDTH-1:0] horizontal_wires [ARRAY_SIZE-1:0][ARRAY_SIZE-2:0][VECTOR - 1:0];
    wire [REG_WIDTH-1:0] vertical_wires [ARRAY_SIZE-2:0][ARRAY_SIZE-1:0][VECTOR - 1:0];
    wire [REG_WIDTH-1:0] diagonal_wires [ARRAY_SIZE-2:0][ARRAY_SIZE-2:0][VECTOR - 1:0];
    
    // input assignment

    (*DONT_TOUCH="YES"*) assign  array_input_left[0] = input_left0[VECTOR - 1:0];
    (*DONT_TOUCH="YES"*) assign  array_input_left[1] = input_left1[VECTOR - 1:0];
    (*DONT_TOUCH="YES"*) assign  array_input_left[2] = input_left2[VECTOR - 1:0];
    (*DONT_TOUCH="YES"*) assign  array_input_left[3] = input_left3[VECTOR - 1:0];
    (*DONT_TOUCH="YES"*) assign  array_input_left[4] = input_left4[VECTOR - 1:0];
    (*DONT_TOUCH="YES"*) assign  array_input_left[5] = input_left5[VECTOR - 1:0];
    (*DONT_TOUCH="YES"*) assign  array_input_left[6] = input_left6[VECTOR - 1:0];
    (*DONT_TOUCH="YES"*) assign  array_input_top[0][0] = input_top0;
    (*DONT_TOUCH="YES"*) assign  array_input_top[1][0] = input_top1;
    (*DONT_TOUCH="YES"*)assign  array_input_top[2][0] = input_top2;
    (*DONT_TOUCH="YES"*)assign  array_input_top[3][0] = input_top3;
    (*DONT_TOUCH="YES"*)assign  array_input_top[4][0] = input_top4;
    (*DONT_TOUCH="YES"*) assign  array_input_top[5][0] = input_top5;
    (*DONT_TOUCH="YES"*) assign  array_input_top[6][0] = input_top6;
    (*DONT_TOUCH="YES"*)assign  array_input_top[0][1] = input_top0;
    (*DONT_TOUCH="YES"*)assign  array_input_top[1][1] = input_top1;
    (*DONT_TOUCH="YES"*)assign  array_input_top[2][1] = input_top2;
    (*DONT_TOUCH="YES"*)assign  array_input_top[3][1] = input_top3;
    (*DONT_TOUCH="YES"*)assign  array_input_top[4][1] = input_top4;
    (*DONT_TOUCH="YES"*)assign  array_input_top[5][1] = input_top5;
    (*DONT_TOUCH="YES"*)assign  array_input_top[6][1] = input_top6;
    
  
    
    
    (*DONT_TOUCH="YES"*)
    // creating the systolic array
    generate ////////
        genvar row_index;
        genvar column_index;
        
        for(row_index = 0;row_index < ARRAY_SIZE; row_index = row_index + 1) begin
            for(column_index = 0;column_index < ARRAY_SIZE; column_index = column_index + 1) begin                 
                // CONNECTING BOUNDARIES
                
                //(*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(array_input_left[row_index]),.b_n_1(array_input_top[column_index]),.c_n_1(c_in_top[column_index]),.a_n(horizontal_wires[row_index][column_index]),.b_n(array_input_left[row_index]),.c_ab(diagonal_wires[row_index][column_index]));
            
            
                // LOGICALLY CONNECTING PART
                 if(row_index < MATRIX_SIZE -1) begin
                    if(column_index < MATRIX_SIZE+row_index) begin     
                        if(row_index == 0 && column_index==0)  begin // LEFT TOP // covering corners DEPENDS ON THE CONDITION
                            (*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(array_input_left[row_index]),.b_n_1(array_input_top[column_index]),.c_n_1(c_in_top[column_index]),.a_n(horizontal_wires[row_index][column_index]),.b_n(vertical_wires[row_index][column_index]),.c_ab(diagonal_wires[row_index][column_index]));
                        end
                        else if(column_index == 0) begin// LEFT inputs
                            (*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(array_input_left[row_index]),.b_n_1(vertical_wires[row_index-1][column_index]),.c_n_1(c_in_left[row_index]),.a_n(horizontal_wires[row_index][column_index]),.b_n(vertical_wires[row_index][column_index]),.c_ab(diagonal_wires[row_index][column_index]));
                        end
                        else if(row_index == 0) begin // TOP inputs
                            (*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(horizontal_wires[row_index][column_index-1]),.b_n_1(array_input_top[column_index]),.c_n_1(c_in_top[column_index]),.a_n(horizontal_wires[row_index][column_index]),.b_n(vertical_wires[row_index][column_index]),.c_ab(diagonal_wires[row_index][column_index]));
                        end // internal elements
                        else begin 
                            (*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(horizontal_wires[row_index][column_index-1]),.b_n_1(vertical_wires[row_index-1][column_index]),.c_n_1(diagonal_wires[row_index-1][column_index-1]),.a_n(horizontal_wires[row_index][column_index]),.b_n(vertical_wires[row_index][column_index]),.c_ab(diagonal_wires[row_index][column_index]));
                        end
                        //(*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(),.b_n_1(),.c_n_1(),.a_n(),.b_n(),.c_ab());
                    end
                    else begin
                        if(row_index == 0 && column_index==ARRAY_SIZE-1)  begin // RIGHT TOP // covering corners DEPENDS ON THE CONDITION
                            (*DONT_TOUCH="YES"*) delay_element element(.clk(clk),.a_n_1(horizontal_wires[row_index][column_index-1]),.b_n_1(array_input_top[column_index]),.a_n(array_output_right[row_index]),.b_n(vertical_wires[row_index][column_index]));
                        end
                        else if(column_index == ARRAY_SIZE-1) begin// RIGHT 
                            (*DONT_TOUCH="YES"*) delay_element element(.clk(clk),.a_n_1(horizontal_wires[row_index][column_index-1]),.b_n_1(vertical_wires[row_index-1][column_index]),.a_n(array_output_right[row_index]),.b_n(vertical_wires[row_index][column_index]));
                        end
                        else if(row_index == 0) begin // TOP inputs
                            (*DONT_TOUCH="YES"*) delay_element element(.clk(clk),.a_n_1(horizontal_wires[row_index][column_index-1]),.b_n_1(array_input_top[column_index]),.a_n(horizontal_wires[row_index][column_index]),.b_n(vertical_wires[row_index][column_index]));
                        end // internal elements
                        else begin 
                            (*DONT_TOUCH="YES"*) delay_element element(.clk(clk),.a_n_1(horizontal_wires[row_index][column_index-1]),.b_n_1(vertical_wires[row_index-1][column_index]),.a_n(horizontal_wires[row_index][column_index]),.b_n(vertical_wires[row_index][column_index]));
                        end                    
                        //(*DONT_TOUCH="YES"*) delay_element element(.clk(),.a_n_1(),.b_n_1(),.a_n(),.b_n());
                    end
                end
                else if(row_index == MATRIX_SIZE-1) begin
                    if(column_index == 0) begin //LEFT end
                       (*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(array_input_left[row_index]),.b_n_1(vertical_wires[row_index-1][column_index]),.c_n_1(c_in_left[row_index]),.a_n(horizontal_wires[row_index][column_index]),.b_n(vertical_wires[row_index][column_index]),.c_ab(diagonal_wires[row_index][column_index]));
                    end
                    else if(column_index == ARRAY_SIZE-1) begin // RIGHT end
                       (*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(horizontal_wires[row_index][column_index-1]),.b_n_1(vertical_wires[row_index-1][column_index]),.c_n_1(diagonal_wires[row_index-1][column_index-1]),.a_n(array_output_right[row_index]),.b_n(vertical_wires[row_index][column_index]),.c_ab(c_out_right[row_index]));                    
                    end
                    else begin //internal elements
                       (*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(horizontal_wires[row_index][column_index-1]),.b_n_1(vertical_wires[row_index-1][column_index]),.c_n_1(diagonal_wires[row_index-1][column_index-1]),.a_n(horizontal_wires[row_index][column_index]),.b_n(vertical_wires[row_index][column_index]),.c_ab(diagonal_wires[row_index][column_index]));                        
                    end
                    // (*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(),.b_n_1(),.c_n_1(),.a_n(),.b_n(),.c_ab());
                end
                else begin
                    if(column_index < MATRIX_SIZE+row_index-ARRAY_SIZE) begin // intended : MATRIX_SIZE - 1 + row_index - ARRAY_SIZE+1
                        if((row_index == ARRAY_SIZE-1) && (column_index == 0)) begin//LEFT BOTTOM corner
                            (*DONT_TOUCH="YES"*) delay_element element(.clk(clk),.a_n_1(array_input_left[row_index]),.b_n_1(vertical_wires[row_index-1][column_index]),.a_n(horizontal_wires[row_index][column_index]),.b_n(vertical_wires[row_index][column_index]));
                        end
                        else if(column_index == 0) begin //LEFT
                            (*DONT_TOUCH="YES"*) delay_element element(.clk(clk),.a_n_1(array_input_left[row_index]),.b_n_1(vertical_wires[row_index-1][column_index]),.a_n(horizontal_wires[row_index][column_index]),.b_n(array_output_bottom[column_index]));
                        end
                        else if(row_index == ARRAY_SIZE - 1) begin //BOTTOM
                            (*DONT_TOUCH="YES"*) delay_element element(.clk(clk),.a_n_1(horizontal_wires[row_index][column_index-1]),.b_n_1(vertical_wires[row_index-1][column_index]),.a_n(horizontal_wires[row_index][column_index]),.b_n(array_output_bottom[column_index]));
                        end
                        else begin
                            (*DONT_TOUCH="YES"*) delay_element element(.clk(clk),.a_n_1(horizontal_wires[row_index][column_index-1]),.b_n_1(vertical_wires[row_index-1][column_index]),.a_n(horizontal_wires[row_index][column_index]),.b_n(vertical_wires[row_index][column_index]));
                        end
                        //(*DONT_TOUCH="YES"*) delay_element element(.clk(),.a_n_1(),.b_n_1(),.a_n(),.b_n());
                    end
                    else begin
                        if((row_index == ARRAY_SIZE-1) && (column_index == ARRAY_SIZE-1)) begin//RIGHT BOTTOM
                            (*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(horizontal_wires[row_index][column_index-1]),.b_n_1(vertical_wires[row_index-1][column_index]),.c_n_1(diagonal_wires[row_index-1][column_index-1]),.a_n(array_output_right[row_index]),.b_n(array_output_bottom[column_index]),.c_ab(c_out_bottom[column_index]));  
                        end
                        else if(column_index == ARRAY_SIZE-1) begin // RIGHT
                            (*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(horizontal_wires[row_index][column_index-1]),.b_n_1(vertical_wires[row_index-1][column_index]),.c_n_1(diagonal_wires[row_index-1][column_index-1]),.a_n(array_output_right[row_index]),.b_n(vertical_wires[row_index][column_index]),.c_ab(c_out_right[row_index]));  
                        end
                        else if(row_index == ARRAY_SIZE - 1) begin //BOTTOM
                            (*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(horizontal_wires[row_index][column_index-1]),.b_n_1(vertical_wires[row_index-1][column_index]),.c_n_1(diagonal_wires[row_index-1][column_index-1]),.a_n(horizontal_wires[row_index][column_index]),.b_n(array_output_bottom[column_index]),.c_ab(c_out_bottom[column_index]));  
                        end
                        else begin
                            (*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(horizontal_wires[row_index][column_index-1]),.b_n_1(vertical_wires[row_index-1][column_index]),.c_n_1(diagonal_wires[row_index-1][column_index-1]),.a_n(horizontal_wires[row_index][column_index]),.b_n(vertical_wires[row_index][column_index]),.c_ab(diagonal_wires[row_index][column_index]));   
                        end
                        
                        //(*DONT_TOUCH="YES"*) PE element(.clk(clk),.a_n_1(),.b_n_1(),.c_n_1(),.a_n(),.b_n(),.c_ab());
                    end
                end           
            end
            
        end
    
    endgenerate//////////
    // systolic array created

    (*DONT_TOUCH="YES"*) assign c_in_top[0][0] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_top[1][0] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_top[2][0] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_top[3][0] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_top[4][0] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_top[0][1] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_top[1][1] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_top[2][1] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_top[3][1] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_top[4][1] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[0][2] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[1][2] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[2][2] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[3][2] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[4][2] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[0][3] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[1][3] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[2][3] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[3][3] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[4][3] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[0][4] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[1][4] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[2][4] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[3][4] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[4][4] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[0][5] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[1][5] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[2][5] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[3][5] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[4][5] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[0][6] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[1][6] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[2][6] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[3][6] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[4][6] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[0][7] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[1][7] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[2][7] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[3][7] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_top[4][7] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_left[0][0] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_left[1][0] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_left[2][0] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_left[3][0] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_left[4][0] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_left[0][1] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_left[1][1] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_left[2][1] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_left[3][1] = {DATA_WIDTH{1'b0}};
    (*DONT_TOUCH="YES"*) assign c_in_left[4][1] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[0][2] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[1][2] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[2][2] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[3][2] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[4][2] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[0][3] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[1][3] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[2][3] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[3][3] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[4][3] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[0][4] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[1][4] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[2][4] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[3][4] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[4][4] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[0][5] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[1][5] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[2][5] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[3][5] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[4][5] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[0][6] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[1][6] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[2][6] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[3][6] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[4][6] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[0][7] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[1][7] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[2][7] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[3][7] = {DATA_WIDTH{1'b0}};
//    (*DONT_TOUCH="YES"*) assign c_in_left[4][7] = {DATA_WIDTH{1'b0}};
       
    
    (*DONT_TOUCH="YES"*) assign out_b_7 = c_out_bottom[6];
    (*DONT_TOUCH="YES"*) assign out_b_6 = c_out_bottom[5];
    (*DONT_TOUCH="YES"*) assign out_b_5 = c_out_bottom[4];
    (*DONT_TOUCH="YES"*) assign out_b_4 = c_out_bottom[3];
    
    (*DONT_TOUCH="YES"*) assign out_r_4 = c_out_right[5];
    (*DONT_TOUCH="YES"*) assign out_r_5 = c_out_right[4];
    (*DONT_TOUCH="YES"*) assign out_r_6 = c_out_right[3];
    
//    (*DONT_TOUCH="YES"*) assign out_b_5 = c_out_bottom[4];
//    (*DONT_TOUCH="YES"*) assign out_b_4 = c_out_bottom[3];
//    (*DONT_TOUCH="YES"*) assign out_b_3 = c_out_bottom[2];
//    (*DONT_TOUCH="YES"*) assign out_r_4 = c_out_right[3];
//    (*DONT_TOUCH="YES"*) assign out_r_3 = c_out_right[2];

        
    

    

    
/////// filter input management

/////// filter input management    
    
   
   /*
    ila_1 tester (
	.clk(clk_ila), // input wire clk


	.probe0(c_in_top[0]), // input wire [15:0]  probe0  
	.probe1(array_input_top[0]), // input wire [15:0]  probe1 
	.probe2(array_input_top[1]), // input wire [15:0]  probe2 
	.probe3(array_input_top[2]), // input wire [15:0]  probe3 
	.probe4(array_input_top[3]), // input wire [15:0]  probe4 
	.probe5(array_input_top[4]), // input wire [15:0]  probe5 
	.probe6(array_input_left[0]), // input wire [15:0]  probe6 
	.probe7(array_input_left[1]), // input wire [15:0]  probe7 
	.probe8(array_input_left[2]), // input wire [15:0]  probe8 
	.probe9(array_input_left[3]), // input wire [15:0]  probe9 
	.probe10(array_input_left[4]) // input wire [15:0]  probe10
    );  
    */
endmodule
