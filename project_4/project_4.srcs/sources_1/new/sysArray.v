`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2018 01:12:10 PM
// Design Name: 
// Module Name: sysArray
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


module sysArray #(parameter N = 4) (inp1,inp2,out); 
input inp1,inp2; 
output out; 
wire [31:0] inp1 [N-1:0];
wire [31:0] inp2 [N-1:0]; 
wire [31:0] out [N-1:0][N-1:0]; 
wire [31:0] outCs [N-1:0][N-1:0]; 
wire [31:0] WLR [N-2:0][N-1:0]; //left to right wires
wire [31:0] WRL [N-2:0][N-1:0]; //right to left wires
wire [31:0] WUD [N-1:0] [N-2:0]; //up down wires
wire [31:0] WDU [N-1:0] [N-2:0]; //down UP wires
//reg enable[N-1:0][N-1:0];
reg clk, reset; 
genvar X,Y; 




generate // middle proccesors 
for (X=1; X < N-1; X=X+1) 
begin 
 for (Y=1; Y < N-1; Y=Y+1) 
  begin  
   cpu1 pe(WLR [X-1][Y]  , WDU[X][Y]  ,    WUD[X][Y-1]   ,WRL[X][Y]   ,outCs[X][Y],clk,X,Y );
   assign WDU[X][Y] = outCs[X][Y+1];
   assign WUD[X][Y-1] = outCs[X][Y-1];
   assign WLR [X-1][Y] = outCs[X-1][Y];
   assign WRL[X][Y] = outCs[X+1][Y];
  end 
end 
endgenerate 

generate // left side between corners
for (Y=1; Y < N-1; Y=Y+1) 
  begin  
cpu1 plm(inp1[Y]            ,     WDU[0][Y]  ,    WUD[0][Y-1]           ,WRL[0][Y]   ,outCs[0][Y],clk,0,Y );
assign WUD[0][Y-1] = outCs[0][Y-1];
assign WRL[0][Y] = outCs[1][Y];
assign WDU[0][Y] = outCs[0][Y+1];
end 
endgenerate 

generate // right side between corners
for (Y=1; Y < N-1; Y=Y+1) 
  begin  
cpu1 prm(WLR[N-2][Y]            ,     WDU[N-1][Y]  ,    WUD[N-1][Y-1]    , 0         ,outCs[N-1][Y],clk,N-1,Y );
assign WUD[N-1][Y-1] = outCs[N-1][Y-1];
assign WLR[N-2][Y] = outCs[N-2][Y];
assign WDU[N-1][Y] = outCs[N-1][Y+1];
end 
endgenerate 

generate //down side between corners
for (X=1; X < N-1; X=X+1) 
begin 
cpu1 pdm( WLR[X-1][N-1]            ,    0   ,    WUD[X][N-2]    , WRL[X][N-1]         ,outCs[X][N-1],clk,X,N-1 );
assign WUD[X][N-2] = outCs[X][N-2];
assign WLR[X-1][N-1] = outCs[X-1][N-1];
assign WRL[X][N-1] = outCs[X+1][N-1];
end 
endgenerate

generate //upper side between corners
for (X=1; X < N-1; X=X+1) 
begin 
cpu1 pum( WLR[X-1][0]            ,    WDU[X][0]   ,    inp2[X]    , WRL[X][0]         ,outCs[X][0],clk,X,0 );
assign WDU[X][0] = outCs[X][1];
assign WLR[X-1][0] = outCs[X-1][0];
assign WRL[X][0] = outCs[X+1][0];
end 
endgenerate 

// the up left angel
generate
cpu1 pul(inp1[0]            ,     WDU[0][0]  ,    inp2[0]           ,WRL[0][0]   ,outCs[0][0],clk,0,0);
assign WDU[0][0] = outCs[0][1];
assign WRL[0][0] = outCs[1][0];
endgenerate

// the up right angel
generate
cpu1 pur(WLR[N-2][0],        WDU[N-1][0] ,    inp2[N-1]             ,0         ,outCs[N-1][0],clk,N-1,0);
assign WDU[N-1][0] = outCs[N-1][1];
assign WLR[N-2][0] = outCs[N-2][0];
endgenerate

// the down right angel
generate
cpu1 pdr(WLR[N-2][N-1],       0      ,   WUD[N-1][N-2]     ,0        ,outCs[N-1][N-1],clk,N-1,N-1);
assign WUD[N-1][N-2] = outCs[N-1][N-2];
assign WLR[N-2][N-1] = outCs[N-2][N-1];
endgenerate

// the down left angel
generate
cpu1 pdl(inp1[N-1]            ,      0       ,WUD[0][N-2]   ,  WRL[0][N-1]  ,outCs[0][N-1],clk,0,N-1);
assign WUD[0][N-2] = outCs[0][N-2];
assign WRL[0][N-1] = outCs[1][N-1];
endgenerate 

always  
      begin 
       #1 clk = !clk;
       end
       
endmodule
