`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.01.2024 11:16:11
// Design Name: 
// Module Name: control_unit
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


module control_unit#(
    parameter BRAM_DEPTH = 2 //(in bits)
)(
        input clk,
        input reset,
        input enable,
        
        output reg enable_cu,
        output reg compute_ready,
        output reg write_mode, //write_mode = 0 ==> Read and write_mode = 1 ==> Write
        output reg [BRAM_DEPTH - 1: 0] address
    );
    
    
    /*For simulation purpose only*/
    initial begin
        enable_cu = 0;
        compute_ready = 0;
        write_mode = 0;
        address = 0;
    end
    
    always@(posedge clk) begin
        if(reset) begin
            enable_cu <= 0;
            write_mode <= 0;
            address <= 0;
        end
        else begin
            if(enable) begin
                enable_cu <= 1;
                write_mode <= 0;
                address <= address + 1'b1;
                
            end
        end
    end
    
    
    always@(posedge clk) begin
        if(reset) begin
            compute_ready <= 0;
        end
        else begin
            if(address == 1) begin
                compute_ready = 1;
            end
        end
    end
endmodule
