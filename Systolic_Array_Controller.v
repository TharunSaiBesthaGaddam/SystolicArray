module counter(out,clk,clr);
input clk,clr;
output reg[3:0] out;
always @(posedge clk) begin
    if(clr)out<=4'b0000;
    else out<=out+1;
end
endmodule
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
module Systolic_Array_Controller(init,read,write,clr,clk);
input init,clk;
output[24:0] read,write,clr;
wire clr_C;
wire[3:0] C;
Controller C1(init,C,read,write,clr,clr_C,clk);
counter co(C,clk,clr_C);
endmodule