//our RF ,contain table with 20 rows each row with the  size of 64bits 



module RegisterFile_single(clk,rst, ReadReg,WriteReg1,WriteData1,ModeWrite,ModeRead,ReadData);
parameter BBS=32;//number of basic blocks
 
input[4:0] ReadReg,WriteReg1; //which row to read /write from
input[63:0] WriteData1; //our data , in case of writing 
input ModeWrite,clk,rst,ModeRead; //clock ,reset , enable reading , enable writing 


output[63:0] ReadData; //in case of reading , this would be our output data read 


logic[63:0] ReadData;

logic[63:0] regFile [BBS-1:0]; //the table which each RF has 



integer i;

	
	always @(posedge clk or posedge rst) begin

	   if(rst==1) begin //fill the fisr line ALWAYS with ones , this's our initial state according to papers

		regFile[0]<=64'b1111111111111111111111111111111111111111111111111111111111111111; //64 ones
		  ReadData <= 64'd0;
		for(i=1; i<BBS ; i=i+1)begin
			regFile[i] <= 64'd0; //all the rest contain zeros 
		end
	end

		else begin
			if(ModeWrite) begin // add threads to the row of WriteReg1 (CVU decide what and where to write), do OR logic , according to papers
				regFile[WriteReg1] <= regFile[WriteReg1] | WriteData1 ;
			end
		

			if(ModeRead) begin //after reading the line , get the data and make sure to fill the same line with ZEROS
		       		ReadData <= regFile[ReadReg];
				regFile[ReadReg] <=64'd0;

			end
			else begin
				ReadData <=64'd0;	
			end

		

		end
	end


endmodule
