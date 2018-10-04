//this our algorithm , we did it according to the suggestion of the paper. (we searched for something else but we went back to papers)
//we ALWAYS run the BB with the minmum number(serial num) which had at least one thread ready to go on .





module BB_Seq(clk,rst,en,choose_en,Sel,BB_To_Run);
parameter BBS1=32;//number of basic blocks
parameter log_BBS1=5;

input rst,clk,en,choose_en; //rst ,clock ,and ENABLE CHOOSING 
input  [log_BBS1-1:0] Sel; //which BB to write to 
output[log_BBS1-1:0] BB_To_Run;  // the serial number of the BB we chose to run 

logic [log_BBS1-1:0] BB_To_Run, BB_To_Run_after_write, updated_BB_To_Run;

logic [BBS1-1:0] Block_Seq, Block_Seq_old, demux_out, Block_Seq_after_choose, Block_Seq_after_write, updated_Block_Seq;//our array ,every BB with the number of the threads ready to run 
 
assign Block_Seq = Block_Seq_old | demux_out;


register_buffer #(BBS1) Block_seq(.clk(clk),.rst(rst),.d_in(updated_Block_Seq),.ld_en(1'b1),.d_out(Block_Seq_old));

register_buffer #(log_BBS1) U_BB_to_run(.clk(clk),.rst(rst),.d_in(updated_BB_To_Run),.ld_en(1'b1),.d_out(BB_To_Run));

Demux U_Demux(.d_in(Sel),.updated_data(demux_out));

mux_2_1 #(32) mux_2_1_U1(.din_0(Block_Seq_old) ,.din_1(Block_Seq), .sel(en), .mux_out(Block_Seq_after_write));

First_Index #(BBS1,log_BBS1) First_Index_U1(.d_in(Block_Seq_after_write), .Index(BB_To_Run_after_write),.request_batch(),.updated_data(Block_Seq_after_choose));

mux_2_1  #(32) mux_2_1_U2(.din_0(Block_Seq_after_write) ,.din_1(Block_Seq_after_choose), .sel(choose_en), .mux_out(updated_Block_Seq));

mux_2_1  #(log_BBS1) mux_2_1_U3(.din_0(BB_To_Run), .din_1(BB_To_Run_after_write), .sel(choose_en), .mux_out(updated_BB_To_Run));
endmodule
