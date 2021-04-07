module compress6_2 (in,cin,cout,carry,sum);

input [5:0] in;
input [2:0] cin;
output sum,carry;
output [2:0] cout;

//wire [8:0] in_temp;
//assign in_temp={in,cin};
wire [2:0]s;
//wire [2:0]c;
compress3_2 comp1(in[2:0],s[0],cout[0]);
compress3_2 comp2(in[5:3],s[1],cout[1]);
compress3_2 comp3(cin,s[2],cout[2]);

//assign cout=c;
//wire sum_tem,carry_tem;
compress3_2 comp4(s,sum,carry);

//always @ *
//begin
	//sum=sum_tem;
	//carry=carry_tem;
//end




endmodule
