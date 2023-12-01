module Systolic_Array_Architecture_test;
parameter N = 32;
reg clk,init,rst;
wire complete;
reg[7:0] base_address_A,base_address_B,base_address_C;
integer i;
Systolic_Array_Architecture DUT(init,rst,complete,clk,base_address_A,base_address_B,base_address_C);
initial begin
    clk=0;
    init=0;
    rst=1;
    DUT.MFS.MFA.IOF.CN.state=2'b00;
    DUT.MFS.MFB.IOF.CN.state=2'b00;
    DUT.MFS.SAC.SAC.C1.state=2'b00;
    DUT.FM.SM.CN.state=2'b00;
    base_address_A={8{1'b0}};
    base_address_B={8{1'b0}};
    base_address_C={8{1'b0}};
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/index.txt",DUT.MFS.MFA.IOF.CB.LM.mem);
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/index.txt",DUT.MFS.MFB.IOF.CB.LM.mem);
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/matrix_A.txt",DUT.MFS.MFA.IOF.CB.MEM.mem);
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/matrix_B.txt",DUT.MFS.MFB.IOF.CB.MEM.mem);
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/Write_matrix.txt",DUT.FM.SM.CB.LM.mem);
    #10 init=1;rst=0;
    #10 init=0;
    #990 init=1;
    for(i=0;i<25;i=i+1)begin
      $display("%d=%d ",i,DUT.FM.SM.CB.MEM.mem[i]);
    end
    #10 $finish;
end
always #5 clk=~clk;
initial begin
    $dumpfile("Systolic_Array_Architecture_test.vcd");
    $dumpvars(0,Systolic_Array_Architecture_test);
end
endmodule