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


module sysArray #(parameter N = 4) (inp,out); 
input inp; 
output out; 
wire [N-1:0] inp; 
wire outCs [N-1:0][N-1:0]; 

wire  WLR [N-2:0][N-1:0]; //left to right wires
wire  WRL [N-2:0][N-1:0]; //right to left wires
wire  WUD [N-1:0] [N-2:0]; //up down wires
wire  WDU [N-1:0] [N-2:0]; //down UP wires
reg enable[N-1:0][N-1:0];
reg clk, reset; 
genvar X,Y; 

///////////////////////////////////////////////////////////////////////////////////////////////////////
//update of wlr/wrl/wdu/wud 

// left to right
for (X=0; X < N-1; X=X+1) 
begin 
 for (Y=0; Y < N; Y=Y+1) 
  begin  
   assign WLR[X][Y]=outCs[X][Y];
  end 
end 

// right to left
for (X=0; X < N-1; X=X+1) 
begin 
 for (Y=0; Y < N; Y=Y+1) 
  begin  
   assign WRL[X][Y]=outCs[X+1][Y];
  end 
end 

// up to down
for (X=0; X < N; X=X+1) 
begin 
 for (Y=0; Y < N-1; Y=Y+1) 
  begin  
   assign WUD[X][Y]=outCs[X][Y];
  end 
end 

// down to up
for (X=0; X < N; X=X+1) 
begin 
 for (Y=0; Y < N-1; Y=Y+1) 
  begin  
   assign WDU[X][Y]=outCs[X][Y+1];
  end 
end 

//end the update of wlr/wrl/wdu/wud
///////////////////////////////////////////////////////////////////////////////////////////////////////



generate // middle proccesors 
for (X=1; X < N-1; X=X+1) 
begin 
 for (Y=1; Y < N-1; Y=Y+1) 
  begin  
   cpu1 pe(WLR [X-1][Y]  , WDU[X][Y]  ,    WUD[X][Y-1]   ,WRL[X][Y]   ,outCs[X][Y],clk,enable[X][Y],X,Y );
  end 
end 
endgenerate 

generate // left side between corners
for (Y=1; Y < N-1; Y=Y+1) 
  begin  
cpu1 plm(0            ,     WDU[0][Y]  ,    WUD[0][Y-1]           ,WRL[0][Y]   ,outCs[0][Y],clk,enable[0][Y],0,Y );
end 
endgenerate 

generate // right side between corners
for (Y=1; Y < N-1; Y=Y+1) 
  begin  
cpu1 prm(WLR[N-2][Y]            ,     WDU[N-1][Y]  ,    WUD[N-1][Y-1]    , 0         ,outCs[N-1][Y],clk,enable[N-1][Y],N-1,Y );
end 
endgenerate 

generate //down side between corners
for (X=1; X < N-1; X=X+1) 
begin 
cpu1 pdm( WLR[X-1][N-1]            ,    0   ,    WUD[X][N-2]    , WRL[X][N-1]         ,outCs[X][N-1],clk,enable[X][N-1],X,N-1 );
end 
endgenerate

generate //upper side between corners
for (X=1; X < N-1; X=X+1) 
begin 
cpu1 pum( WLR[X-1][0]            ,    WDU[X][0]   ,    0    , WRL[X][0]         ,outCs[X][0],clk,enable[X][0],X,0 );
end 
endgenerate 

// the up left angel
generate
cpu1 pul(0            ,     WDU[0][0]  ,    0           ,WRL[0][0]   ,outCs[0][0],clk,enable[0][0],0,0);
endgenerate

// the up right angel
generate
cpu1 pur(WLR[N-1][0],        WDU[N-1][0] ,    0             ,0         ,outCs[N-1][0],clk,enable[N-1][0],N-1,0);
endgenerate

// the down right angel
generate
cpu1 pdr(WLR[N-2][N-1],       0      ,   WUD[N-1][N-2]     ,0        ,outCs[N][N],clk,enable[N][N]);
endgenerate

// the down left angel
generate
cpu1 pdl(0             ,      0       ,WUD[0][N-2]   ,  WRL[0][N-1]  ,outCs[0][N-1],clk,enable[0][N-1],0,N-1);
endgenerate 



endmodule
