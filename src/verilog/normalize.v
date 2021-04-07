module normalize (in,num,exp1,normalized,exp);
`include "parameters.v"

input [3*(SIG_WIDTH+1)+5:0] in;
input [6:0] num;
input [EXP_WIDTH-1:0] exp1;
output [SIG_WIDTH:0] normalized;
output reg[EXP_WIDTH-1:0] exp;
//output [6:0] exp_shift;

wire [3*(SIG_WIDTH+1)+5:0] normalized_pre;
assign normalized_pre=in<<num;

assign normalized = normalized_pre[3*(SIG_WIDTH+1)+5:3*(SIG_WIDTH+1)+5-23];

always @(*)begin
if(num>31)
	 exp=exp1-(num-31);
else
	 exp=exp1+(31-num);
end

endmodule
