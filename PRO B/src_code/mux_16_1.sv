//basic and simple muxer , to get the read data we wanted 

module  mux_16_1(
   input logic [63:0] din_0 ,din_1 ,din_2 ,din_3 ,din_4 ,din_5 ,din_6 ,din_7 , 
   input logic [63:0] din_8 ,din_9 ,din_10 ,din_11 ,din_12 ,din_13 ,din_14 ,din_15 ,  
   input logic [3:0] sel   , 
   output logic [63:0] mux_out 
  );
 
always @ (*)
   begin
   case (sel) 
	4'd0 : mux_out = din_0;
	4'd1 : mux_out = din_1;	
	4'd2 : mux_out = din_2;
	4'd3 : mux_out = din_3;
	4'd4 : mux_out = din_4;
	4'd5 : mux_out = din_5;
	4'd6 : mux_out = din_6;
	4'd7 : mux_out = din_7;
	4'd8 : mux_out = din_8;
	4'd9 : mux_out = din_9;
	4'd10 : mux_out = din_10;
	4'd11 : mux_out = din_11;
	4'd12 : mux_out = din_12;
	4'd13 : mux_out = din_13;
	4'd14 : mux_out = din_14;
	4'd15 : mux_out = din_15;
   endcase 
  end 

  
 endmodule 
