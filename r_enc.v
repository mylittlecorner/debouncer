`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2021 13:51:00
// Design Name: 
// Module Name: r_enc
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


module r_enc(
    input r_A,
    input r_B,
    input clk,
    output [1:0] rlr
    );
    
    reg r_A_in;
    reg r_B_in;
    reg [1:0] r_in;
    
    reg r_q1;
    reg delay_r_q1;
    reg r_q2;
    
    reg r_event;
    reg r_left;
    
    always @(posedge clk)
    begin
        r_A_in <= r_A;
        r_B_in <= r_B;
        r_in <= {r_B_in, r_A_in};
        case(r_in)
            2'b00: begin r_q1 <= 0; r_q2 <= r_q2; end
            2'b01: begin r_q1 <= r_q1; r_q2 <= 0; end
            2'b10: begin r_q1 <= r_q1; r_q2 <= 1; end
            2'b11: begin r_q1 <= 1; r_q2 <= r_q2; end
            default: begin r_q1 <= r_q1; r_q2 <= r_q2; end
        endcase
    end
    
    always @(posedge clk)
    begin
        delay_r_q1 <= r_q1;
        if((r_q1 == 1) && (delay_r_q1 ==0))
        begin
            r_event <= 1; r_left <= r_q2;
        end
        else begin
            r_event <= 0; r_left <= r_left;
        end
        
    end
    assign rlr = {r_event, r_left};
    
endmodule
