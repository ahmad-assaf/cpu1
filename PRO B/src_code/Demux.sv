// generic Demux

module Demux(d_in,updated_data);
parameter Demux_width=32;
parameter sel_width=5;

input [sel_width-1:0] d_in;//offset
output [Demux_width-1:0] updated_data;//demux for the d_in

logic [Demux_width-1:0] updated_data1;
assign updated_data=updated_data1;
always @*
    begin
	updated_data1='d0;
	updated_data1[d_in]=1'b1;	
			
 end
endmodule
