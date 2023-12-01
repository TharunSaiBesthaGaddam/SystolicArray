module PE(A,B,inRes,outA,outB,outRes,clr,st,clk);
parameter N=32;
input[N-1:0] A,B,inRes;
input clr,st,clk;
reg[N-1:0] Acc;
output[N-1:0] outA,outB;
always @(posedge clk) begin
    if(clr & ~st)begin
        Acc<=0;
    end
    else if(st & ~clr)begin
        outRes<=Acc;
    end
    else if(ld & ~clr)begin
        Acc<=inRes;
    end
    else begin
        Acc<=Acc+A*B;
    end
    outA<=A;
    outB<=B;
end
endmodule
module PE_layer(A0,B0,B1,B2,B3,B4,out0,out1,out2,out3,out4,Res0,Res1,Res2,Res3,Res4,layer_out,clr,st,clk):
parmater N=32;
input[N-1:0] A0;
input[N-1:0] B0,B1,B2,B3,B4;
output[N-1:0] out0,out1,out2,out3,out4,Res0,Res1,Res2,Res3,Res4;
wire[N-1:0] temp0,temp1,temp2,temp3;
output[N-1:0] layer_out;
input clk,clr,st;
PE P00(A0,B0,temp0,out0,Res0,clr,st,clk);
PE P01(temp0,B1,temp1,out1,Res1,clr,st,clk);
PE P02(temp1,B2,temp2,out2,Res2,clr,st,clk);
PE P03(temp2,B3,temp3,out3,Res3,clr,st,clk);
PE P04(temp3,B4,layer_out,out4,Res4,clr,st,clk);
endmodule
module systolic_array(A0,A1,A2.A3,A4,B0,B1,B2,B3,B4,RO0,RO1,RO2,RO3,RO4,BO0,BO1,BO2,BO3,BO4,clr,st,clk);
parameter N=32;
input[N-1:0] A0,A1,A2.A3,A4,B0,B1,B2,B3,B4;
output[N-1:0] RO0,RO1,RO2,RO3,RO4,BO0,BO1,BO2,BO3,BO4;
wire[N-1:0] PEL0_0,PEL0_1,PEL0_2,PEL0_3;
PE_layer PEL0(A0,B0,B1,B2,B3,B4,PEL0_0,PEL0_1,PEL0_2,PEL0_3,)
endmodule
