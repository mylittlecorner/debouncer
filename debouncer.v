`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2021 13:34:26
// Design Name: 
// Module Name: debouncer
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


module debouncer(
    input clk,
    input in_state,
    output out_state
    );
        parameter NBITS = 16;
        
        reg [NBITS-1:0] COUNT;
        reg PB_sync_0;
        reg PB_sync_1;
        reg PB_state;
        
        always @(posedge clk) PB_sync_0 <= ~in_state;
        always @(posedge clk) PB_sync_1 <=  PB_sync_0;
        
        wire PB_idle = (PB_state==PB_sync_1);
        wire max_COUNT = &COUNT;
        
        always @(posedge clk)
        begin
            if(PB_idle) COUNT <=0;
            else begin
                COUNT <= COUNT + 1;
                if(max_COUNT) PB_state <= ~PB_state;
            end
        end
        
        assign out_state = PB_state;
        
        
endmodule
