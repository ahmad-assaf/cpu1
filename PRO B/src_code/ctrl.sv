
module ctrl(clk,rst,trigger,choose, load,load_base_id, current_store_buffer);

input clk,rst;
input trigger; 

output  choose, current_store_buffer;
output [1:0] load, load_base_id;

logic choose_wire, current_store_buffer_wire;
logic [1:0] load_wire, load_base_id_wire;

assign choose=choose_wire;
assign load=load_wire;
assign current_store_buffer=current_store_buffer_wire;
assign load_base_id=load_base_id_wire;
always @ (posedge clk or posedge rst) begin
	if(rst)begin
		load_wire<=2'b00;
		choose_wire<=1'b0;
		current_store_buffer_wire<=1'b0;
		load_base_id_wire<=2'b00;
		//updated_batch=Bit_map;	
	end
	else begin 
		load_base_id_wire<=2'b00;
		if(trigger==1'b1) begin //we need to load new data to the empty store buffer 
			load_wire<=2'b11;
			current_store_buffer_wire<= ~current_store_buffer_wire;
			choose_wire<=current_store_buffer_wire;
			if(current_store_buffer_wire==1'b0) begin
				load_base_id_wire<=2'b01;
			end
			else begin
				load_base_id_wire<=2'b10;
			end

		end
		if(trigger==1'b0) begin
			choose_wire<=~current_store_buffer_wire;
			if(current_store_buffer_wire==1'b0) begin
				load_wire<=2'b01;
			end
			else begin
				load_wire<=2'b10;
			end
		end
	end
			
			
end

endmodule 

