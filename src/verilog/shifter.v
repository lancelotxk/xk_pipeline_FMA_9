
module shifter (S1big_1,S2big_1,S3big_1,S4big_1,S5big_1,S6big_1,S7big_1,S8big_1,S9big_1,
		C1big_1,C2big_1,C3big_1,C4big_1,C5big_1,C6big_1,C7big_1,C8big_1,C9big_1,
		shamt_ab1,shamt_ab2,shamt_ab3,shamt_ab4,shamt_ab5,shamt_ab6,shamt_ab7,shamt_ab8,shamt_ab9,
		product_sign,
		s1,s2,s3,s4,s5,s6,s7,s8,s9,c1,c2,c3,c4,c5,c6,c7,c8,c9);
`include "parameters.v"

input [2*(SIG_WIDTH+1)-1:0] S1big_1,S2big_1,S3big_1,S4big_1,S5big_1,S6big_1,S7big_1,S8big_1,S9big_1;
input [2*(SIG_WIDTH+1)-1:0] C1big_1,C2big_1,C3big_1,C4big_1,C5big_1,C6big_1,C7big_1,C8big_1,C9big_1;
input [SHAMT_WIDTH-1:0] shamt_ab1,shamt_ab2,shamt_ab3,shamt_ab4,shamt_ab5,shamt_ab6,shamt_ab7,shamt_ab8,shamt_ab9;
input [8:0] product_sign;
output [2*(SIG_WIDTH+1):0] s1,s2,s3,s4,s5,s6,s7,s8,s9,c1,c2,c3,c4,c5,c6,c7,c8,c9;

// shift the sum and carry
wire [2*(SIG_WIDTH+1)-1:0] S1big,S2big,S3big,S4big,S5big,S6big,S7big,S8big,S9big;
wire [2*(SIG_WIDTH+1)-1:0] C1big,C2big,C3big,C4big,C5big,C6big,C7big,C8big,C9big;

wire [2*(SIG_WIDTH+1)-1:0] C1big_2,C2big_2,C3big_2,C4big_2,C5big_2,C6big_2,C7big_2,C8big_2,C9big_2;
assign C1big_2[2*(SIG_WIDTH+1)-1]=1'b0;
assign C2big_2[2*(SIG_WIDTH+1)-1]=1'b0;
assign C3big_2[2*(SIG_WIDTH+1)-1]=1'b0;
assign C4big_2[2*(SIG_WIDTH+1)-1]=1'b0;
assign C5big_2[2*(SIG_WIDTH+1)-1]=1'b0;
assign C6big_2[2*(SIG_WIDTH+1)-1]=1'b0;
assign C7big_2[2*(SIG_WIDTH+1)-1]=1'b0;
assign C8big_2[2*(SIG_WIDTH+1)-1]=1'b0;
assign C9big_2[2*(SIG_WIDTH+1)-1]=1'b0;

assign C1big_2[2*(SIG_WIDTH+1)-2:0]=C1big_1[2*(SIG_WIDTH+1)-2:0];
assign C2big_2[2*(SIG_WIDTH+1)-2:0]=C2big_1[2*(SIG_WIDTH+1)-2:0];
assign C3big_2[2*(SIG_WIDTH+1)-2:0]=C3big_1[2*(SIG_WIDTH+1)-2:0];
assign C4big_2[2*(SIG_WIDTH+1)-2:0]=C4big_1[2*(SIG_WIDTH+1)-2:0];
assign C5big_2[2*(SIG_WIDTH+1)-2:0]=C5big_1[2*(SIG_WIDTH+1)-2:0];
assign C6big_2[2*(SIG_WIDTH+1)-2:0]=C6big_1[2*(SIG_WIDTH+1)-2:0];
assign C7big_2[2*(SIG_WIDTH+1)-2:0]=C7big_1[2*(SIG_WIDTH+1)-2:0];
assign C8big_2[2*(SIG_WIDTH+1)-2:0]=C8big_1[2*(SIG_WIDTH+1)-2:0];
assign C9big_2[2*(SIG_WIDTH+1)-2:0]=C9big_1[2*(SIG_WIDTH+1)-2:0];
/*
wire [2*(SIG_WIDTH+1)-1:0] C1big_2,C2big_2,C3big_2,C4big_2,C5big_2,C6big_2,C7big_2,C8big_2,C9big_2;

assign C1big_2=C1big_1<<1;
assign C2big_2=C2big_1<<1;
assign C3big_2=C3big_1<<1;
assign C4big_2=C4big_1<<1;
assign C5big_2=C5big_1<<1;
assign C6big_2=C6big_1<<1;
assign C7big_2=C7big_1<<1;
assign C8big_2=C8big_1<<1;
assign C9big_2=C9big_1<<1;
*/
assign S1big = S1big_1>>shamt_ab1;
assign C1big = C1big_2>>shamt_ab1;

assign S2big = S2big_1>>shamt_ab2;
assign C2big = C2big_2>>shamt_ab2;

assign S3big = S3big_1>>shamt_ab3;
assign C3big = C3big_2>>shamt_ab3;

assign S4big = S4big_1>>shamt_ab4;
assign C4big = C4big_2>>shamt_ab4;

assign S5big = S5big_1>>shamt_ab5;
assign C5big = C5big_2>>shamt_ab5;

assign S6big = S6big_1>>shamt_ab6;
assign C6big = C6big_2>>shamt_ab6;

assign S7big = S7big_1>>shamt_ab7;
assign C7big = C7big_2>>shamt_ab7;

assign S8big = S8big_1>>shamt_ab8;
assign C8big = C8big_2>>shamt_ab8;

assign S9big = S9big_1>>shamt_ab9;
assign C9big = C9big_2>>shamt_ab9;
/*
assign S1big = S1big_1>>shamt_ab1;
assign C1big = C1big_1>>shamt_ab1;

assign S2big = S2big_1>>shamt_ab2;
assign C2big = C2big_1>>shamt_ab2;

assign S3big = S3big_1>>shamt_ab3;
assign C3big = C3big_1>>shamt_ab3;

assign S4big = S4big_1>>shamt_ab4;
assign C4big = C4big_1>>shamt_ab4;

assign S5big = S5big_1>>shamt_ab5;
assign C5big = C5big_1>>shamt_ab5;

assign S6big = S6big_1>>shamt_ab6;
assign C6big = C6big_1>>shamt_ab6;

assign S7big = S7big_1>>shamt_ab7;
assign C7big = C7big_1>>shamt_ab7;

assign S8big = S8big_1>>shamt_ab8;
assign C8big = C8big_1>>shamt_ab8;

assign S9big = S9big_1>>shamt_ab9;
assign C9big = C9big_1>>shamt_ab9;
*/
// invert s and complement c
assign s1[2*(SIG_WIDTH+1)]= product_sign[0];
assign c1[2*(SIG_WIDTH+1)]= (|C1big[46:0])? product_sign[0]:1'b0;
assign s1[2*(SIG_WIDTH+1)-1:0]=product_sign[0]? ~S1big:S1big;
wire [2*(SIG_WIDTH+1)-1:0] c_com1;   //48bits
com_c u1 (C1big,c_com1);
assign c1[2*(SIG_WIDTH+1)-1:1]=product_sign[0]? c_com1[46:0]:C1big[2*(SIG_WIDTH+1)-2:0];
assign c1[0]=product_sign[0];

assign s2[2*(SIG_WIDTH+1)]= product_sign[1];
assign c2[2*(SIG_WIDTH+1)]= (|C2big[46:0])? product_sign[1]:1'b0;
assign s2[2*(SIG_WIDTH+1)-1:0]=product_sign[1]? ~S2big:S2big;
wire [2*(SIG_WIDTH+1)-1:0] c_com2;
com_c u2 (C2big,c_com2);
assign c2[2*(SIG_WIDTH+1)-1:1]=product_sign[1]? c_com2[46:0]:C2big[2*(SIG_WIDTH+1)-2:0];
assign c2[0]=product_sign[1];

assign s3[2*(SIG_WIDTH+1)]= product_sign[2];
assign c3[2*(SIG_WIDTH+1)]= (|C3big[46:0])? product_sign[2]:1'b0;
assign s3[2*(SIG_WIDTH+1)-1:0]=product_sign[2]? ~S3big:S3big;
wire [2*(SIG_WIDTH+1)-1:0] c_com3;
com_c u3 (C3big,c_com3);
assign c3[2*(SIG_WIDTH+1)-1:1]=product_sign[2]? c_com3[46:0]:C3big[2*(SIG_WIDTH+1)-2:0];
assign c3[0]=product_sign[2];

assign s4[2*(SIG_WIDTH+1)]= product_sign[3];
assign c4[2*(SIG_WIDTH+1)]= (|C4big[46:0])? product_sign[3]:1'b0;
assign s4[2*(SIG_WIDTH+1)-1:0]=product_sign[3]? ~S4big:S4big;
wire [2*(SIG_WIDTH+1)-1:0] c_com4;
com_c u4 (C4big,c_com4);
assign c4[2*(SIG_WIDTH+1)-1:1]=product_sign[3]? c_com4[46:0]:C4big[2*(SIG_WIDTH+1)-2:0];
assign c4[0]=product_sign[3];

assign s5[2*(SIG_WIDTH+1)]= product_sign[4];
assign c5[2*(SIG_WIDTH+1)]= (|C5big[46:0])? product_sign[4]:1'b0;
assign s5[2*(SIG_WIDTH+1)-1:0]=product_sign[4]? ~S5big:S5big;
wire [2*(SIG_WIDTH+1)-1:0] c_com5;
com_c u5 (C5big,c_com5);
assign c5[2*(SIG_WIDTH+1)-1:1]=product_sign[4]? c_com5[46:0]:C5big[2*(SIG_WIDTH+1)-2:0];
assign c5[0]=product_sign[4];

assign s6[2*(SIG_WIDTH+1)]= product_sign[5];
assign c6[2*(SIG_WIDTH+1)]= (|C6big[46:0])? product_sign[5]:1'b0;
assign s6[2*(SIG_WIDTH+1)-1:0]=product_sign[5]? ~S6big:S6big;
wire [2*(SIG_WIDTH+1)-1:0] c_com6;
com_c u6(C6big,c_com6);
assign c6[2*(SIG_WIDTH+1)-1:1]=product_sign[5]? c_com6[46:0]:C6big[2*(SIG_WIDTH+1)-2:0];
assign c6[0]=product_sign[5];

assign s7[2*(SIG_WIDTH+1)]= product_sign[6];
assign c7[2*(SIG_WIDTH+1)]= (|C7big[46:0])? product_sign[6]:1'b0;
assign s7[2*(SIG_WIDTH+1)-1:0]=product_sign[6]? ~S7big:S7big;
wire [2*(SIG_WIDTH+1)-1:0] c_com7;
com_c u7(C7big,c_com7);
assign c7[2*(SIG_WIDTH+1)-1:1]=product_sign[6]? c_com7[46:0]:C7big[2*(SIG_WIDTH+1)-2:0];
assign c7[0]=product_sign[6];

assign s8[2*(SIG_WIDTH+1)]= product_sign[7];
assign c8[2*(SIG_WIDTH+1)]= (|C8big[46:0])? product_sign[7]:1'b0;
assign s8[2*(SIG_WIDTH+1)-1:0]=product_sign[7]? ~S8big:S8big;
wire [2*(SIG_WIDTH+1)-1:0] c_com8;
com_c u8(C8big,c_com8);
assign c8[2*(SIG_WIDTH+1)-1:1]=product_sign[7]? c_com8[46:0]:C8big[2*(SIG_WIDTH+1)-2:0];
assign c8[0]=product_sign[7];

assign s9[2*(SIG_WIDTH+1)]= product_sign[8];
assign c9[2*(SIG_WIDTH+1)]= (|C9big[46:0])? product_sign[8]:1'b0;
assign s9[2*(SIG_WIDTH+1)-1:0]=product_sign[8]? ~S9big:S9big;
wire [2*(SIG_WIDTH+1)-1:0] c_com9;
com_c u9(C9big,c_com9);
assign c9[2*(SIG_WIDTH+1)-1:1]=product_sign[8]? c_com9[46:0]:C9big[2*(SIG_WIDTH+1)-2:0];
assign c9[0]=product_sign[8];

endmodule
