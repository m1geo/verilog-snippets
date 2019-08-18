`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2019 22:17:16
// Design Name: 
// Module Name: testbench
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


module testbench;
    reg clk = 0;         // 66.6667 MHz positive edge
    reg resetn = 1;      // negative edge async reset
    reg [31:0] data = 0; // to display. 0xDEADBEEF will put DEADBEEF on the display
    reg [7:0] dps = 0;   // display 7:0 decimal points.
    wire DI_nCS; //
    wire DI_DTA; // 3 lines to display controller
    wire DI_CKS;  //
    
// UUT
max6951_m1geo uut (
    .clk(clk),
    .resetn(resetn),
    .data(data),
    .dps(dps),
    .DI_nCS(DI_nCS),
    .DI_DTA(DI_DTA),
    .DI_CKS(DI_CKS)
);

parameter MAX_CLOCKS = 100000;
integer i = 0;

initial begin
    #5 resetn = 0;
    #5 resetn = 1;
    for(i=0; i<MAX_CLOCKS; i= i+1)
        #1 clk = ~clk;
     
    $finish;
end
    
endmodule
