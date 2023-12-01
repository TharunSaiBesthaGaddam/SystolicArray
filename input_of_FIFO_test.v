module input_of_FIFO_test;
reg init,clk;
wire com;
reg[7:0] base_address;
wire[31:0] out0,out1,out2,out3,out4;
input_of_FIFO DUT(init,com,base_address,clk,out0,out1,out2,out3,out4);
initial begin
    clk=0;
    DUT.CN.state=1'b0;
    init=0;
    base_address={8{1'b0}};
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/matrix.txt",DUT.CB.MEM.mem);
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/index.txt",DUT.CB.LM.mem);
    #10 init=1;
    #500 $finish;
end
always #5 clk=~clk;
initial begin
    $dumpfile("input_of_FIFO_test.vcd");
    $dumpvars(0,input_of_FIFO_test);
end
endmodule