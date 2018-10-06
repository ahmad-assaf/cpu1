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
    input enable,
    input [3:0] x,
    input [3:0] y
    );
    
    wire[31:0] cw,cn,cs,ce;
    wire clk,enable;
    wire[3:0] x,y;
    reg [31:0] outC;
    reg [31:0] result;
    reg [31:0] myregs[14:0];//we can give 4 bits from the instuction for the destination so 15 regsedter and 1 outC
    reg[3:0] opcode,dest;
    reg[4:0]mode;
    reg[9:0] arga,argb;
    reg [31:0] instructions[100:0];//opcode-Mode-arga-argb-dest
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
    `define sub 4'b0010// the move
    `define set 4'b0011// the set
    
    `define RG0 4'b0000
    `define RG1 4'b0001
    `define RG2 4'b0010
    `define RG3 4'b0011
    `define RG4 4'b0100
    `define RG5 4'b0101
    `define RG6 4'b0110
    `define RG7 4'b0111
    `define RG8 4'b1000
    `define RG9 4'b1001
    `define RG10 4'b1010
    `define RG11 4'b1011
    `define RG12 4'b1100
    `define RG13 4'b1101
    `define RG14 4'b1110
    `define RGout 4'b1111

    //defines
    initial
    begin
     //   $readmemb("D:\\test\\testb.txt",instructions);
          $readmemb("D:\test\testb.txt",instructions,0,31);

    /*    for(i=0 ; i < 100 ; i=i+1)
        begin
        $display("%b",instructions[i]);
        end*/
        opcode <= instructions[pc][31:29];
        mode <= instructions[pc][28:24];
        dest <= instructions[pc][3:0] ;// 4 bits for the destination
    end
    

 
   // mode <= {ins[0],ins[1],ins[2],ins[3]};
    always @(posedge clk) begin
    if(enable == 1)
         begin  
    case(mode)
    `const_const: begin
        arga <= instructions[pc][23:14];
        argb <= instructions[pc][13:4];
     end// conscons 
     
    `reg_reg: begin
        arga <= myregs[instructions[pc][17:14]];
        argb <= myregs[instructions[pc][7:4]];
      end // regreg
        
    `ext_ext: begin
         case(instructions[pc][15:14])
                 `ex_cw: arga<=cw;
                 `ex_cs: arga<=cs;
                 `ex_cn: arga<=cn;             
                 `ex_ce: arga<=ce;
                 endcase
         case(instructions[pc][5:4])
                 `ex_cw: argb<=cw;
                 `ex_cs: argb<=cs;
                 `ex_cn: argb<=cn;             
                 `ex_ce: argb<=ce;
                  endcase             
     end// extext    
    
    
    `id_id: begin
         if(instructions[pc][15:14]== 2'b00 ) begin  
            arga <= x;
            end    
          else begin 
            arga <= y;
           end     
              
           if(instructions[pc][5:4]== 2'b00 )begin
                  argb <= x;
                  end
           else begin
                argb <= y; 
                end
                
           end//idid
               

        
    `out_const: begin
           arga <=outC;//the out
           argb <=instructions[pc][13:4] ; //the const
       end// out_const
       
       
    `out_reg: begin
            arga <=outC;//the out
            argb <=myregs[instructions[pc][7:4]] ; //the const
      end// out_reg
      
    `out_ext: begin
                arga <=outC;//the out
                 case(instructions[pc][5:4])
                    `ex_cw: argb<=cw;
                    `ex_cs: argb<=cs;
                    `ex_cn: argb<=cn;             
                    `ex_ce: argb<=ce;
                    endcase  
    end// out_ext
    
    
    `out_id: begin
        arga <=outC;//the out
          if(instructions[pc][5:4]== 2'b00 )begin
                argb <= x;
                end
          else begin
                argb <= y; 
                end
    end// out_id
    
    
    `reg_const: begin
            arga <= myregs[instructions[pc][17:14]];
            argb <= instructions[pc][13:4];
    end// reg_const
    
    `reg_ext: begin
            arga <= myregs[instructions[pc][17:14]];
            case(instructions[pc][5:4])
                `ex_cw: argb<=cw;
                `ex_cs: argb<=cs;
                `ex_cn: argb<=cn;             
                `ex_ce: argb<=ce;
                endcase       
    end// reg_ext
    
    
    `reg_id: begin
          arga <= myregs[instructions[pc][17:14]];
          if(instructions[pc][5:4]== 2'b00 )begin
                 argb <= x;
                 end
           else begin
                 argb <= y; 
                 end
      end// reg_id
    
    `const_reg: begin
         arga <= instructions[pc][23:14];
         argb <= myregs[instructions[pc][7:4]];
    end// const_reg
    
    
    `const_ext: begin 
         arga <= instructions[pc][23:14];
             case(instructions[pc][5:4])
                 `ex_cw: argb<=cw;
                 `ex_cs: argb<=cs;
                 `ex_cn: argb<=cn;             
                 `ex_ce: argb<=ce;
                 endcase  
     end//const_ext
    
    `const_id:begin
         arga <= instructions[pc][23:14];
         if(instructions[pc][5:4]== 2'b00 )begin
            argb <= x;
            end
         else begin
            argb <= y; 
             end
     end// const_id
    `ext_reg: begin
             case(instructions[pc][15:14])
                     `ex_cw: arga<=cw;
                     `ex_cs: arga<=cs;
                     `ex_cn: arga<=cn;             
                     `ex_ce: arga<=ce;
                     endcase
             argb <= myregs[instructions[pc][7:4]];          

    end// ext_reg
    `ext_const: begin
                case(instructions[pc][15:14])
                        `ex_cw: arga<=cw;
                        `ex_cs: arga<=cs;
                        `ex_cn: arga<=cn;             
                        `ex_ce: arga<=ce;
                        endcase
                argb <= instructions[pc][13:4];          

       end// ext_const 
    `ext_id: begin
                   case(instructions[pc][15:14])
                           `ex_cw: arga<=cw;
                           `ex_cs: arga<=cs;
                           `ex_cn: arga<=cn;             
                           `ex_ce: arga<=ce;
                           endcase
                           
                    if(instructions[pc][5:4]== 2'b00 )begin
                        argb <= x;
                        end
                     else begin
                        argb <= y; 
                        end
      end//ext_id

    `id_reg:begin
                if(instructions[pc][15:14]== 2'b00 ) begin  
                    arga <= x;
                    end    
                else begin 
                    arga <= y;
                    end                     
               argb <= myregs[instructions[pc][7:4]];          
         end // id_reg
    
    `id_const:begin
            if(instructions[pc][15:14]== 2'b00 ) begin  
                arga <= x;
                end    
            else begin 
                arga <= y;
                end   
                
           argb <= instructions[pc][13:4];          
     end // id_const
     
    `id_ext:begin
        if(instructions[pc][15:14]== 2'b00 ) begin  
            arga <= x;
            end    
        else begin 
            arga <= y;
            end   
           
           case(instructions[pc][5:4])
                  `ex_cw: argb=cw;
                  `ex_cs: argb=cs;
                  `ex_cn: argb=cn;             
                  `ex_ce: argb=ce;
                  endcase  
    end// id_ext
    
    endcase

    case(opcode)
    `add: result <= arga+argb ;// the add
    `mull: result <= arga*argb;// the mull
    `sub: result <= arga-argb ;// the move
    `set: result <= arga;// the set
    endcase
    
        case(dest)
        `RG0: myregs[0]= result;
        `RG1: myregs[1]= result;
        `RG2: myregs[2]= result;
        `RG3: myregs[3]= result;
        `RG4: myregs[4]= result;
        `RG5: myregs[5]= result;
        `RG6: myregs[6]= result;
        `RG7: myregs[7]= result;
        `RG8: myregs[8]= result;
        `RG9: myregs[9]= result;
        `RG10: myregs[10]= result;
        `RG11: myregs[11]= result;
        `RG12: myregs[12]= result;
        `RG13: myregs[13]= result;
        `RG14: myregs[14]= result;
        `RGout: outC= result;
        
        
        endcase
        pc=pc+1;
    end
end
endmodule
