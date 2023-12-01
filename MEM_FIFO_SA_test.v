module MEM_FIFO_SA_test;
parameter N = 32;
reg init,clk,rst;
reg[7:0] base_address_A,base_address_B;
wire[N-1:0] A0_out,A1_out,A2_out,A3_out,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out;
MEM_FIFO_SA DUT(init,clk,rst,base_address_A,base_address_B,A0_out,A1_out,A2_out,A3_out,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out);
initial begin
    clk=0;
    rst=1;
    init=0;
    DUT.MFA.IOF.CN.state=2'b00;
    DUT.MFB.IOF.CN.state=2'b00;
    DUT.SAC.SAC.C1.state=2'b00;
    base_address_A={8{1'b0}};
    base_address_B={8{1'b0}};
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/index.txt",DUT.MFA.IOF.CB.LM.mem);
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/index.txt",DUT.MFB.IOF.CB.LM.mem);
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/matrix_A.txt",DUT.MFA.IOF.CB.MEM.mem);
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/matrix_B.txt",DUT.MFB.IOF.CB.MEM.mem);
    #10 init=1;rst=0;
    #10 init=0;
    #1000 $finish;
end
always #5 clk=~clk;
initial begin
    $dumpfile("MEM_FIFO_SA_test.vcd");
    $dumpvars(0,MEM_FIFO_SA_test);
end
endmodule