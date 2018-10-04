`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2018 07:01:55 PM
// Design Name: 
// Module Name: cpu1
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


module cpu1(
    input [31:0] cw,
    input [31:0] cs,
    input [31:0] cn,
    input [31:0] ce,
    output [31:0] outC,
    input clk,
    input [3:0] x,
    input [3:0] y
    );
    
    wire[31:0] cw,cn,cs,ce;
    reg [31:0] outC;
    
    reg[3:0] opcode;
    reg[4:0]mode;
    reg[9:0] rega,regb;
    reg [29:0] instructions[100:0];
    integer i,pc=0;
    
    //defines
    initial
    begin
        $readmemb("E:\\test\\testb.txt",instructions);
        for(i=0 ; i < 30 ; i=i+1)
        begin
        $display("%b",instructions[i]);
        end
        $finish;
        opcode <= instructions[pc][29:26];
        mode <= instructions[pc][25:21];
        
    end
    

    
   // mode <= {ins[0],ins[1],ins[2],ins[3]};
    always @(posedge clk) begin
    case(mode)
    5'b00000:;// conscons
    5'b00001:;// regreg
    5'b00010:;// extext
    5'b00011:;// idid
    5'b00100:;// out_const
    5'b00101:;// out_reg
    5'b00110:;// out_ext
    5'b00111:;// out_id
    5'b01000:;// reg_const
    5'b01001:;// reg_ext
    5'b01010:;// reg_id
    5'b01011:;// const_reg
    5'b01100:; // const_ext
    5'b01101:; // const_id
    5'b01110:; // ext_reg
    5'b01111:; // ext_const
    5'b10000:; // ext_id
    5'b10001:; // id_reg
    5'b10010:; // id_const
    5'b10011:; // id_ext
    endcase
    case(opcode)
    4'b0000:;// the add
    4'b0001:;// the mull
    4'b0010:;// the move
    4'b0011:;// the set
    endcase
    end
endmodule
