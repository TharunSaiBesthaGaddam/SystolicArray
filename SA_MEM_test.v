module SA_MEM_test;
reg init,clk;
wire com;
reg[7:0] base_address;
reg[31:0] in0,in1,in2,in3,in4;
integer i;
SA_MEM DUT(init,com,base_address,clk,in0,in1,in2,in3,in4);
initial begin
    clk=0;
    DUT.CN.state=1'b0;
    init=0;
    base_address={8{1'b0}};
    $readmemb("/home/tharunsai/Documents/Project/code/Systolic-Array-main/Write_matrix.txt",DUT.CB.LM.mem);
    #10 init=1;
    #10 in0=$urandom%100;
        in1=$urandom%100;
        in2=$urandom%100;
        in3=$urandom%100;
        in4=$urandom%100;
    #450 in0=0; 
    for(i=0;i<25;i=i+1)begin
      $display("%d ",DUT.CB.MEM.mem[i]);
    end
    #500 $finish;
end
always #5 clk=~clk;
initial begin
    $dumpfile("SA_MEM_test.vcd");
    $dumpvars(0,SA_MEM_test);
end
endmodule