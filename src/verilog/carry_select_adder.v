module carry_select_adder (A,B,cin,cout,S);

`include "parameters.v"

input [3*(SIG_WIDTH+1)+6:0] A,B;
input cin;
//output [3*(SIG_WIDTH+1)+6:0] cout;
output cout;
output [3*(SIG_WIDTH+1)+6:0] S;

wire c1,c2,c3;
wire [38:0] s1,s2;

CLA_adder #(.WIDTH(40))CLA1(A[39:0],B[39:0],cin,S[39:0],c1);

CLA_adder #(.WIDTH(39))CLA2(A[78:40],B[78:40],1'b0,s1,c2);
CLA_adder #(.WIDTH(39))CLA3(A[78:40],B[78:40],1'b1,s2,c3);

assign S[78:40]=c1?s2:s1;
assign cout=c1?c3:c2;


endmodule
