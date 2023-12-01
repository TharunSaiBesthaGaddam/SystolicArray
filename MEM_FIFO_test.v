module MEM_FIFO_test;
reg init,clk,rst;
wire com;
wire[31:0] out0,out1,out2,out3,out4;
reg[7:0] base_address;
reg[4:0] rd_en;
MEM_FIFO DUT(init,com,clk,rst,rd_en,base_address,out0,out1,out2,out3,out4);
initial begin
    clk=0;
    rst=1;
    init=0;
    rd_en=5'b00000;
    DUT.IOF.CN.state=1'b0;
    base_address={8{1'b0}};
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/matrix.txt",DUT.IOF.CB.MEM.mem);
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/index.txt",DUT.IOF.CB.LM.mem);
    #10 init=1;rst=0;
    #455 rd_en=5'b11111;
    #100 $finish;
end
always #5 clk=~clk;
initial begin
    $dumpfile("MEM_FIFO_test.vcd");
    $dumpvars(0,MEM_FIFO_test);
end
endmodule