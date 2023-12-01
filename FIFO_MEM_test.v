module FIFO_MEM_test;
reg init,clk,rst;
wire com;
reg[31:0] in0,in1,in2,in3,in4;
reg[7:0] base_address;
reg[4:0] wr_en;
integer i;
FIFO_MEM DUT(init,com,clk,rst,wr_en,base_address,in0,in1,in2,in3,in4);
initial begin
    clk=0;
    rst=1;
    init=0;
    wr_en=5'b00000;
    DUT.SM.CN.state=1'b0;
    base_address={8{1'b0}};
    in0=$urandom%100;
    in1=$urandom%100;
    in2=$urandom%100;
    in3=$urandom%100;
    in4=$urandom%100;
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/Write_matrix.txt",DUT.SM.CB.LM.mem);
    #10 wr_en=5'b11111;
    #10 rst=0;
    //#10 wr_en=5'b11111;
    #10 init=1;
    #10 init=0;
    #450 in0=0; 
    for(i=0;i<25;i=i+1)begin
      $display("%d ",DUT.SM.CB.MEM.mem[i]);
    end
    #500 $finish;
end
always #5 clk=~clk;
initial begin
    $dumpfile("FIFO_MEM_test.vcd");
    $dumpvars(0,FIFO_MEM_test);
end
endmodule