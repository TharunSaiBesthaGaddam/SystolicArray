module Systolic_Array_with_Controller_test;
parameter N=32;
parameter M=25;
reg[N-1:0] A0,A1,A2,A3,A4,B0,B1,B2,B3,B4;
wire[N-1:0] A0_out,A1_out,A2_out,A3_out,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out;
reg init,clk;
reg[N-1:0] regA[0:44];
reg[N-1:0] regB[0:44];
integer i;
Systolic_Array_with_Controller DUT(init,clk,A0,A1,A2,A3,A4,B0,B1,B2,B3,B4,A0_out,A1_out,A2_out,A3_out,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out);
initial begin
    clk=0;
    init=1'b1;
    DUT.SAC.C1.state=2'b00;
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/A.txt",regA);
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/B.txt",regB);
    #10 init=1'b0;
    #500 $finish;
end
initial begin
    for(i=0;i<9;i=i+1)begin
    #10  A0=regA[i*5+0];
      A1=regA[i*5+1];
      A2=regA[i*5+2];
      A3=regA[i*5+3];
      A4=regA[i*5+4];
      B0=regB[i*5+0];
      B1=regB[i*5+1];
      B2=regB[i*5+2];
      B3=regB[i*5+3];
      B4=regB[i*5+4];
    end
end
always #5 clk=~clk;
initial begin
    $dumpfile("Systolic_Array_with_Controller_test.vcd");
    $dumpvars(0,Systolic_Array_with_Controller_test);
end
endmodule