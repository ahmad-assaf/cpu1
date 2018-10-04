//this is out CVT table ,which contain 128 threads ( in the original project it's 2014)


module CVT_17_10(clk,rst,ReadSel,WriteSel,ReadReg,WriteReg1,WriteData1,W_en,R_en,ReadData);
 
input[4:0] ReadReg,WriteReg1;  // number of BBs , ROWS in CVT
input[63:0] WriteData1;//out data , from CVU
input W_en,R_en ,clk,rst; //logics to start the cycle , rst, enable read,enable write
input  [3:0] ReadSel,WriteSel; //which column to read or to write from , ( int our case we 2 columns , tow Register files)

output[63:0] ReadData; //our output , the data we read


logic[63:0] ReadData1, ReadData2, ReadData3, ReadData4, ReadData5, ReadData6, ReadData7, ReadData8;
logic[63:0] ReadData9, ReadData10, ReadData11, ReadData12, ReadData13, ReadData14, ReadData15, ReadData16;

//there's a MUX that can decide which data from the registers to select 
//*********//
 //Sel Is for ,select which register file to enable read or write from , for the use of decoder 
logic [15:0] W_en1;
logic [15:0] R_en1;

//out components register file
 RegisterFile_single RegisterFile_single_U1(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[0]),.ModeRead(R_en1[0]),.ReadData(ReadData1));

RegisterFile_single RegisterFile_single_U2(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[1]),.ModeRead(R_en1[1]),.ReadData(ReadData2));

 RegisterFile_single RegisterFile_single_U3(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[2]),.ModeRead(R_en1[2]),.ReadData(ReadData3));

RegisterFile_single RegisterFile_single_U4(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[3]),.ModeRead(R_en1[3]),.ReadData(ReadData4));

 RegisterFile_single RegisterFile_single_U5(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[4]),.ModeRead(R_en1[4]),.ReadData(ReadData5));

RegisterFile_single RegisterFile_single_U6(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[5]),.ModeRead(R_en1[5]),.ReadData(ReadData6));

 RegisterFile_single RegisterFile_single_U7(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[6]),.ModeRead(R_en1[6]),.ReadData(ReadData7));

RegisterFile_single RegisterFile_single_U8(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[7]),.ModeRead(R_en1[7]),.ReadData(ReadData8));

 RegisterFile_single RegisterFile_single_U9(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[8]),.ModeRead(R_en1[8]),.ReadData(ReadData9));

RegisterFile_single RegisterFile_single_U10(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[9]),.ModeRead(R_en1[9]),.ReadData(ReadData10));

 RegisterFile_single RegisterFile_single_U11(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[10]),.ModeRead(R_en1[10]),.ReadData(ReadData11));

RegisterFile_single RegisterFile_single_U12(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[11]),.ModeRead(R_en1[11]),.ReadData(ReadData12));

 RegisterFile_single RegisterFile_single_U13(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[12]),.ModeRead(R_en1[12]),.ReadData(ReadData13));

RegisterFile_single RegisterFile_single_U14(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[13]),.ModeRead(R_en1[13]),.ReadData(ReadData14));

 RegisterFile_single RegisterFile_single_U15(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[14]),.ModeRead(R_en1[14]),.ReadData(ReadData15));

RegisterFile_single RegisterFile_single_U16(.clk(clk),.rst(rst), .ReadReg(ReadReg),.WriteReg1(WriteReg1),.WriteData1(WriteData1),.ModeWrite(W_en1[15]),.ModeRead(R_en1[15]),.ReadData(ReadData16));

//our mux , we dont have more the 2 registers so we put zeroes instead
  mux_16_1  mux_16_1_U1(.din_0(ReadData1) ,.din_1(ReadData2) ,.din_2(ReadData3) ,.din_3(ReadData4) ,.din_4(ReadData5),.din_5(ReadData6),.din_6(ReadData7) ,.din_7(ReadData8), .din_8(ReadData9),.din_9(ReadData10),.din_10(ReadData11) ,.din_11(ReadData12) ,.din_12(ReadData13),.din_13(ReadData14) ,.din_14(ReadData15) ,.din_15(ReadData16) ,  
     .sel(ReadSel), .mux_out(ReadData) );

//our decoder , for the write mode and the read mode 
 dec_w_16_1 dec_16_1_U1(.binary_in(WriteSel),.en(W_en),.R_en(W_en1));//to whom to write 
 dec_16_1 dec_16_1_U2(.binary_in(ReadSel),.en(R_en),.R_en(R_en1));//to whom to read 


  endmodule
