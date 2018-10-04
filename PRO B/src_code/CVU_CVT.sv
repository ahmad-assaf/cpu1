module CVU_CVT(clk,rst, config, ctrl, token_valid, BB_target_1, BB_target_2, token_buffer, force_w,CUDA_Tid, baseID_read_from_CVT, 

BB_index_out, cur_running_BB, send_batch, threads_terminated, bitmap_read_from_CVT);

input clk,rst;  

input config, ctrl, token_valid;
input [4:0] BB_target_1, BB_target_2;
input [9:0] token_buffer;
input force_w;

output [9:0] CUDA_Tid, baseID_read_from_CVT;
output [4:0] BB_index_out, cur_running_BB;
output send_batch, threads_terminated;
output [63:0] bitmap_read_from_CVT;
logic R_req, send_batch_wire;
logic [63:0] bitmap_write_to_CVT, bitmap_read_from_CVT;
logic [9:0] baseID_read_from_CVT, baseID_write_to_CVT, baseID_write_to_CVT_wire;
logic [4:0] BB_num_write_to_CVT;
logic [10:0] waiting_threads;
assign send_batch = send_batch_wire | force_w;
assign baseID_write_to_CVT =  baseID_write_to_CVT_wire & 10'h3c0;

CVU_init_kamal U1_CVU_init(.clk(clk),.rst(rst),.term_init(1'b0),.Base_ID(baseID_read_from_CVT),.Bit_map(bitmap_read_from_CVT),.config(config), .ctrl(ctrl), .token_valid(token_valid), .BB_target_1(BB_target_1), .BB_target_2(BB_target_2), .token_buffer(token_buffer), .waiting_threads(waiting_threads), .request_batch(R_req),.CUDA_Tid(CUDA_Tid), .BB_index_out(BB_index_out), .send_batch(), .To_CVT());

CVU_init_kamal U1_CVU_term(.clk(clk),.rst(rst),.term_init(1'b1),.Base_ID(baseID_read_from_CVT),.Bit_map(bitmap_read_from_CVT),.config(config), .ctrl(ctrl), .token_valid(token_valid), .BB_target_1(BB_target_1), .BB_target_2(BB_target_2), .token_buffer(token_buffer),.waiting_threads(waiting_threads), .request_batch(),.CUDA_Tid(baseID_write_to_CVT_wire), .BB_index_out(BB_num_write_to_CVT), .send_batch(send_batch_wire), .To_CVT(bitmap_write_to_CVT));

project U1_project(.clk(clk),.rst(rst),.W_req(send_batch),.R_req(R_req),.WriteReg(BB_num_write_to_CVT),.offset(baseID_write_to_CVT),.d_in(bitmap_write_to_CVT), .CVU_OUT_bitmap(bitmap_read_from_CVT), .CVU_OUT_baseID(baseID_read_from_CVT), .cur_running_BB(cur_running_BB),.threads_terminated(threads_terminated), .waiting_THDs(waiting_threads));

endmodule
