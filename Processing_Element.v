module Processing_Element(A,B,Aout,Bout,clk,clr,read,write);
parameter N=32;
input[N-1:0] A,B;
output reg[N-1:0] Aout,Bout;
reg[N-1:0] Acc;
input clk,clr,read,write;
always @(posedge clk)begin
    if(clr & ~read & ~write)begin
        Acc<=0;
        Aout<=0;
        Bout<=0;
    end
    else if(~clr & read & ~write)begin
        Acc<=B;
    end
    else if(~clr & write & ~read)begin
        Bout<=Acc;
    end
    else if(~clr & write & read)begin
        Acc<=B;
        Bout<=Acc;
    end
    else begin
        Acc<=Acc+A*B;
        Aout<=A;
        Bout<=B;
    end
end
endmodule