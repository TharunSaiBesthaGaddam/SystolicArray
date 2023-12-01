module SAA_Opt_test;
reg clk,init,rst;
wire complete;
reg[7:0] base_address_A,base_address_B,base_address_C;
integer i;
SAA_Opt DUT(init,rst,complete,clk,base_address_A,base_address_B,base_address_C);
initial begin
    clk=0;
    init=0;
    rst=1;
    DUT.MF.IOF.CN.state=3'b000;
    DUT.SAC.SAC.C1.state=3'b000;
    DUT.FM.SM.CN.state=2'b00;
    base_address_A={8{1'b0}};
    base_address_B=8'b00011001;
    base_address_C=8'b00110010;
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/index.txt",DUT.MF.IOF.CB.AG.LM.mem);
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/mem.txt",DUT.MEM.mem);
    //$readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/index.txt",DUT.MFS.MFB.IOF.CB.LM.mem);
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/Write_matrix.txt",DUT.FM.SM.CB.LM.mem);
#10 init=1;rst=0;
    #10 init=0;
    #990 init=1;
    for(i=50;i<75;i=i+1)begin
      $display("%d=%d ",i,DUT.MEM.mem[i]);
    end
    #10 $finish;
end
always #5 clk=~clk;
initial begin
    $dumpfile("SAA_Opt_test.vcd");
    $dumpvars(0,SAA_Opt_test);
end
endmodule