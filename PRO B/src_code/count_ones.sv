//get a packet with 64 bits , count the ones 


module count_ones(en,d_in,result);

input [63:0] d_in;//data
input en; 
output [10:0] result; //how much ones we have in this packet



logic [10:0] count_ones; 
logic [10:0] idx;
assign result=count_ones;
always_comb
begin
	count_ones=0;
	if (en) begin
		for( idx = 0; idx<64; idx = idx + 1) begin
			count_ones = count_ones + d_in[idx];
		end
	end	
end

endmodule
