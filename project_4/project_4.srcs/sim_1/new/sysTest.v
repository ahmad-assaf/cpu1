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
    
    reg [N*(32)-1:0] mat1 [N-1:0];
    reg [N*(32)-1:0] mat2[N-1:0];
    reg [31:0] cwRegs[N-1:0];
    reg [31:0] cnRegs [N-1:0];
    reg[3:0] i,j;
    
    initial
    begin
            $readmemb("E:\\test\\testb.txt",mat1);
            $readmemb("E:\\test\\testb.txt",mat2);
             for(i=0 ; i <N; i=i+1)
                   begin
                   cwRegs[i]<= mat1[i] [N*(32)-1:(N-1)*(32)-1];
                   cnRegs[i]<= mat2[i] [N*(32)-1:(N-1)*(32)-1];
                   end
    end
    always
    begin
        for(j=0;j<N;j=j+1)
        begin
            for(i=0 ; i <N; i=i+1)
                  begin
                   cwRegs[i]<= mat1[i] [N*(32)-1:(N-1)*(32)-1];
                   cnRegs[i]<= mat2[i] [N*(32)-1:(N-1)*(32)-1];
                  end
              #4;
        end
    end
    
    
endmodule
