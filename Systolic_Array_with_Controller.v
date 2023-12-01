module counter(out,clk,clr);
input clk,clr;
output reg[3:0] out;
always @(posedge clk) begin
    if(clr)out<=4'b0000;
    else out<=out+1;
end
endmodule
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
    // else if(~clr & read & ~write)begin
    //     Acc<=B;
    // end
    // else if(~clr & write & ~read)begin
    //     Bout<=Acc;
    // end
    // else if(clr & write & ~read)begin
    //     Bout<=Acc;
    //     Acc<=0;
    // end
    // else if(~clr & write & read)begin
    //     Bout<=Acc;
    //     Acc<=B;
    // end
    else if(~clr & read & ~write)begin
      Bout<=Acc;
    end
    else if(~clr & ~read & write )begin
      Bout<=B;
    end
    else begin
        Acc<=Acc+A*B;
        Aout<=A;
        Bout<=B;
    end
end
endmodule
module PE_layer(A0,B0,B1,B2,B3,B4,A0_out,B0_out,B1_out,B2_out,B3_out,B4_out,clk,clr,read,write);
parameter N=32;
parameter M=5;
input[N-1:0] A0,B0,B1,B2,B3,B4;
output[N-1:0] A0_out,B0_out,B1_out,B2_out,B3_out,B4_out;
input clk;
input[M-1:0] clr,read,write;
wire[N-1:0] A0_temp0,A0_temp1,A0_temp2,A0_temp3;
Processing_Element PE0(A0,B0,A0_temp0,B0_out,clk,clr[0],read[0],write[0]);
Processing_Element PE1(A0_temp0,B1,A0_temp1,B1_out,clk,clr[1],read[1],write[1]);
Processing_Element PE2(A0_temp1,B2,A0_temp2,B2_out,clk,clr[2],read[2],write[2]);
Processing_Element PE3(A0_temp2,B3,A0_temp3,B3_out,clk,clr[3],read[3],write[3]);
Processing_Element PE4(A0_temp3,B4,A0_out,B4_out,clk,clr[4],read[4],write[4]);
endmodule
module Systolic_Array(A0,A1,A2,A3,A4,B0,B1,B2,B3,B4,A0_out,A1_out,A2_out,A3_out,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out,clk,clr,clr_C,read,write);
parameter N=32;
parameter M=25;
input[N-1:0] A0,A1,A2,A3,A4,B0,B1,B2,B3,B4;
output[N-1:0] A0_out,A1_out,A2_out,A3_out,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out;
input clk,clr_C;
input[M-1:0] clr,read,write;
wire[3:0] cout;
wire[N-1:0] B0_temp0,B1_temp0,B2_temp0,B3_temp0,B4_temp0;
wire[N-1:0] B0_temp1,B1_temp1,B2_temp1,B3_temp1,B4_temp1;
wire[N-1:0] B0_temp2,B1_temp2,B2_temp2,B3_temp2,B4_temp2;
wire[N-1:0] B0_temp3,B1_temp3,B2_temp3,B3_temp3,B4_temp3;
counter C0(cout,clk,clr_C);
PE_layer PE_layer0(A0,B0,B1,B2,B3,B4,A0_out,B0_temp0,B1_temp0,B2_temp0,B3_temp0,B4_temp0,clk,clr[4:0],read[4:0],write[4:0]);
PE_layer PE_layer1(A1,B0_temp0,B1_temp0,B2_temp0,B3_temp0,B4_temp0,A1_out,B0_temp1,B1_temp1,B2_temp1,B3_temp1,B4_temp1,clk,clr[9:5],read[9:5],write[9:5]);
PE_layer PE_layer2(A2,B0_temp1,B1_temp1,B2_temp1,B3_temp1,B4_temp1,A2_out,B0_temp2,B1_temp2,B2_temp2,B3_temp2,B4_temp2,clk,clr[14:10],read[14:10],write[14:10]);
PE_layer PE_layer3(A3,B0_temp2,B1_temp2,B2_temp2,B3_temp2,B4_temp2,A3_out,B0_temp3,B1_temp3,B2_temp3,B3_temp3,B4_temp3,clk,clr[19:15],read[19:15],write[19:15]);
PE_layer PE_layer4(A4,B0_temp3,B1_temp3,B2_temp3,B3_temp3,B4_temp3,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out,clk,clr[24:20],read[24:20],write[24:20]);
endmodule
// module counter(out,clk,clr);
// input clk,clr;
// output reg[3:0] out;
// always @(posedge clk) begin
//     if(clr)out<=4'b0000;
//     else out<=out+1;
// end
// endmodule
module Controller(init,C,read,write,clr,clr_C,clk);
input init,clk;
input[3:0] C;
output reg[24:0] read,write,clr;
output reg clr_C;
reg[1:0] state;
parameter Sinit=2'b00,S1=2'b01,S2=2'b10,S3=2'b11;
always @(posedge clk) begin
    case (state)
        Sinit:state<=init?S1:Sinit;
        S1:state<=(C==4'b1101)?S2:S1;
        S2:state<=S3;
        S3:state<=(C==4'b0110)?Sinit:S3;
    endcase
end
always @(state) begin
    case(state)
    Sinit:begin read<=25'b0;write<=25'b0;clr={25{1'b1}};clr_C=1'b1; end
    S1:begin read<=25'b0;write<=25'b0;clr=25'b0;clr_C=1'b0; end
    S2:begin read<={25{1'b1}};write<=25'b0;clr=25'b0;clr_C=1'b1; end
    S3:begin read<=25'b0;write<={25{1'b1}};clr=25'b0;clr_C=1'b0; end
    endcase
end
endmodule
module Systolic_Array_Controller(init,read,write,clr,clr_C,clk);
input init,clk;
output[24:0] read,write,clr;
output clr_C;
//wire clr_C;
wire[3:0] C;
Controller C1(init,C,read,write,clr,clr_C,clk);
counter co(C,clk,clr_C);
endmodule
module Systolic_Array_with_Controller(init,clk,A0,A1,A2,A3,A4,B0,B1,B2,B3,B4,A0_out,A1_out,A2_out,A3_out,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out);
parameter N=32;
parameter M=25;
input[N-1:0] A0,A1,A2,A3,A4,B0,B1,B2,B3,B4;
output[N-1:0] A0_out,A1_out,A2_out,A3_out,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out;
input init,clk;
wire[24:0] read,write,clr;
wire clr_C;
Systolic_Array_Controller SAC(init,read,write,clr,clr_C,clk);
Systolic_Array SA(A0,A1,A2,A3,A4,B0,B1,B2,B3,B4,A0_out,A1_out,A2_out,A3_out,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out,clk,clr,clr_C,read,write);
endmodule