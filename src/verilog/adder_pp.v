module adder_pp (s1,s2,s3,s4,s5,s6,s7,s8,s9,c1,c2,c3,c4,c5,c6,c7,c8,c9,result_9_man_sum,result_9_man_carry);

`include "parameters.v"

input [2*(SIG_WIDTH+1):0] s1,s2,s3,s4,s5,s6,s7,s8,s9,c1,c2,c3,c4,c5,c6,c7,c8,c9;  //49bits
output [2*(SIG_WIDTH+1)+4:0] result_9_man_sum ,result_9_man_carry;

wire [2*(SIG_WIDTH+1)+2:0] sum1,carry1,sum2,carry2,sum3,carry3;
wire [2*(SIG_WIDTH+1)+4:0] sum4,carry4;

SAD_6 SAD1 (s1,s2,s3,s4,s5,s6,sum1,carry1);
SAD_6 SAD2 (s7,s8,s9,c1,c2,c3,sum2,carry2);
SAD_6 SAD3 (c4,c5,c6,c7,c8,c9,sum3,carry3);
wire [50:0] temp_1=sum1+carry1;
wire [50:0] temp_2=sum2+carry2;
wire [50:0] temp_3=sum1+carry3;

SAD_6_v2  SAD4 (sum1,carry1,sum2,carry2,sum3,carry3,sum4,carry4);

assign result_9_man_sum= sum4;
assign result_9_man_carry = carry4;

endmodule
