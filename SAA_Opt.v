module Delay(in,out,clr,clk);
parameter N = 3;
input clr,clk;
input[N-1:0] in;
output reg[N-1:0] out;
always @(posedge clk) begin
    if(clr) out<={N{1'b0}};
    else out<=in;
end
endmodule
module counter(out,clk,clr);
input clk,clr;
output reg[3:0] out;
always @(posedge clk) begin
    if(clr)out<=4'b0000;
    else out<=out+1;
end
endmodule
module location_memory(in,out,clk);
input[5:0] in;
input clk;
output reg[7:0] out;
reg[7:0] mem[0:63];
always @(posedge clk) begin
    if(in==8'hFF)out<={8{1'b1}};
    else begin
      out<=mem[in];
    end
end
endmodule
module location_memory_counter(out,clr,clk,com);
input clk,clr;
output reg com;
output[5:0] out;
reg[5:0] counter;
assign out=counter;
always @(posedge clk) begin
    if(clr)begin counter<=6'b000000;com<=1'b0; end
    else if(counter==6'b101100)begin counter<=6'b000000;com<=1'b1; end
    else begin counter<=counter+1;com<=1'b0; end
end
endmodule
module location_memory_counter_write(out,clr,clk,com);
input clk,clr;
output reg com;
output[5:0] out;
reg[5:0] counter;
assign out=counter;
always @(posedge clk) begin
    if(clr)begin counter<=6'b000000;com<=1'b0; end
    else if(counter==6'b011000)begin counter<=6'b000000;com<=1'b1; end
    else begin counter<=counter+1;com<=1'b0; end
end
endmodule
module location_to_index(base_address_A,base_address_B,location_memory_out,memory_in_A,memory_in_B);
parameter  N=32;
parameter M=256;
parameter width = 8;
parameter row = 5;
input[width-1:0] base_address_A,base_address_B;
input[width-1:0] location_memory_out;
output reg[width-1:0] memory_in_A,memory_in_B;
always @(*) begin
    if(location_memory_out==8'b11111111)begin memory_in_A<=8'b11111111;memory_in_B<=8'b11111111; end
    else begin
      memory_in_A<=base_address_A+{4'b0000,location_memory_out[7:4]}*row+{4'b0000,location_memory_out[3:0]};
      memory_in_B<=base_address_B+{4'b0000,location_memory_out[3:0]}*row+{4'b0000,location_memory_out[7:4]};
    end
end
endmodule
module location_to_index_write(base_address,location_memory_out,memory_in);
parameter  N=32;
parameter M=256;
parameter width = 8;
parameter row = 5;
input[width-1:0] base_address;
input[width-1:0] location_memory_out;
output reg[width-1:0] memory_in;
always @(*) begin
    if(location_memory_out==8'b11111111)memory_in<=8'b11111111;
    else begin
      memory_in<=base_address+{4'b0000,location_memory_out[7:4]}*row+{4'b0000,location_memory_out[3:0]};
    end
end
endmodule
module memory(in_A,in_B,address,out_A,out_B,data_in,rd_en,wr_en,clk);
parameter width =8;
parameter N = 32;
input clk,rd_en,wr_en;
input[width-1:0] in_A,in_B,address;
input[N-1:0] data_in;
output reg[N-1:0] out_A,out_B;
reg[N-1:0] mem[0:256];
always @(posedge clk) begin
    if(rd_en)begin
    if(in_A==8'b11111111)out_A<=8'b00000000;
    if(in_B==8'b11111111)out_B<=8'b00000000;
    else begin out_A<=mem[in_A];out_B<=mem[in_B]; end
    end
     if(wr_en)mem[address]<=data_in;
    end
//always @(posedge clk) begin
//    if(wr_en)mem[address]<=data_in;
//end
endmodule
module de_mux(sel,in,out0,out1,out2,out3,out4);
parameter N=32;
input[2:0] sel;
input[N-1:0] in;
output reg[N-1:0] out0,out1,out2,out3,out4;
always @(*) begin
    case(sel)
    3'b000:out0<=in;
    3'b001:out1<=in;
    3'b010:out2<=in;
    3'b011:out3<=in;
    3'b100:out4<=in;
    default:begin out0<={8{1'b0}};out1<={8{1'b0}};out2<={8{1'b0}};out3<={8{1'b0}};out4<={8{1'b0}}; end
    endcase
end
endmodule
module de_mux_counter(out,clr,clk);
input clk,clr;
output[2:0] out;
reg[2:0] counter;
assign out=counter;
always @(posedge clk) begin
    if(clr)counter<=6'b000;
    else if(counter==6'b100)counter<=6'b000;
    else counter<=counter+1;
end
endmodule
module mux(sel,out,in0,in1,in2,in3,in4);
parameter N =32;
input[2:0] sel;
output reg[N-1:0] out;
input[N-1:0] in0,in1,in2,in3,in4;
always @(*) begin
    case(sel)
    3'b000:out<=in0;
    3'b001:out<=in1;
    3'b010:out<=in2;
    3'b011:out<=in3;
    3'b100:out<=in4;
    default:begin out<={8{1'b0}};end
    endcase
end
endmodule
module mux_counter(out,clr,clk);
input clk,clr;
output[2:0] out;
reg[2:0] counter;
assign out=counter;
always @(posedge clk) begin
    if(clr)counter<=6'b000;
    else if(counter==6'b100)counter<=6'b000;
    else counter<=counter+1;
end
endmodule
module signal_to_FIFO(demux_clr,demux_sel,write_en);
input demux_clr;
input[2:0] demux_sel;
output reg[4:0] write_en;
always @(*) begin
    case(demux_sel)
    3'b000:write_en<=demux_clr?5'b00000:5'b00001;
    3'b001:write_en<=demux_clr?5'b00000:5'b00010;
    3'b010:write_en<=demux_clr?5'b00000:5'b00100;
    3'b011:write_en<=demux_clr?5'b00000:5'b01000;
    3'b100:write_en<=demux_clr?5'b00000:5'b10000;
    default:write_en<=5'b00000;
    endcase
end
endmodule
module FIFO(clk,rst,buf_in,buf_out,wr_en,rd_en,buf_empty,buf_full);
parameter N=32;
input rst,clk,wr_en,rd_en;
input[N-1:0] buf_in;
output reg[N-1:0] buf_out;
output reg buf_empty,buf_full;
reg[6:0] fifo_counter;
reg[5:0] rd_ptr,wr_ptr;
reg[N-1:0] buf_mem[63:0];
always @(fifo_counter) begin
    buf_empty<=(fifo_counter==0);
    buf_full<=(fifo_counter==64);
end
always @(posedge clk or posedge rst)begin
    if(rst)fifo_counter<=0;
    else if((!buf_full && wr_en) && (!buf_empty && rd_en))fifo_counter<=fifo_counter;
    else if(!buf_full && wr_en) fifo_counter<=fifo_counter+1;
    else if(!buf_empty && rd_en)fifo_counter<=fifo_counter-1;
    else fifo_counter<=fifo_counter;
end
always @(posedge clk or posedge rst)begin
    if(rst)buf_out<=0;
    else begin
        if(rd_en && !buf_empty)
        buf_out<=buf_mem[rd_ptr];
        else
        buf_out<=buf_out;
    end
end
always @(posedge clk)begin
    if(wr_en && !buf_full)buf_mem[wr_ptr]<=buf_in;
    else buf_mem[wr_ptr]<=buf_mem[wr_ptr];
end
always @(posedge clk or posedge rst)begin
    if(rst)begin
        wr_ptr<=0;
        rd_ptr<=0;
    end
    else begin
        if(!buf_full && wr_en)wr_ptr<=wr_ptr+1;
        else wr_ptr<=wr_ptr;
        if(!buf_empty && rd_en)rd_ptr<=rd_ptr+1;
        else rd_ptr<=rd_ptr;
end
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
module Controller(init,complete,C,read,write,clr,clr_C,rd_en,wr_en,clk);
input init,clk;
input[3:0] C;
output reg[24:0] read,write,clr;
output reg clr_C,rd_en,wr_en,complete;
reg[2:0] state;
parameter Sinit=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100,S5=3'b101;
always @(posedge clk) begin
    case (state)
        Sinit:state<=init?S1:Sinit;
        S1:state<=(C==4'b1010)?S2:S1;
        S2:state<=(C==4'b1101)?S3:S2;
        S3:state<=S4;
        S4:state<=(C==4'b0011)?S5:S4;
        S5:state<=Sinit;
    endcase
end
always @(state) begin
    case(state)
    Sinit:begin read<=25'b0;write<=25'b0;clr={25{1'b1}};clr_C<=1'b1;rd_en<=1'b0;wr_en<=1'b0;complete<=1'b0; end
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
module address_gen(clk,LM_clr,complete,base_address_in_A,base_address_in_B,base_address_A,base_address_B);
parameter M = 8;
parameter N = 32;
input clk,LM_clr;
output complete;
input[M-1:0] base_address_in_A,base_address_in_B;
wire[5:0] LM_counter_out;
wire[M-1:0] LM_data,mem_address_A,mem_address_B;
wire com;
output[M-1:0] base_address_A,base_address_B;
assign complete=com;
assign base_address_A=mem_address_A;
assign base_address_B=mem_address_B;
location_memory_counter LMC(LM_counter_out,LM_clr,clk,com);
location_memory LM(LM_counter_out,LM_data,clk);
location_to_index LtoI(base_address_in_A,base_address_in_B,LM_data,mem_address_A,mem_address_B);
endmodule
module Memory_to_FIFO(clk,de_mux_clr,dmux_sel_out,data_A,data_B,out0_A,out1_A,out2_A,out3_A,out4_A,out0_B,out1_B,out2_B,out3_B,out4_B);
parameter N = 32;
input clk,de_mux_clr;
input[N-1:0] data_A,data_B;
output[2:0] dmux_sel_out;
output[N-1:0] out0_A,out1_A,out2_A,out3_A,out4_A,out0_B,out1_B,out2_B,out3_B,out4_B;
wire[2:0] dmux_sel;
wire de_mux_clr;
assign dmux_sel_out=dmux_sel;
de_mux_counter DMC(dmux_sel,de_mux_clr,clk);
de_mux DM_A(dmux_sel,data_A,out0_A,out1_A,out2_A,out3_A,out4_A);
de_mux DM_B(dmux_sel,data_B,out0_B,out1_B,out2_B,out3_B,out4_B);
endmodule
module computational_block_read(LM_clr,de_mux_clr,com,dmux_sel_out,base_address_A,base_address_B,Address_A,Address_B,data_A,data_B,clk,
out0_A,out1_A,out2_A,out3_A,out4_A,out0_B,out1_B,out2_B,out3_B,out4_B);
parameter M = 8;
parameter N = 32;
input LM_clr,de_mux_clr,clk;
output com;
input[M-1:0] base_address_A,base_address_B;
input[N-1:0] data_A,data_B;
output[M-1:0] Address_A,Address_B;
output[2:0] dmux_sel_out;
output[N-1:0] out0_A,out1_A,out2_A,out3_A,out4_A,out0_B,out1_B,out2_B,out3_B,out4_B;
wire complete;
assign com=complete;
address_gen AG(clk,LM_clr,complete,base_address_A,base_address_B,Address_A,Address_B);
Memory_to_FIFO MTF(clk,de_mux_clr,dmux_sel_out,data_A,data_B,out0_A,out1_A,out2_A,out3_A,out4_A,out0_B,out1_B,out2_B,out3_B,out4_B);
endmodule
module FIFO_5(clk,rst,in0,in1,in2,in3,in4,out0,out1,out2,out3,out4,wr_en,rd_en,buf_empty,buf_full);
parameter N = 32;
input clk,rst;
input[4:0] wr_en,rd_en;
output[4:0] buf_empty,buf_full;
input[N-1:0] in0,in1,in2,in3,in4;
output[N-1:0] out0,out1,out2,out3,out4;
FIFO F0(clk,rst,in0,out0,wr_en[0],rd_en[0],buf_empty[0],buf_full[0]);
FIFO F1(clk,rst,in1,out1,wr_en[1],rd_en[1],buf_empty[1],buf_full[1]);
FIFO F2(clk,rst,in2,out2,wr_en[2],rd_en[2],buf_empty[2],buf_full[2]);
FIFO F3(clk,rst,in3,out3,wr_en[3],rd_en[3],buf_empty[3],buf_full[3]);
FIFO F4(clk,rst,in4,out4,wr_en[4],rd_en[4],buf_empty[4],buf_full[4]);
endmodule
module controller_read(init,com,mem_rd_en,base_address_in_A,base_address_in_B,LM_clr,de_mux_clr,base_address_A,base_address_B,clk);
input init,com,clk;
input[7:0] base_address_in_A,base_address_in_B;
output reg LM_clr,de_mux_clr,mem_rd_en;
output reg[7:0] base_address_A,base_address_B;
reg[2:0] state;
parameter  S0=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100;
always @(posedge clk) begin
    case(state)
    S0:state<=init?S1:S0;
    S1:state<=S2;
    S2:state<=S3;
    S3:state<=com?S4:S3;
    S4:state<=S0;
    endcase
end
always @(state) begin
    case(state)
    S0:begin LM_clr<=1'b1;de_mux_clr<=1'b1;mem_rd_en<=1'b0;base_address_A<=base_address_in_A;base_address_B<=base_address_in_B; end
    S1:begin LM_clr<=1'b0;de_mux_clr<=1'b1;mem_rd_en<=1'b1; end
    S2:begin LM_clr<=1'b0;de_mux_clr<=1'b1; end
    S3:begin LM_clr<=1'b0;de_mux_clr<=1'b0; end
    S4:begin LM_clr<=1'b0;de_mux_clr<=1'b0; end
    endcase
end
endmodule
module input_of_FIFO(init,com,mem_rd_en,de_mux_clr_out,dmux_sel_out,base_address_A,base_address_B,Address_A,Address_B,data_A,data_B,clk,
out0_A,out1_A,out2_A,out3_A,out4_A,out0_B,out1_B,out2_B,out3_B,out4_B);
input init,clk;
output com;
input[7:0] base_address_A,base_address_B;
output[7:0] Address_A,Address_B;
output[31:0] out0_A,out1_A,out2_A,out3_A,out4_A,out0_B,out1_B,out2_B,out3_B,out4_B;
output[31:0] data_A,data_B;
output de_mux_clr_out,mem_rd_en;
output[2:0] dmux_sel_out;
wire LM_clr,de_mux_clr;
wire[7:0] base_address_ctrl_A,base_address_ctrl_B;
wire complete;
assign com=complete;
assign de_mux_clr_out=de_mux_clr;
computational_block_read CB(LM_clr,de_mux_clr,complete,dmux_sel_out,base_address_ctrl_A,base_address_ctrl_B,Address_A,Address_B,data_A,data_B,clk,
out0_A,out1_A,out2_A,out3_A,out4_A,out0_B,out1_B,out2_B,out3_B,out4_B);
controller_read CN(init,complete,mem_rd_en,base_address_A,base_address_B,LM_clr,de_mux_clr,base_address_ctrl_A,base_address_ctrl_B,clk);
endmodule
module MEM_FIFO(init,com,mem_rd_en,clk,rst,rd_en,base_address_A,base_address_B,Address_A,Address_B,data_A,data_B,
A0,A1,A2,A3,A4,B0,B1,B2,B3,B4);
input init,clk,rst;
output com,mem_rd_en;
output[31:0] A0,A1,A2,A3,A4,B0,B1,B2,B3,B4;
input[7:0] base_address_A,base_address_B;
output[7:0] Address_A,Address_B;
input[31:0] data_A,data_B;
input[4:0] rd_en;
wire[31:0] out0_A,out1_A,out2_A,out3_A,out4_A,out0_B,out1_B,out2_B,out3_B,out4_B;
wire[4:0] wr_en,buf_empty_A,buf_full_A,buf_empty_B,buf_full_B;
wire[2:0] dmux_sel_out;
wire en;
assign en=&buf_full_A;
input_of_FIFO IOF(init & ~en,com,mem_rd_en,de_mux_clr_out,dmux_sel_out,base_address_A,base_address_B,Address_A,Address_B,data_A,data_B,clk,
out0_A,out1_A,out2_A,out3_A,out4_A,out0_B,out1_B,out2_B,out3_B,out4_B);
// FIFO F0(clk,rst,in0,out0,wr_en[0],rd_en[0],buf_empty[0],buf_full[0]);
// FIFO F1(clk,rst,in1,out1,wr_en[1],rd_en[1],buf_empty[1],buf_full[1]);
// FIFO F2(clk,rst,in2,out2,wr_en[2],rd_en[2],buf_empty[2],buf_full[2]);
// FIFO F3(clk,rst,in3,out3,wr_en[3],rd_en[3],buf_empty[3],buf_full[3]);
// FIFO F4(clk,rst,in4,out4,wr_en[4],rd_en[4],buf_empty[4],buf_full[4]);
FIFO_5 A_5(clk,rst,out0_A,out1_A,out2_A,out3_A,out4_A,A0,A1,A2,A3,A4,wr_en,rd_en,buf_empty_A,buf_full_A);
FIFO_5 B_5(clk,rst,out0_B,out1_B,out2_B,out3_B,out4_B,B0,B1,B2,B3,B4,wr_en,rd_en,buf_empty_B,buf_full_B);
signal_to_FIFO STF(de_mux_clr_out,dmux_sel_out,wr_en);
endmodule
module computational_block_write(LM_clr,mux_clr,com,wr_en,mux_sel_out,base_address,Address_C,data_C,clk,
in0,in1,in2,in3,in4);
input LM_clr,mux_clr,clk,wr_en;
output com;
output[2:0] mux_sel_out;
input[7:0] base_address;
input[31:0] in0,in1,in2,in3,in4;
output[7:0] Address_C;
output[31:0] data_C;
wire[5:0] LM_counter_out;
wire[7:0] LM_data;
wire[7:0] mem_address;
wire[31:0] mem_data;
wire[2:0] mux_sel,d_mux_sel;
assign mux_sel_out=mux_sel;
assign Address_C=mem_address;
assign data_C=mem_data;
location_memory_counter_write LMC(LM_counter_out,LM_clr,clk,com);
location_memory LM(LM_counter_out,LM_data,clk);
location_to_index_write LtoI(base_address,LM_data,mem_address);
//memory_write MEM(mem_address,mem_data,wr_en,clk);
mux_counter DMC(mux_sel,mux_clr,clk);
Delay D(mux_sel,d_mux_sel,mux_clr,clk);
mux DM(d_mux_sel,mem_data,in0,in1,in2,in3,in4);
endmodule
module controller_write(init,com,wr_en,base_address_in,LM_clr,mux_clr,base_address,clk);
input init,com,clk;
input[7:0] base_address_in;
output reg LM_clr,mux_clr,wr_en;
output reg[7:0] base_address;
reg[1:0] state;
parameter  S0=2'b00,S1=2'b01,S2=2'b10,S3=2'b11;
always @(posedge clk) begin
    case(state)
    S0:state<=init?S1:S0;
    S1:state<=S2;
    S2:state<=com?S0:S2;
    //S3:state<=com?S0:S3;
    endcase
end
always @(state) begin
    case(state)
    S0:begin LM_clr<=1'b1;mux_clr<=1'b1;wr_en<=1'b0;base_address<=base_address_in; end
    S1:begin LM_clr<=1'b1;mux_clr<=1'b1;wr_en<=1'b0; end
    S2:begin LM_clr<=1'b0;mux_clr<=1'b0;wr_en<=1'b1; end
  //  S3:begin LM_clr<=1'b0;mux_clr<=1'b0; end
    endcase
end
endmodule
module SA_MEM(init,com,mem_wr_en,mux_clr_out,mux_sel_out,base_address,Address_C,data_C,clk,
in0,in1,in2,in3,in4);
input init,clk;
output com;
output mux_clr_out,mem_wr_en;
output[2:0] mux_sel_out;
input[7:0] base_address;
input[31:0] in0,in1,in2,in3,in4;
output[7:0] Address_C;
output[31:0] data_C;
wire LM_clr,mux_clr;
wire[7:0] base_address_ctrl;
wire[2:0] mux_sel;
wire complete,wr_en;
assign com=complete;
assign mux_clr_out=mux_clr;
assign mux_sel_out=mux_sel;
assign mem_wr_en=wr_en;
computational_block_write CB(LM_clr,mux_clr,complete,wr_en,mux_sel,base_address_ctrl,Address_C,data_C,clk,in0,in1,in2,in3,in4);
controller_write CN(init,complete,wr_en,base_address,LM_clr,mux_clr,base_address_ctrl,clk);
endmodule
module FIFO_MEM(init,com,mem_wr_en,clk,rst,wr_en,base_address,Address_C,data_C,
in0,in1,in2,in3,in4);
input init,clk,rst;
output com,mem_wr_en;
input[31:0] in0,in1,in2,in3,in4;
input[7:0] base_address;
input[4:0] wr_en;
output[7:0] Address_C;
output[31:0] data_C;
wire[31:0] out0,out1,out2,out3,out4;
wire[4:0] rd_en,buf_empty,buf_full;
wire[2:0] mux_sel_out;
wire mux_clr_out;
wire en;
assign en=&buf_empty;
//input_of_FIFO IOF(init & ~en,com,de_mux_clr_out,dmux_sel_out,base_address,clk,in0,in1,in2,in3,in4);
SA_MEM SM(init & ~en,com,mem_wr_en,mux_clr_out,mux_sel_out,base_address,Address_C,data_C,clk,out0,out1,out2,out3,out4);
// FIFO F0(clk,rst,in0,out0,wr_en[0],rd_en[0],buf_empty[0],buf_full[0]);
// FIFO F1(clk,rst,in1,out1,wr_en[1],rd_en[1],buf_empty[1],buf_full[1]);
// FIFO F2(clk,rst,in2,out2,wr_en[2],rd_en[2],buf_empty[2],buf_full[2]);
// FIFO F3(clk,rst,in3,out3,wr_en[3],rd_en[3],buf_empty[3],buf_full[3]);
// FIFO F4(clk,rst,in4,out4,wr_en[4],rd_en[4],buf_empty[4],buf_full[4]);
FIFO_5 A_5(clk,rst,in0,in1,in2,in3,in4,out0,out1,out2,out3,out4,wr_en,rd_en,buf_empty,buf_full);
signal_to_FIFO STF(mux_clr_out,mux_sel_out,rd_en);
endmodule
module counter_A(clk,rst,inc,dec,com);
input clk,rst,inc,dec;
output com;
reg[5:0] count;
always @(posedge clk) begin
    if(rst)count<=5'b00000;
    else if(inc)count<=count+1;
    else if(dec)count<=count-1;
    else count<=count;
end
assign com=rst?1'b0:(|count);
endmodule
module SAA_Opt(init,rst,complete,clk,base_address_A,base_address_B,base_address_C);
parameter N = 32;
input clk,init,rst;
output complete;
wire wr_en,rd_en;
wire com,com_SA,init_SA,mem_rd_en,mem_wr_en,fifo_init;
input[7:0] base_address_A,base_address_B,base_address_C;
wire[7:0] Address_A,Address_B,Address_C;
wire[31:0] data_A,data_B,data_C;
wire[31:0] A0,A1,A2,A3,A4,B0,B1,B2,B3,B4;
wire[31:0] A0_out,A1_out,A2_out,A3_out,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out;
MEM_FIFO MF(init,com,mem_rd_en,clk,rst,{5{rd_en}},base_address_A,base_address_B,Address_A,Address_B,data_A,data_B,
A0,A1,A2,A3,A4,B0,B1,B2,B3,B4);
counter_A CoA(clk,rst,com,com_SA,init_SA);
Systolic_Array_with_Controller SAC(init_SA,com_SA,clk,rd_en,wr_en,A0,A1,A2,A3,A4,B0,B1,B2,B3,B4,A0_out,A1_out,A2_out,A3_out,A4_out,B0_out,B1_out,B2_out,B3_out,B4_out);
memory MEM(Address_A,Address_B,Address_C,data_A,data_B,data_C,mem_rd_en,mem_wr_en,clk);
//FIFO_MEM FM(com_SA,complete,clk,rst,wr_en,base_address_C,B0_out,B1_out,B2_out,B3_out,B4_out);
counter_A CoW(clk,rst,com_SA,complete,fifo_init);
FIFO_MEM FM(fifo_init,complete,mem_wr_en,clk,rst,{5{wr_en}},base_address_C,Address_C,data_C,
B0_out,B1_out,B2_out,B3_out,B4_out);
endmodule