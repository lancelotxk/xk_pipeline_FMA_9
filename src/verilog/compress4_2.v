module compress4_2 (in,cin,cout,carry,sum);
input [3:0] in;
input cin;
output cout,carry,sum;

wire s;
compress3_2 u1 (in[3:1],s,cout);
compress3_2 u2 (.in({in[0],s,cin}),.s(sum),.c(carry));

endmodule
