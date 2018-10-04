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
    reg [31:0] myregs[15:0];
    reg[3:0] opcode;
    reg[4:0]mode;
    reg[9:0] arga,argb;
    reg [29:0] instructions[100:0];
    integer i,pc=0;
    
    `define const_const 5'b00000//conscons
    `define reg_reg 5'b00001// regreg
    `define ext_ext     5'b00010// extext
     `define id_id    5'b00011// idid
      `define out_const  5'b00100// out_const
      `define out_reg  5'b00101// out_reg
     `define out_ext   5'b00110// out_ext
     `define out_id   5'b00111// out_id
      `define reg_const  5'b01000// reg_const
     `define reg_ext   5'b01001// reg_ext
     `define reg_id   5'b01010// reg_id
     `define const_reg   5'b01011// const_reg
     `define const_ext   5'b01100 // const_ext
     `define const_id   5'b01101 // const_id
      `define ext_reg  5'b01110 // ext_reg
      `define ext_const  5'b01111 // ext_const
      `define ext_id  5'b10000 // ext_id
      `define id_reg  5'b10001 // id_reg
     `define id_const   5'b10010 // id_const
     `define id_ext   5'b10011 // id_ext
     
     `define ex_cw   2'b00 // cw wire 
     `define ex_cn   2'b01 // cn wire
     `define ex_ce   2'b10 // ce wire      
     `define ex_cs   2'b11 // cs wire
     
    `define add 4'b0000// the add
    `define mull 4'b0001// the mull
    `define move 4'b0010// the move
    `define set 4'b0011// the set
    
    //defines
    initial
    begin
        $readmemb("E:\\test\\testb.txt",instructions);
        for(i=0 ; i < 100 ; i=i+1)
        begin
        $display("%b",instructions[i]);
        end
        $finish;
        opcode <= instructions[pc][28:25];
        mode <= instructions[pc][24:20];
        
    end
    

    
   // mode <= {ins[0],ins[1],ins[2],ins[3]};
    always @(posedge clk) begin
    case(mode)
    `const_const: begin
        arga <= instructions[pc][19:10];
        argb <= instructions[pc][9:0];
     end// conscons 
     
    `reg_reg: begin
        arga <= myregs[instructions[pc][19:10]];
        argb <= myregs[instructions[pc][9:0]];
      end // regreg
        
    `ext_ext: begin
         case(instructions[pc][1:0])
                 `ex_cw: arga=cw;
                 `ex_cs: arga=cs;
                 `ex_cn: arga=cn;             
                 `ex_ce: arga=ce;
                 endcase
         case(instructions[pc][1:0])
                 `ex_cw: argb=cw;
                 `ex_cs: argb=cs;
                 `ex_cn: argb=cn;             
                 `ex_ce: argb=ce;
                  endcase             
     end// extext    
    
    
    `id_id: begin
         if(instructions[pc][11:10]== 2'b00 ) begin  
            arga = x;
            end    
          else begin 
            arga = y;
           end     
              
           if(instructions[pc][1:0]== 2'b00 )begin
                  argb = x;
                  end
           else begin
                argb = y; 
                end
                
           end//idid
               

        
    `out_const: begin
           arga <=outC;//the out
           argb <=instructions[pc][9:0] ; //the const
       end// out_const
       
       
    `out_reg: begin
            arga <=outC;//the out
            argb <=myregs[instructions[pc][9:0]] ; //the const
      end// out_reg
      
    `out_ext: begin
                arga <=outC;//the out
                 case(instructions[pc][1:0])
                    `ex_cw: argb=cw;
                    `ex_cs: argb=cs;
                    `ex_cn: argb=cn;             
                    `ex_ce: argb=ce;
                    endcase  
    end// out_ext
    
    
    `out_id: begin
        arga <=outC;//the out
          if(instructions[pc][1:0]== 2'b00 )begin
                argb = x;
                end
          else begin
                argb = y; 
                end
    end// out_id
    
    
    `reg_const: begin
            arga <= myregs[instructions[pc][19:10]];
            argb <= instructions[pc][9:0];
    end// reg_const
    
    `reg_ext: begin
            arga <= myregs[instructions[pc][19:10]];
            case(instructions[pc][1:0])
                `ex_cw: argb=cw;
                `ex_cs: argb=cs;
                `ex_cn: argb=cn;             
                `ex_ce: argb=ce;
                endcase       
    end// reg_ext
    
    
    `reg_id: begin
          arga <= myregs[instructions[pc][19:10]];
          if(instructions[pc][1:0]== 2'b00 )begin
                 argb = x;
                 end
           else begin
                 argb = y; 
                 end
      end// reg_id
    
    `const_reg: begin
         arga <= instructions[pc][19:10];
         argb <= myregs[instructions[pc][9:0]];
    end// const_reg
    
    
    `const_ext: begin 
         arga <= instructions[pc][20:11];
             case(instructions[pc][1:0])
                 `ex_cw: argb=cw;
                 `ex_cs: argb=cs;
                 `ex_cn: argb=cn;             
                 `ex_ce: argb=ce;
                 endcase  
     end//const_ext
    
    `const_id:; // const_id
    `ext_reg:; // ext_reg
    `ext_const:; // ext_const
    `ext_id:; // ext_id
    
    `id_reg:begin
                if(instructions[pc][11:10]== 2'b00 ) begin  
                    arga = x;
                    end    
                else begin 
                    arga = y;
                    end                     
               argb <= myregs[instructions[pc][9:0]];          
         end // id_reg
    
    `id_const:begin
            if(instructions[pc][11:10]== 2'b00 ) begin  
                arga = x;
                end    
            else begin 
                arga = y;
                end   
                
           argb <= instructions[pc][9:0];          
     end // id_const
     
    `id_ext:begin
        if(instructions[pc][11:10]== 2'b00 ) begin  
            arga = x;
            end    
        else begin 
            arga = y;
            end   
           
           case(instructions[pc][1:0])
                  `ex_cw: argb=cw;
                  `ex_cs: argb=cs;
                  `ex_cn: argb=cn;             
                  `ex_ce: argb=ce;
                  endcase  
    end// id_ext
    
    endcase
    
    
    case(opcode)
    `add: ;// the add
    `mull: ;// the mull
    `move: ;// the move
    `set: ;// the set
    endcase
    end
endmodule
