//basic and simple muxer , to get the read data we wanted 

module  mux_2_1(din_0 ,din_1, sel, mux_out);
parameter DIN_W=64;

input logic [DIN_W-1:0] din_0 ,din_1; 
input logic sel; 
output logic [DIN_W-1:0] mux_out; 
 
always @ (*)
   begin
   case (sel) 
	1'd0 : mux_out = din_0;
	1'd1 : mux_out = din_1;	
   endcase 
  end 

  
 endmodule 
