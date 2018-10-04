//this the image you saw on our skype conv ,
//here we connect our components 
//your TESTBENCH should give all the inputs 





module project(clk,rst,W_req,R_req,WriteReg,offset,d_in, CVU_OUT_bitmap, CVU_OUT_baseID,cur_running_BB,threads_terminated, waiting_THDs);
//INPUTS
input rst,clk;
input R_req,W_req;//read ,write enable
input [4:0] WriteReg;//which BB to write to 
input [9:0] offset ; //which reg file to write to ,which colomn in CVT (offest,d_in)
input [63:0] d_in; //our data to write , from CVU 

//OUTPUTS

output [63:0] CVU_OUT_bitmap; //our outputs according to the paper
output [9:0] CVU_OUT_baseID; //our outputs according to the paper
output [4:0] cur_running_BB; //which BB is running right now
output threads_terminated;
output [10:0] waiting_THDs;


//*** LOGICS

logic choose_en1, choose_en, R_req_wire, choose_delayed_1; // from ctrl_read_mode to BB_to_RUN ,choose you next basic block
logic [9:0] ReadSel1; //from ctrl_read_mode to CVT, read from the next RF , same ROW next col  
logic [4:0] ReadRegOUT;// FROM BB TO RUN TO CVT ,which BB now to read or to write 
logic [10:0] term_count, init_count, waitnig_threads, waitnig_threads_old;

assign ReadSel1[5:0]=6'b000000;//offset of 64'bits
assign CVU_OUT_baseID=ReadSel1; //which RF is being read now 
assign cur_running_BB=ReadRegOUT;
assign threads_terminated = waitnig_threads_old[10];
assign choose_en = choose_en1 && waitnig_threads_old[10] && !(init_count);
assign R_req_wire = R_req && (((choose_en1 & choose_en) && !(init_count)) || (~choose_en1 & ~choose_en)) ;
assign waiting_THDs = waitnig_threads_old;
always_comb
begin
	if (rst) begin
		waitnig_threads = 11'd1024;
	end	
	else begin
		waitnig_threads = waitnig_threads_old + term_count - init_count;
	end
end

//basic block sequencer , 
BB_Seq BB_Seq_U1(.clk(clk), .rst(rst), .en(W_req), .choose_en(choose_en), .Sel(WriteReg[4:0]), .BB_To_Run(ReadRegOUT));
 //CVT
CVT_17_10 CVT_1_U1(.clk(clk),.rst(rst),.ReadSel(ReadSel1[9:6]),.WriteSel(offset[9:6]), .ReadReg(ReadRegOUT),.WriteReg1(WriteReg),.WriteData1(d_in),.W_en(W_req),.R_en(R_req_wire),.ReadData(CVU_OUT_bitmap));
//control read mode 
ctrl_read_mode ctrl_read_mode_U1(.clk(clk),.rst(rst),.count_en(R_req_wire),.Sel(ReadSel1[9:6]),.Choose_en(choose_en1));

count_ones U_term_count(.en(W_req),.d_in(d_in),.result(term_count));

count_ones U_init_count(.en(1'b1),.d_in(CVU_OUT_bitmap),.result(init_count));
register_buffer #(11) U_waiting_threads(.clk(clk),.rst(1'b0),.d_in(waitnig_threads),.ld_en(1'b1),.d_out(waitnig_threads_old));

register_buffer #(1) U_choose_delay_1(.clk(clk),.rst(rst),.d_in(choose_en),.ld_en(1'b1),.d_out(choose_delayed_1));

endmodule




