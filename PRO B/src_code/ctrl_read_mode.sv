
module ctrl_read_mode(clk,rst,count_en,Sel,Choose_en);

input clk,rst;
input count_en;
output  logic [3:0] Sel;
output logic Choose_en; //choose_en: control wire, when enabled we the next BB to run is chosen based on CVT state
logic [3:0] Counter; // holds BASE_iD of the last bitmap read from CVT.
logic [3:0] old_count;
assign Sel=Counter;

	always @(posedge clk) begin

	   if(rst==1) begin
			Counter <=4'b1111; //that's why we start counting from 0 not 1
			
			Choose_en<=1'b0;
		end

		else begin
				old_count<=Counter;
			if(((Counter==4'b1110) && count_en) || Counter==4'b1111 && ~count_en  ) begin //in the big project it should be 4'b1111
				Choose_en<=1'b1;
				
			end
			else begin
				Choose_en<=1'b0;
				
			end
			if(count_en) begin
			Counter <= Counter + 4'b0001;
			end
		

		end
	end


  endmodule
 
