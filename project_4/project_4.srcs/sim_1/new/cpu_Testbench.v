`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2018 10:41:26 AM
// Design Name: 
// Module Name: cpu_Testbench
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

`define REG_SIZE  6'b100000
module cpu_Testbench(

    );
    
    reg clk, reset, enable; 
    wire [`REG_SIZE-1:0] C; 
    wire [`REG_SIZE-1:0] CE=0;
    wire [`REG_SIZE-1:0] CW=0;
    wire [`REG_SIZE-1:0] CN=0;
    wire [`REG_SIZE-1:0] CS=0;
    
    reg[3:0] x=0,y=0;
    
    cpu1 thispe(CW,CN,CS,CE,C,clk,enable,x,y);
    
     initial begin
       clk = 0; 
       reset = 0; 
       enable = 1; 
     end 
       
     always  
       #1 clk = !clk; 
       
     initial  begin
       $display("\t\ttime,\tclk,\treset,\tenable,\tC"); 
     end 
       
       
     // always@ (enable==0)
   //   begin
    //  #1 
    //  enable =1;
   //   end
     //Rest of testbench code after this line 
     
endmodule
