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
module PE_layer(A0,B0,B1,B2,B3,B4,B5,B6,B7,
A0_out,B0_out,B1_out,B2_out,B3_out,B4_out,B5_out,B6_out,B7_out,
clk,clr,read,write);
parameter N=32;
parameter M=8;
input[N-1:0] A0,B0,B1,B2,B3,B4,B5,B6,B7;
output[N-1:0] A0_out,B0_out,B1_out,B2_out,B3_out,B4_out,B5_out,B6_out,B7_out;
input clk;
input[M-1:0] clr,read,write;
wire[N-1:0] A0_temp0,A0_temp1,A0_temp2,A0_temp3,A0_temp4,A0_temp5,A0_temp6;
Processing_Element PE0(A0,B0,A0_temp0,B0_out,clk,clr[0],read[0],write[0]);
Processing_Element PE1(A0_temp0,B1,A0_temp1,B1_out,clk,clr[1],read[1],write[1]);
Processing_Element PE2(A0_temp1,B2,A0_temp2,B2_out,clk,clr[2],read[2],write[2]);
Processing_Element PE3(A0_temp2,B3,A0_temp3,B3_out,clk,clr[3],read[3],write[3]);
Processing_Element PE4(A0_temp3,B4,A0_temp4,B4_out,clk,clr[4],read[4],write[4]);
Processing_Element PE5(A0_temp4,B5,A0_temp5,B5_out,clk,clr[5],read[5],write[5]);
Processing_Element PE6(A0_temp5,B6,A0_temp6,B6_out,clk,clr[6],read[6],write[6]);
Processing_Element PE7(A0_temp6,B7,A0_out,B7_out,clk,clr[7],read[7],write[7]);
endmodule
module Systolic_Array(A0,A1,A2,A3,A4,A5,A6,A7,
B0,B1,B2,B3,B4,B5,B6,B7,
A0_out,A1_out,A2_out,A3_out,A4_out,A5_out,A6_out,A7_out,
B0_out,B1_out,B2_out,B3_out,B4_out,B5_out,B6_out,B7_out,
clk,clr,clr_C,read,write);
parameter N=32;
parameter M=64;
input[N-1:0] A0,A1,A2,A3,A4,A5,A6,A7,B0,B1,B2,B3,B4,B5,B6,B7;
output[N-1:0] A0_out,A1_out,A2_out,A3_out,A4_out,A5_out,A6_out,A7_out,B0_out,B1_out,B2_out,B3_out,B4_out,B5_out,B6_out,B7_out;
input clk,clr_C;
input[M-1:0] clr,read,write;
wire[3:0] cout;
wire[N-1:0] B0_temp0,B1_temp0,B2_temp0,B3_temp0,B4_temp0,B5_temp0,B6_temp0,B7_temp0;
wire[N-1:0] B0_temp1,B1_temp1,B2_temp1,B3_temp1,B4_temp1,B5_temp1,B6_temp1,B7_temp1;
wire[N-1:0] B0_temp2,B1_temp2,B2_temp2,B3_temp2,B4_temp2,B5_temp2,B6_temp2,B7_temp2;
wire[N-1:0] B0_temp3,B1_temp3,B2_temp3,B3_temp3,B4_temp3,B5_temp3,B6_temp3,B7_temp3;
wire[N-1:0] B0_temp4,B1_temp4,B2_temp4,B3_temp4,B4_temp4,B5_temp4,B6_temp4,B7_temp4;
wire[N-1:0] B0_temp5,B1_temp5,B2_temp5,B3_temp5,B4_temp5,B5_temp5,B6_temp5,B7_temp5;
wire[N-1:0] B0_temp6,B1_temp6,B2_temp6,B3_temp6,B4_temp6,B5_temp6,B6_temp6,B7_temp6;
counter C0(cout,clk,clr_C);
PE_layer PE_layer0(A0,B0,B1,B2,B3,B4,B5,B6,B7,A0_out,B0_temp0,B1_temp0,B2_temp0,B3_temp0,B4_temp0,B5_temp0,B6_temp0,B7_temp0,clk,clr[7:0],read[7:0],write[7:0]);
PE_layer PE_layer1(A1,B0_temp0,B1_temp0,B2_temp0,B3_temp0,B4_temp0,B5_temp0,B6_temp0,B7_temp0,A1_out,B0_temp1,B1_temp1,B2_temp1,B3_temp1,B4_temp1,B5_temp1,B6_temp1,B7_temp1,clk,clr[15:8],read[15:8],write[15:8]);
PE_layer PE_layer2(A2,B0_temp1,B1_temp1,B2_temp1,B3_temp1,B4_temp1,B5_temp1,B6_temp1,B7_temp1,A2_out,B0_temp2,B1_temp2,B2_temp2,B3_temp2,B4_temp2,B5_temp2,B6_temp2,B7_temp2,clk,clr[23:16],read[23:16],write[23:16]);
PE_layer PE_layer3(A3,B0_temp2,B1_temp2,B2_temp2,B3_temp2,B4_temp2,B5_temp2,B6_temp2,B7_temp2,A3_out,B0_temp3,B1_temp3,B2_temp3,B3_temp3,B4_temp3,B5_temp3,B6_temp3,B7_temp3,clk,clr[31:24],read[31:24],write[31:24]);
PE_layer PE_layer4(A4,B0_temp3,B1_temp3,B2_temp3,B3_temp3,B4_temp3,B5_temp3,B6_temp3,B7_temp3,A4_out,B0_temp4,B1_temp4,B2_temp4,B3_temp4,B4_temp4,B5_temp4,B6_temp4,B7_temp4,clk,clr[39:32],read[39:32],write[39:32]);
PE_layer PE_layer5(A5,B0_temp4,B1_temp4,B2_temp4,B3_temp4,B4_temp4,B5_temp4,B6_temp4,B7_temp4,A5_out,B0_temp5,B1_temp5,B2_temp5,B3_temp5,B4_temp5,B5_temp5,B6_temp5,B7_temp5,clk,clr[47:40],read[47:40],write[47:40]);
PE_layer PE_layer6(A6,B0_temp5,B1_temp5,B2_temp5,B3_temp5,B4_temp5,B5_temp5,B6_temp5,B7_temp5,A6_out,B0_temp6,B1_temp6,B2_temp6,B3_temp6,B4_temp6,B5_temp6,B6_temp6,B7_temp6,clk,clr[55:48],read[55:48],write[55:48]);
PE_layer PE_layer7(A7,B0_temp6,B1_temp6,B2_temp6,B3_temp6,B4_temp6,B5_temp6,B6_temp6,B7_temp6,A7_out,B0_out,B1_out,B2_out,B3_out,B4_out,B5_out,B6_out,B7_out,clk,clr[63:56],read[63:56],write[63:56]);
endmodule
// module counter(out,clk,clr);
// input clk,clr;
// output reg[3:0] out;
// always @(posedge clk) begin
//     if(clr)out<=4'b0000;
//     else out<=out+1;
// end
// endmodule
module Controller(init,complete,C,read,write,clr,clr_C,rd_en,wr_en,clk);
input init,clk;
input[4:0] C;
output reg[63:0] read,write,clr;
output reg clr_C,rd_en,wr_en,complete;
reg[2:0] state;
parameter Sinit=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100,S5=3'b101;
always @(posedge clk) begin
    case (state)
        Sinit:state<=init?S1:Sinit;
        S1:state<=(C==4'b01000)?S2:S1;
        S2:state<=(C==4'b10110)?S3:S2;
        S3:state<=S4;
        S4:state<=(C==4'b00110)?S5:S4;
        S5:state<=Sinit;
    endcase
end
always @(state) begin
    case(state)
    Sinit:begin read<=64'b0;write<=64'b0;clr={64{1'b1}};clr_C<=1'b1;rd_en<=1'b0;wr_en<=1'b0;complete<=1'b0; end
    S1:begin read<=25'b0;write<=25'b0;clr<=25'b0;clr_C<=1'b0;rd_en<=1'b1; end
    S2:begin read<=25'b0;write<=25'b0;clr<=25'b0;clr_C<=1'b0;rd_en<=1'b0; end
    S3:begin read<={25{1'b1}};write<=25'b0;clr<=25'b0;clr_C<=1'b1;rd_en<=1'b0; end
    S4:begin read<=25'b0;write<={25{1'b1}};clr<=25'b0;clr_C<=1'b0;wr_en<=1'b1; end
    S5:begin read<=25'b0;write<={25{1'b0}};clr<={25{1'b1}};clr_C<=1'b0;wr_en<=1'b1;complete<=1'b1; end
    endcase
end
endmodule
module Systolic_Array_Controller(init,complete,read,write,clr,clr_C,rd_en,wr_en,clk);
input init,clk;
output[24:0] read,write,clr;
output clr_C;
output rd_en,wr_en,complete;
//wire clr_C;
wire[3:0] C;
Controller C1(init,complete,C,read,write,clr,clr_C,rd_en,wr_en,clk);
counter co(C,clk,clr_C);
endmodule
module Systolic_Array_with_Controller(init,complete,clk,rd_en,wr_en,A0,A1,A2,A3,A4,B0,B1,B2,B3,B4,A0_out,A1_out,A2_out,A3_out,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out);
parameter N=32;
parameter M=25;
input[N-1:0] A0,A1,A2,A3,A4,B0,B1,B2,B3,B4;
output[N-1:0] A0_out,A1_out,A2_out,A3_out,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out;
input init,clk;
output rd_en,wr_en,complete;
wire[24:0] read,write,clr;
wire clr_C;
Systolic_Array_Controller SAC(init,complete,read,write,clr,clr_C,rd_en,wr_en,clk);
Systolic_Array SA(A0,A1,A2,A3,A4,B0,B1,B2,B3,B4,A0_out,A1_out,A2_out,A3_out,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out,clk,clr,clr_C,read,write);
endmodule