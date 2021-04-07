module compress3_2 (in,s,c);
input [2:0]in;
output s,c;

assign s = in[0]^in[1]^in[2];

assign c = (in[0]&in[1])|in[2]&(in[0]|in[1]);

endmodule
