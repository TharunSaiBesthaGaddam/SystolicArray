module PE_layer_test;
parameter N=32;
parameter M=5;
reg[N-1:0] A0,B0,B1,B2,B3,B4;
wire[N-1:0] A0_out,B0_out,B1_out,B2_out,B3_out,B4_out;
reg clk;
reg[M-1:0] clr,read,write;
PE_layer DUT(A0,B0,B1,B2,B3,B4,A0_out,B0_out,B1_out,B2_out,B3_out,B4_out,clk,clr,read,write);
initial begin
    clk=0;
    clr=5'b11111;
    read=5'b00000;
    write=5'b00000;
    A0=3;B0=1;B1=2;B2=3;B3=4;B4=5;
    #10 clr=5'b00000;
    #200 $finish;
end
always #5 clk=~clk;
initial begin
    $dumpfile("PE_layer_test.vcd");
    $dumpvars(0,PE_layer_test);
end
endmodule