/*
TODO: add waiting thread as input form the CVT, it should reach ctrl_terminate
*/

module CVU_init_kamal(clk,rst,term_init,Base_ID,Bit_map,config, ctrl, token_valid, BB_target_1, BB_target_2, token_buffer, waiting_threads, request_batch,CUDA_Tid, BB_index_out, send_batch, To_CVT);
input clk,rst, term_init; // 0 - init, 1- term. configres the module functionality 
input [9:0] Base_ID ; //for the CVT 
input [63:0] Bit_map ;

input config, ctrl, token_valid;
input [4:0] BB_target_1, BB_target_2;
input [9:0] token_buffer;
input [10:0] waiting_threads;

output  request_batch ;
output [9:0] CUDA_Tid;
output [4:0] BB_index_out;
output send_batch;
output [63:0] To_CVT;

/***************
initiate_wires
****************/

logic [1:0] init_load_base_id;// LOAD base_ID to the suitable store buffer (either the first or the second one)
logic [63:0] FFI_to_MUX;//output from FF
logic [5:0] Index_FFI;
logic request_batch_wire ;//when to get new data or updated one 
logic current_store_buffer;
logic [63:0] register_buffer_data;
logic [63:0] MUX_to_BUFF_1;//register file out , either new batch or updated 
logic [63:0] MUX_to_BUFF_2;//register file out , either new batch or updated 
logic [1:0] init_load;
logic choose; // 1 for updated , 0 for new 

/*******
terminate_wire
*******/

logic [4:0] target_1_to_mux, target_2_to_mux;
logic condition_wire, ctrl_to_cur_batch, cur_batch_to_ctrl;
logic [63:0] ctrl_to_batch_1, ctrl_to_batch_2;
logic [1:0] load_base_id;
logic [1:0] load ;
logic send_batch_wire;

/********
shared_wires
**********/
logic [63:0] register_buffer_data_out1;//from register to MUX
logic [63:0] register_buffer_data_out2;//from register to MUX
logic [3:0] Base_ID_store, last_valid_token, choose_token_buffer_out;//store the base ID
logic [3:0] Base_ID_store_out1;//baseID for store buffer 1
logic [3:0] Base_ID_store_out2;//base for store buffer 2
logic [63:0] From_mux_to_FFI, batch_1, batch_2;//FROM MUX TO FIRST INDEX 
logic sel_current_batch;
logic [9:0] cuda_tid_wire;// our output from [5:0] offset , [9:6] baseID

assign register_buffer_data=Bit_map;
assign request_batch=(request_batch_wire & ~term_init);
assign To_CVT = From_mux_to_FFI;
assign cuda_tid_wire[5:0]=Index_FFI;
assign CUDA_Tid=cuda_tid_wire;
assign send_batch = send_batch_wire & term_init;

/********************
initiate_unites
********************/
ctrl U_controler(.clk(clk),.rst(rst),.trigger(request_batch_wire),.choose(choose), .load(init_load), .load_base_id(init_load_base_id), .current_store_buffer(current_store_buffer));

First_Index First_Index_U1(.d_in( From_mux_to_FFI), .Index(Index_FFI),.request_batch(request_batch_wire),.updated_data(FFI_to_MUX));

mux_2_1 #(64) B_MAP_FFI_1(.din_0(register_buffer_data) ,.din_1(FFI_to_MUX),.sel(choose) ,.mux_out(MUX_to_BUFF_1));

mux_2_1 #(64) B_MAP_FFI_2(.din_0(register_buffer_data) ,.din_1(FFI_to_MUX),.sel(~choose) ,.mux_out(MUX_to_BUFF_2));


/****************
terminate units
****************/
register_buffer #(5) U_target_1(.clk(clk),.rst(rst),.d_in(BB_target_1),.ld_en(config),.d_out(target_1_to_mux));//save target 1

register_buffer #(5) U_target_2(.clk(clk),.rst(rst),.d_in(BB_target_2),.ld_en(config),.d_out(target_2_to_mux));//save target 2

mux_2_1 #(5) U_target_mux_2_1_(.din_0(target_1_to_mux) ,.din_1(target_2_to_mux),.sel(condition_wire) ,.mux_out(BB_index_out));

register_buffer #(1) U_condition(.clk(clk),.rst(rst),.d_in(ctrl),.ld_en(token_valid),.d_out(condition_wire)); //current target in use

register_buffer #(1) U_cur_batch(.clk(clk),.rst(rst),.d_in(ctrl_to_cur_batch),.ld_en(1'd1),.d_out(cur_batch_to_ctrl)); //current target in use

ctrl_terminate U_ctrl_terminate(.ctrl(ctrl), .condition(condition_wire), .cur_batch(cur_batch_to_ctrl), .token_valid(token_valid), .token_buffer(token_buffer), .old_data(From_mux_to_FFI), .batch_base(cuda_tid_wire[9:6]), .waiting_threads(waiting_threads), .updated_data_1(ctrl_to_batch_1), .updated_data_2(ctrl_to_batch_2), .send_batch(send_batch_wire), .new_batch(ctrl_to_cur_batch));

//new changes

register_buffer #(4) U_last_token(.clk(clk),.rst(rst),.d_in(token_buffer[9:6]),.ld_en(token_valid),.d_out(last_valid_token));
mux_2_1 #(4) U_choose_token_buffer(.din_0(last_valid_token) ,.din_1(token_buffer[9:6]),.sel(token_valid) ,.mux_out(choose_token_buffer_out));


/****************
terminate\initiate common units
****************/
register_buffer BIT_MAP_U3(.clk(clk),.rst(rst),.d_in(batch_1),.ld_en(load[0]),.d_out(register_buffer_data_out1));//save the bit_map 64bit

register_buffer #(4) BASE_ID_U3(.clk(clk),.rst(rst),.d_in(Base_ID_store),.ld_en(load_base_id[0]),.d_out(Base_ID_store_out1));//save the base id change to 10bit

register_buffer BIT_MAP_U4(.clk(clk),.rst(rst),.d_in(batch_2),.ld_en(load[1]),.d_out(register_buffer_data_out2));//save the bit_map 64bit

register_buffer #(4) BASE_ID_U4(.clk(clk),.rst(rst),.d_in(Base_ID_store),.ld_en(load_base_id[1]),.d_out(Base_ID_store_out2));//save the base id change to 10bit

mux_2_1 #(4) base_id_mux_2_1_U2(.din_0(Base_ID_store_out1) ,.din_1(Base_ID_store_out2),.sel(sel_current_batch) ,.mux_out(cuda_tid_wire[9:6])); 

mux_2_1 #(64) bit_map_mux_2_1_U2(.din_0(register_buffer_data_out1) ,.din_1(register_buffer_data_out2),.sel(sel_current_batch) ,.mux_out(From_mux_to_FFI));

mux_2_1 #(4) term_init_Base_Id(.din_0(Base_ID[9:6]) ,.din_1(choose_token_buffer_out),.sel(term_init) ,.mux_out(Base_ID_store)); //mux for sel. curr Base_ID

mux_2_1 #(1) term_init_Base_ID_sel(.din_0(current_store_buffer) ,.din_1(cur_batch_to_ctrl),.sel(term_init) ,.mux_out(sel_current_batch)); // mux for selecting ID_base from input 

mux_2_1 #(2) term_init_load_batch_sel(.din_0(init_load) ,.din_1(2'b11),.sel(term_init) ,.mux_out(load)); //mux for loading Bit_Map

mux_2_1 #(2) term_init_load_Base_Id_sel(.din_0(init_load_base_id) ,.din_1(2'b11),.sel(term_init) ,.mux_out(load_base_id)); // mux for loading base id

mux_2_1 #(64) term_init_bit_map_mux_2_1_U1(.din_0(MUX_to_BUFF_1) ,.din_1(ctrl_to_batch_1),.sel(term_init) ,.mux_out(batch_1)); // term-init choose batch1 

mux_2_1 #(64) term_init_bit_map_mux_2_1_U2(.din_0(MUX_to_BUFF_2) ,.din_1(ctrl_to_batch_2),.sel(term_init) ,.mux_out(batch_2));// term-init choose batch2








endmodule 
