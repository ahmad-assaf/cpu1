//generic register with adjustable width

module register_buffer(clk,rst,d_in,ld_en,d_out);
parameter WIDTH = 64;
input clk,rst,ld_en;
input [WIDTH-1:0] d_in;
output logic [WIDTH-1:0] d_out;

logic [WIDTH-1 :0] store;
assign d_out=store;
always @(posedge clk or posedge rst) begin
	if(rst==1) begin
		store ='b0; // rst as the WIDTH
	end
	else begin
		if(ld_en==1'b1) begin //we have new word , load the new one 
		store=d_in;
		end
	end
end
endmodule 
