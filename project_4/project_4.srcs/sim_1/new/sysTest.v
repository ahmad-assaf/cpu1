`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2018 09:30:31 PM
// Design Name: 
// Module Name: sysTest
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


module sysTest#(parameter N = 4)(

    );
    
    reg [31:0] mat1 [2*N-2:0][N-1:0];
    reg [31:0] mat2 [N-1:0][2*N-2:0];
    reg [31:0] cwRegs[N-1:0];
    reg [31:0] cnRegs [N-1:0];
    reg[6:0] i,j;
    
    initial
    begin
            $readmemb("E:\\test\\testb.txt",mat1);
            $readmemb("E:\\test\\testb.txt",mat2);
             for(i=0 ; i <N; i=i+1)                                             // not sure
                   begin
                   cwRegs[i]<= mat1[i][0];
                   cnRegs[i]<= mat2[0][i];
                   end
    end
    always
    begin
        for(j=0;j<N;j=j+1)
        begin
            for(i=0 ; i <N; i=i+1)
                  begin
                   cwRegs[i]<= mat1[j] [i];
                   cnRegs[i]<= mat2[i] [j];
                  end
              #4;
        end
    end
    
    
endmodule
