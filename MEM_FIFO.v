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
    if(clr)counter<=6'b000000;
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
module memory(in,out,clk);
parameter width =8;
parameter N = 32;
input clk;
input[width-1:0] in;
output reg[N-1:0] out;
reg[N-1:0] mem[0:256];
always @(posedge clk) begin
    if(in==8'b11111111)out<=8'b00000000;
    else out<=mem[in];
end
endmodule
module de_mux(sel,in,out0,out1,out2,out3,out4);
parameter N =32;
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
module computational_block(LM_clr,de_mux_clr,com,dmux_sel_out,base_address,clk,out0,out1,out2,out3,out4);
input LM_clr,de_mux_clr,clk;
output com;
input[7:0] base_address;
output[31:0] out0,out1,out2,out3,out4;
output[2:0] dmux_sel_out;
wire[5:0] LM_counter_out;
wire[7:0] LM_data;
wire[7:0] mem_address;
wire[31:0] mem_data;
wire[2:0] dmux_sel;
assign dmux_sel_out=dmux_sel;
location_memory_counter LMC(LM_counter_out,LM_clr,clk,com);
location_memory LM(LM_counter_out,LM_data,clk);
location_to_index LtoI(base_address,LM_data,mem_address);
memory MEM(mem_address,mem_data,clk);
de_mux_counter DMC(dmux_sel,de_mux_clr,clk);
de_mux DM(dmux_sel,mem_data,out0,out1,out2,out3,out4);
endmodule
module controller(init,com,base_address_in,LM_clr,de_mux_clr,base_address,clk);
input init,com,clk;
input[7:0] base_address_in;
output reg LM_clr,de_mux_clr;
output reg[7:0] base_address;
reg[1:0] state;
parameter  S0=2'b00,S1=2'b01,S2=2'b10,S3=2'b11;
always @(posedge clk) begin
    case(state)
    S0:state<=init?S1:S0;
    S1:state<=S2;
    S2:state<=S3;
    S3:state<=com?S0:S3;
    endcase
end
always @(state) begin
    case(state)
    S0:begin LM_clr<=1'b1;de_mux_clr<=1'b0;base_address<=base_address_in; end
    S1:begin LM_clr<=1'b0;de_mux_clr<=1'b1; end
    S2:begin LM_clr<=1'b0;de_mux_clr<=1'b1; end
    S3:begin LM_clr<=1'b0;de_mux_clr<=1'b0; end
    endcase
end
endmodule
module input_of_FIFO(init,com,de_mux_clr_out,dmux_sel_out,base_address,clk,out0,out1,out2,out3,out4);
input init,clk;
output com;
input[7:0] base_address;
output[31:0] out0,out1,out2,out3,out4;
output de_mux_clr_out;
output[2:0] dmux_sel_out;
wire LM_clr,de_mux_clr;
wire[7:0] base_address_ctrl;
wire complete;
assign com=complete;
assign de_mux_clr_out=de_mux_clr;
computational_block CB(LM_clr,de_mux_clr,complete,dmux_sel_out,base_address_ctrl,clk,out0,out1,out2,out3,out4);
controller CN(init,complete,base_address,LM_clr,de_mux_clr,base_address_ctrl,clk);
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
module MEM_FIFO(init,com,clk,rst,rd_en,base_address,out0,out1,out2,out3,out4);
input init,clk,rst;
output com;
output[31:0] out0,out1,out2,out3,out4;
input[7:0] base_address;
input[4:0] rd_en;
wire[31:0] in0,in1,in2,in3,in4;
wire[4:0] wr_en,buf_empty,buf_full;
wire[2:0] dmux_sel_out;
wire en;
assign en=&buf_full;
input_of_FIFO IOF(init & ~en,com,de_mux_clr_out,dmux_sel_out,base_address,clk,in0,in1,in2,in3,in4);
FIFO F0(clk,rst,in0,out0,wr_en[0],rd_en[0],buf_empty[0],buf_full[0]);
FIFO F1(clk,rst,in1,out1,wr_en[1],rd_en[1],buf_empty[1],buf_full[1]);
FIFO F2(clk,rst,in2,out2,wr_en[2],rd_en[2],buf_empty[2],buf_full[2]);
FIFO F3(clk,rst,in3,out3,wr_en[3],rd_en[3],buf_empty[3],buf_full[3]);
FIFO F4(clk,rst,in4,out4,wr_en[4],rd_en[4],buf_empty[4],buf_full[4]);
signal_to_FIFO STF(de_mux_clr_out,dmux_sel_out,wr_en);
endmodule