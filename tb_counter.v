`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2021 15:44:05
// Design Name: 
// Module Name: tb_counter
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


module tb_counter;

reg set;
reg reset;
reg up;
reg down;
reg [1:0] rlr;
reg clk;

wire [2:0] y_out;

cnt_3b uut(
.set(set),
.reset(reset),
.up(up),
.down(down),
.rlr(rlr),
.clk(clk),
.y_out(y_out)
);
initial begin
set=1;
reset=1;
up=0;
down=0;
rlr=0;
clk=0;

#100
set=0;
reset = 0;
rlr = 2'b11;

#100
set = 0;
reset = 0;
rlr = 2'b10;

end


always
#10 clk = ~clk;
endmodule