module Processing_Element_test;
parameter N=32;
reg read,write,clr,clk;
reg[N-1:0] A,B;
wire[N-1:0] Aout,Bout;
Processing_Element DUT(A,B,Aout,Bout,clk,clr,read,write);
initial begin
    clk=0;
    clr=1;
    read=0;
    write=0;
    A=5;B=2;
    #10 clr=0;
    #10 read=1;A=20;write=1;
    #10 read=0;write=0;
    #10 clr=1;
    #200 $finish;
end
always #5 clk=~clk;
initial begin
    $dumpfile("Processing_Element_test.vcd");
    $dumpvars(0,Processing_Element_test);
end
endmodule