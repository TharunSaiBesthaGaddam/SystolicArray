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
module computational_block(LM_clr,mux_clr,com,base_address,clk,in0,in1,in2,in3,in4);
input LM_clr,mux_clr,clk;
output com;
input[7:0] base_address;
input[31:0] in0,in1,in2,in3,in4;
wire[5:0] LM_counter_out;
wire[7:0] LM_data;
wire[7:0] mem_address;
wire[31:0] mem_data;
wire[2:0] mux_sel;
location_memory_counter LMC(LM_counter_out,LM_clr,clk,com);
location_memory LM(LM_counter_out,LM_data,clk);
location_to_index LtoI(base_address,LM_data,mem_address);
memory MEM(mem_address,mem_data,clk);
mux_counter DMC(mux_sel,mux_clr,clk);
mux DM(mux_sel,mem_data,in0,in1,in2,in3,in4);
endmodule
module controller(init,com,base_address_in,LM_clr,mux_clr,base_address,clk);
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
   // S3:state<=com?S0:S3;
    endcase
end
always @(state) begin
    case(state)
    S0:begin LM_clr<=1'b1;mux_clr<=1'b1;base_address<=base_address_in; end
    S1:begin LM_clr<=1'b0;mux_clr<=1'b1; end
    S2:begin LM_clr<=1'b0;mux_clr<=1'b0; end
    //S3:begin LM_clr<=1'b0;mux_clr<=1'b0; end
    endcase
end
endmodule
module SA_MEM(init,com,base_address,clk,in0,in1,in2,in3,in4);
input init,clk;
output com;
input[7:0] base_address;
input[31:0] in0,in1,in2,in3,in4;
wire LM_clr,mux_clr;
wire[7:0] base_address_ctrl;
wire complete;
assign com=complete;
computational_block CB(LM_clr,mux_clr,complete,base_address_ctrl,clk,in0,in1,in2,in3,in4);
controller CN(init,complete,base_address,LM_clr,mux_clr,base_address_ctrl,clk);
endmodule