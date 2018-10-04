
module First_Index(d_in,Index,request_batch,updated_data);
parameter SIZE = 64;
parameter log_SIZE = 6; 
input [SIZE-1:0] d_in;
output logic [log_SIZE-1:0] Index ;//First one in data (call this module in a loop to get a correct output.
output logic request_batch;
output [SIZE-1:0] updated_data;

logic [log_SIZE:0] i;
logic flag;
logic [SIZE-1:0] updated_data1;
assign Index=i[log_SIZE-1:0];
assign request_batch=flag;
assign updated_data=updated_data1;
always @*
    begin
	updated_data1=d_in;
	flag=1'b0;
          for( i = 0; i<SIZE; i = i + 6'b000001) begin
    		if(d_in[i] == 1) begin 
			break ;
		end
 	 end
		

	 if( i==SIZE ) begin //finish reading all the packet , Request new packet
		flag=1'b1;
	end
	else begin
		updated_data1[i]=1'b0;
	end
		
 end
endmodule
