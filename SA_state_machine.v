module SA_state_machine(clk,zero,index1,index2);
input clk;
output reg zero;
output reg[4:0] index1,index2;
reg[1:0] state;
parameter S0 =2'b00,S1=2'b01,S2=2'b10;
