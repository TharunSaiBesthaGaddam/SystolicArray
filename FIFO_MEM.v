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
module location_to_index(base_address,location_memory_out,memory_in);
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
      memory_in<={4'b0000,location_memory_out[7:4]}*row+{4'b0000,location_memory_out[3:0]};
    end
end
endmodule
module memory(index,data_in,clk);
parameter width =8;
parameter N = 32;
input clk;
input[width-1:0] index;
input[N-1:0] data_in;
reg[N-1:0] mem[0:256];
always @(posedge clk) begin
    if(index==8'b11111111)mem[index]<=8'b00000000;
    else mem[index]<=data_in;
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
module computational_block_write(LM_clr,mux_clr,com,mux_sel_out,base_address,clk,in0,in1,in2,in3,in4);
input LM_clr,mux_clr,clk;
output com;
output[2:0] mux_sel_out;
input[7:0] base_address;
input[31:0] in0,in1,in2,in3,in4;
wire[5:0] LM_counter_out;
wire[7:0] LM_data;
wire[7:0] mem_address;
wire[31:0] mem_data;
wire[2:0] mux_sel,d_mux_sel;
assign mux_sel_out=mux_sel;
location_memory_counter LMC(LM_counter_out,LM_clr,clk,com);
location_memory LM(LM_counter_out,LM_data,clk);
location_to_index LtoI(base_address,LM_data,mem_address);
memory MEM(mem_address,mem_data,clk);
mux_counter DMC(mux_sel,mux_clr,clk);
Delay D(mux_sel,d_mux_sel,mux_clr,clk);
mux DM(d_mux_sel,mem_data,in0,in1,in2,in3,in4);
endmodule
module controller_write(init,com,base_address_in,LM_clr,mux_clr,base_address,clk);
input init,com,clk;
input[7:0] base_address_in;
output reg LM_clr,mux_clr;
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
    S0:begin LM_clr<=1'b1;mux_clr<=1'b1;base_address<=base_address_in; end
    S1:begin LM_clr<=1'b1;mux_clr<=1'b1; end
    S2:begin LM_clr<=1'b0;mux_clr<=1'b0; end
  //  S3:begin LM_clr<=1'b0;mux_clr<=1'b0; end
    endcase
end
endmodule
module SA_MEM(init,com,mux_clr_out,mux_sel_out,base_address,clk,in0,in1,in2,in3,in4);
input init,clk;
output com;
output mux_clr_out;
output[2:0] mux_sel_out;
input[7:0] base_address;
input[31:0] in0,in1,in2,in3,in4;
wire LM_clr,mux_clr;
wire[7:0] base_address_ctrl;
wire[2:0] mux_sel;
wire complete;
assign com=complete;
assign mux_clr_out=mux_clr;
assign mux_sel_out=mux_sel;
computational_block_write CB(LM_clr,mux_clr,complete,mux_sel,base_address_ctrl,clk,in0,in1,in2,in3,in4);
controller_write CN(init,complete,base_address,LM_clr,mux_clr,base_address_ctrl,clk);
endmodule
module signal_to_FIFO(mux_clr,mux_sel,read_en);
input mux_clr;
input[2:0] mux_sel;
output reg[4:0] read_en;
always @(*) begin
    case(mux_sel)
    3'b000:read_en<=mux_clr?5'b00000:5'b00001;
    3'b001:read_en<=mux_clr?5'b00000:5'b00010;
    3'b010:read_en<=mux_clr?5'b00000:5'b00100;
    3'b011:read_en<=mux_clr?5'b00000:5'b01000;
    3'b100:read_en<=mux_clr?5'b00000:5'b10000;
    default:read_en<=5'b00000;
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
// module Delay(in,out,clr,clk);
// parameter N = 3;
// input clr,clk;
// input[N-1:0] in;
// output reg[N-1:0] out;
// always @(posedge clk) begin
//     if(clr) out<={N{1'b0}};
//     else out<=in;
// end
// endmodule
module FIFO_MEM(init,com,clk,rst,wr_en,base_address,in0,in1,in2,in3,in4);
input init,clk,rst;
output com;
input[31:0] in0,in1,in2,in3,in4;
input[7:0] base_address;
input[4:0] wr_en;
wire[31:0] out0,out1,out2,out3,out4;
wire[4:0] rd_en,buf_empty,buf_full;
wire[2:0] mux_sel_out;
wire mux_clr_out;
wire en;
assign en=&buf_empty;
//input_of_FIFO IOF(init & ~en,com,de_mux_clr_out,dmux_sel_out,base_address,clk,in0,in1,in2,in3,in4);
SA_MEM SM(init & ~en,com,mux_clr_out,mux_sel_out,base_address,clk,out0,out1,out2,out3,out4);
FIFO F0(clk,rst,in0,out0,wr_en[0],rd_en[0],buf_empty[0],buf_full[0]);
FIFO F1(clk,rst,in1,out1,wr_en[1],rd_en[1],buf_empty[1],buf_full[1]);
FIFO F2(clk,rst,in2,out2,wr_en[2],rd_en[2],buf_empty[2],buf_full[2]);
FIFO F3(clk,rst,in3,out3,wr_en[3],rd_en[3],buf_empty[3],buf_full[3]);
FIFO F4(clk,rst,in4,out4,wr_en[4],rd_en[4],buf_empty[4],buf_full[4]);
signal_to_FIFO STF(mux_clr_out,mux_sel_out,rd_en);
endmodule