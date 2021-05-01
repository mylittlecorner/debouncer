`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2021 13:18:41
// Design Name: 
// Module Name: s_top
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


module s_top(
    input BTN_NORTH,
    input BTN_EAST,
    input BTN_SOUTH,
    input BTN_WEST,
    input CLK,
    input r_A,
    input r_B,
    output [7:0] LED,
    output CLK_SMA,
    output clk_o
    );
    
    wire up_but, down_but;
    wire [1:0] rotation;
    wire [2:0] cnt_out;
    
    debouncer DEBOUNCER_UP(
    .clk(CLK),
    .in_state(BTN_EAST),
    .out_state(up_but)
    );
    
    debouncer DEBOUNCER_DOWN(
        .clk(CLK),
        .in_state(BTN_WEST),
        .out_state(down_but)
        );
        
    r_enc r_ENC_1(
    .r_A(r_A),
    .r_B(r_B),
    .clk(CLK),
    .rlr(rotation)
    );
    
    cnt_3b cnt_3b (
    .set(BTN_NORTH),
    .reset(BTN_SOUTH),
    .up(up_but),
    .down(down_but),
    .clk(CLK),
    .rlr(rotation),
    .y_out(cnt_out)
    );
    
    c_div c_div_1 (
    .div(cnt_out),
    .clk(CLK),
    .clk_o(CLK_SMA),
    .clk_o2(clk_o)
    );
    
    c_stat c_stat_1 (
    .data_in(cnt_out),
    .data_out(LED)
    );
endmodule
