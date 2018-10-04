//basic and simple decoder , according to the binary_in we decide which RF to write from


module dec_16_1 (
   input  logic [3:0]  binary_in   , //  4 bit binary input
   input logic en,
   output logic [15:0] R_en

 );
  
  always_comb
  begin
   
	
      case (binary_in)
           4'd0  :begin
			 
			if(en)begin
				R_en=16'b0000000000000010;
			end
				else begin
				R_en=16'd0;
				end
		end
	   4'd1  : begin
			if(en)begin
				R_en=16'b0000000000000100;
			end
				else begin
				R_en=16'd0;
				end
			
		end
 	   4'd2  :begin 
			if(en)begin
				R_en=16'b0000000000001000;
			end
				else begin
				R_en=16'd0;
				end
		
		end
 	   4'd3  : begin
			if(en)begin
				R_en=16'b0000000000010000;
			end
				else begin
				R_en=16'd0;
				end
			
		end
 	   4'd4  :begin
			if(en)begin
				R_en=16'b0000000000100000;
			end
				else begin
				R_en=16'd0;
				end
			
		end
	   4'd5  : begin
			if(en)begin
				R_en=16'b0000000001000000;
			end
				else begin
				R_en=16'd0;
				end
			
			end
 	   4'd6  : begin
			if(en)begin
				R_en=16'b0000000010000000;
			end
				else begin
				R_en=16'd0;
				end
			end
           4'd7  : begin
			if(en)begin
				R_en=16'b0000000100000000;
			end
			else begin
				R_en=16'd0;
				end
	
		end
 	   4'd8  :begin 
			if(en)begin
				R_en=16'b0000001000000000;
			end
			else begin
				R_en=16'd0;
				end
			
		end
 	   4'd9  : begin
			if(en)begin
				R_en=16'b0000010000000000;
			end
			else begin
				R_en=16'd0;
				end
		end
 	   4'd10 : begin
			if(en)begin
				R_en=16'b0000100000000000;
			end
			else begin
				R_en=16'd0;
				end
		
		end
	   4'd11 :begin 
			if(en)begin
				R_en=16'b0001000000000000;
			end
			else begin
				R_en=16'd0;
				end
			
			
		end
	   4'd12 : begin
			if(en)begin
				R_en=16'b0010000000000000;
			end
			else begin
				R_en=16'd0;
				end
			
			
		end
 	   4'd13 : begin
			if(en)begin
				R_en=16'b0100000000000000;
			end
			else begin
				R_en=16'd0;
				end
			
		end
 	   4'd14 : begin
		if(en)begin
				R_en=16'b1000000000000000;
			end
			else begin
				R_en=16'd0;
				end
			
			
		end
	   4'd15 : begin
			if(en)begin
				R_en=16'b0000000000000001;
			end
			else begin
				R_en=16'd0;
				end
		end
   
      endcase
    //end
  end
  
  endmodule
