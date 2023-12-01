module FIFO_test;
parameter N=32;
reg rst,clk,wr_en,rd_en;
reg[N-1:0] buf_in;
wire[N-1:0] buf_out;
wire buf_empty,buf_full;
integer seed;
integer i;
FIFO DUT(clk,rst,buf_in,buf_out,wr_en,rd_en,buf_empty,buf_full);
initial begin
    clk=0;
    rst=1;
    wr_en=0;
    rd_en=0;
    seed=10;
    buf_in=$urandom(seed)%100;
    $write("%d ",buf_in);
    #10 wr_en=1;
    for(i=0;i<44;i=i+1)begin
    #10 buf_in=$urandom(seed)%100;rst=0;$write("%d ",buf_in);
    end
    $write("\n");
    #10 buf_in=0;wr_en=1;rd_en=1;
    #200 for (i=0;i<64;i=i+1)begin
        $write("%d",DUT.buf_mem[i]);
    end
    $write("\n");
    #10 $finish;
end
always #5 clk=~clk;
initial begin
    $dumpfile("FIFO_test.vcd");
    $dumpvars(0,FIFO_test);
end
endmodule