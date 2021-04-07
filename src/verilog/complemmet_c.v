module com_c (c,c_com);

`include "parameters.v"

input [2*(SIG_WIDTH+1)-1:0] c;
output [2*(SIG_WIDTH+1)-1:0] c_com;

wire [2*(SIG_WIDTH+1)-1:0] temp;

assign temp=~c+1;
assign c_com=temp[2*(SIG_WIDTH+1)-1:0];  //48bits

endmodule
