

module ctrl_terminate(ctrl, condition, cur_batch, token_valid, token_buffer, old_data, batch_base, waiting_threads, updated_data_1, updated_data_2, send_batch, new_batch);

input ctrl, condition, cur_batch, token_valid;
/*
ctrl - 1 bit indictation of the target of the terminated threads.
condition - 1 bit indication of the target of the bitmap being accumulated.
cur_bath - indictation of the current accumulation buffer in use.
token_valid - indication if the terminated TID is valid.
*/
input [9:0] token_buffer; //terminated TID
input [63:0] old_data; // bitmap prior to joining the current TID 
input [3:0] batch_base; // baseId of the bitmap
input [10:0] waiting_threads; // num of waiting threads in CVT excluding the Bitmap we are holding

output [63:0]  updated_data_1, updated_data_2;  // the new bitmaps to be written to the buffers1/2 after joining the current TID 
output send_batch, new_batch;

logic [63:0] Demux_out, updated_data_1_wire, updated_data_2_wire;
logic send_batch_wire, new_batch_wire;
logic [10:0] waiting_threads_updated, batch_waiting_thds;
assign updated_data_1=updated_data_1_wire;
assign updated_data_2=updated_data_2_wire;
assign send_batch=send_batch_wire;
assign new_batch=new_batch_wire;

always @* begin 
		
		waiting_threads_updated = batch_waiting_thds + waiting_threads; 
		new_batch_wire=cur_batch;
		send_batch_wire=1'b0;
		if (token_valid) begin
			if(ctrl==condition && token_buffer[9:6]==batch_base) begin
				if (cur_batch==1'b0) begin
					updated_data_1_wire=old_data | Demux_out;
					updated_data_2_wire=64'b0;
				end
				else begin
					updated_data_2_wire=old_data | Demux_out;
					updated_data_1_wire=64'b0;
				end
			end
			else begin
				send_batch_wire=1'b1;
				if (cur_batch==1'b0) begin
					updated_data_2_wire= Demux_out;
					updated_data_1_wire=64'b0;
				end
				else begin
					updated_data_1_wire= Demux_out;
					updated_data_2_wire=64'b0;
				end
				new_batch_wire=~cur_batch;
			end
		end
		else begin
			if (waiting_threads_updated[10]==1'b1) begin
					updated_data_1_wire=64'b0;
					updated_data_2_wire=64'b0;
					send_batch_wire=1'b1;
			end
			else begin
				if (cur_batch==1'b0) begin
					updated_data_1_wire=old_data;
					updated_data_2_wire=64'b0;
				end
				else begin
					updated_data_2_wire=old_data;
					updated_data_1_wire=64'b0;
				end
				
			end	
		end
						
end

Demux #(64,6)U_Demux(.d_in(token_buffer[5:0]),.updated_data(Demux_out));
count_ones U_count_ones(1'b1,old_data, batch_waiting_thds);
endmodule 
