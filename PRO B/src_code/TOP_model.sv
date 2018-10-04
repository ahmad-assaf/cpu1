module TOP_model(clk,rst, input_token, output_token, bitmap_read_from_CVT);

input clk, rst;
input [23:0] input_token;
output [31:0] output_token;
output [63:0] bitmap_read_from_CVT;

// config = input_token[0], ctrl = input_token[1], token_valid = input_token[2];
// BB_target_1 = input_token[7:3], BB_target_2 = input_token[12:8];
// token_buffer = input_token[22:13];
//force_w = input_token[23];

// CUDA_Tid = output_token[9:0], baseID_read_from_CVT = output_token[19:10];
// BB_index_out = output_token[24:20], cur_running_BB = output_token[29:25];
// send_batch  = output_token[30], threads_terminated = output_token[31];


CVU_CVT U_CVU_CVT(.clk(clk),.rst(rst), .config(input_token[0]), .ctrl(input_token[1]), .token_valid(input_token[2]), .BB_target_1(input_token[7:3]), .BB_target_2(input_token[12:8]), .token_buffer(input_token[22:13]),.force_w(input_token[23]), .CUDA_Tid(output_token[9:0]), .baseID_read_from_CVT(output_token[19:10]), .BB_index_out(output_token[24:20]), .cur_running_BB(output_token[29:25]), .send_batch(output_token[30]), .threads_terminated(output_token[31]), .bitmap_read_from_CVT(bitmap_read_from_CVT));

endmodule;
