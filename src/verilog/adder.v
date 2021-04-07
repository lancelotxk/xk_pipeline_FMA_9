
module ahead_adder(cin,A,B,S,cout);
`include "parameters.v"
input cin;
input [CLA_GRP_WIDTH-1:0]A;
input [CLA_GRP_WIDTH-1:0]B;

output reg[CLA_GRP_WIDTH-1:0]S;
output reg cout;

reg [CLA_GRP_WIDTH-1:0]G;
reg [CLA_GRP_WIDTH-1:0]P;

reg [CLA_GRP_WIDTH-1:0]C;

integer i;
always @ (*) begin
for(i=0;i<CLA_GRP_WIDTH;i=i+1) begin
	G[i] <= A[i] & B[i];
	P[i] <= A[i] | B[i];
end

	C[0]<= G[0] | (cin&P[0]);
	S[0]<=A[0]^B[0]^cin;
for(i=1;i<CLA_GRP_WIDTH;i=i+1) begin
	C[i]<=G[i] | (C[i-1] & P[i]) ;
	S[i]<=A[i]^B[i]^C[i-1];
end
	cout<=C[CLA_GRP_WIDTH-1];
end
 
/*
assign C[0]= G[0] | (cin&P[0]);
assign C[1]= G[1] | (P[1]&G[0]) | (P[1]&P[0]&cin);
assign C[2]= G[2] | (P[2]&G[1]) | (P[2]&P[1]&G[0]) | (P[2]&P[1]&P[0]&cin);
assign C[3]= G[3] | (P[3]&G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]) | (P[3]&P[2]&P[1]&P[0]&cin);
 
assign S[0]=A[0]^B[0]^cin;
assign S[1]=A[1]^B[1]^C[0];
assign S[2]=A[2]^B[2]^C[1];
assign S[3]=A[3]^B[3]^C[2];
assign cout=C[3];
*/
 
endmodule



module adder(in1, in2, cin, sticky, effectiveOp, sum, cout );
`include "parameters.v"
  
input [ADDER_WIDTH-1:0] in1, in2;
input cin;
input sticky, effectiveOp;
output [ADDER_WIDTH-1:0] sum; 
//wire [ADDER_WIDTH-1:0] sum_basic;
//wire [ADDER_WIDTH-1:0] sum_plus_one;
output cout;

wire c1,c2;
ahead_adder u1 (effectiveOp,in1[CLA_GRP_WIDTH-1:0],in2[CLA_GRP_WIDTH-1:0],sum[CLA_GRP_WIDTH-1:0],c1);
ahead_adder u2 (c1,in1[ADDER_WIDTH-1:CLA_GRP_WIDTH],in2[ADDER_WIDTH-1:CLA_GRP_WIDTH],sum[ADDER_WIDTH-1:CLA_GRP_WIDTH],c2);

assign cout = c2;

endmodule



/*
module adder(in1, in2, cin, sticky, effectiveOp, sum, cout );
`include "parameters.v"
  
input [ADDER_WIDTH-1:0] in1, in2;
input cin;
input sticky, effectiveOp;
output [ADDER_WIDTH-1:0] sum; 
//wire [ADDER_WIDTH-1:0] sum_basic;
//wire [ADDER_WIDTH-1:0] sum_plus_one;
output cout;

assign {cout,sum} = in1+in2+effectiveOp;

endmodule

*/

