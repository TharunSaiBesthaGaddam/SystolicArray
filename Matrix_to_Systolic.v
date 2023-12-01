module Memory(in,out,zero,clk);
parameter N = 32;
input[4:0] in;
input clk;
output[N-1:0] out;
reg[N-1:0] mem[0:32];
always @(posedge clk) begin
    if(zero)out<=32{1'b0};
    else out<=mem[in];
end
endmodule
// module produce_zeros(init,N,zeros);
// input  init;
// input[4:0] N;
// output reg zeros;
// reg[4:0] temp;
// always @(posedge clk) begin
//     if(init)temp=5{1'b0};
//     else if(temp<N)begin zeros=1'b1;temp=temp+1;end
//     else begin zeros=1'b0;temp=5{1'b1}; end
// end
// endmodule
module indexing(zero,index,cout,clr,clk);
parameter start = 0;
parameter ending =5;
input clk;
output reg zero;
output reg[4:0] index,cout;
reg[4:0] N;
reg[4:0] J,i;
reg flag;
reg[4:0] zeros;
always @(posedge clk) begin
    if(clr)begin
      N=ending;
      J=start;
      flag=1'b0;
      zeros=ending-1;
      i=5{1'b0};
    end
end
always @(posedge clk) begin
    if(!flag)begin
      
    end
end
endmodule

