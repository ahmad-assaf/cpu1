//*****************
module test_bench;

logic clk, rst;
logic [23:0] input_token, input_token_wire, last_poped;

//************OUTPUT*********
logic [9:0] last_initiated;
logic [31:0] output_token;
logic [63:0] bitmap_read_from_CVT;
logic [23:0] queue[$]={0};
integer data_file,scan_file; // file handler

`define NULL 0 

initial begin
rst=1;
clk=0;
input_token = 22'b0;
data_file = $fopen("./vgiw_inv_mapping.txt_parsed", "r");
  if (data_file == `NULL) begin
    $display("data_file handle was NULL");
    $finish;
  end

#10 
scan_file = $fscanf(data_file, "%d\n", input_token_wire);
queue.push_back(input_token_wire);
last_poped = queue.pop_front();
last_initiated = 10'b0;
rst =0;
end


always begin
#5 clk=~clk;
end
always @(negedge clk) begin
 
	if (!$feof(data_file)) begin
    		scan_file = $fscanf(data_file, "%d\n", input_token_wire);
		queue.push_back(input_token_wire);
  	end

	if (last_initiated[9:6] >= last_poped[22:19]) begin
 		input_token = last_poped;
		if (queue.size()) begin
			last_poped = queue.pop_front();
		end
	end
	else begin
		input_token = 0;
	end
	last_initiated = output_token[9:0];
	if (!queue.size()) begin
 		#10
		$finish;
		$fclose(data_file);		
	end
end


TOP_model U_TOP_model(.*);
endmodule
