module Systolic_Array_Controller_test;
reg init,clk;
wire[24:0] read,write,clr;
Systolic_Array_Controller DUT(init,read,write,clr,clk);
initial begin
    clk=0;
    init=0;
    DUT.C1.state=2'b00;
    #10 init=1;
    #10 init=0;
    #300 $finish;
end
always #5 clk=~clk;
initial begin
    $dumpfile("Systolic_Array_Controller_test.vcd");
    $dumpvars(0,Systolic_Array_Controller_test);
end
endmodule