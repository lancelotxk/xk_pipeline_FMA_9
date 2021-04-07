module CLA_adder (A,B,cin,S,cout);
//`include "parameters.v"
parameter WIDTH = 40;

input cin;
input [WIDTH-1:0]A;
input [WIDTH-1:0]B;

output reg[WIDTH-1:0]S;
output reg cout;

reg [WIDTH-1:0]G;
reg [WIDTH-1:0]P;

reg [WIDTH-1:0]C;

integer i;
always @ (*) begin
for(i=0;i<WIDTH;i=i+1) begin
	G[i] <= A[i] & B[i];
	P[i] <= A[i] | B[i];
end

	C[0]<= G[0] | (cin&P[0]);
	S[0]<=A[0]^B[0]^cin;

for(i=1;i<WIDTH;i=i+1) begin
	C[i]<=G[i] | (C[i-1] & P[i]) ;
	S[i]<=A[i]^B[i]^C[i-1];
end
	cout<=C[WIDTH-1];
end
endmodule
