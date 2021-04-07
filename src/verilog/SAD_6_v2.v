module SAD_6_v2 #(parameter SIG_WIDTH = 24)(in1,in2,in3,in4,in5,in6,sum,carry);

//parameter SIG_WIDTH = 23;

input [2*(SIG_WIDTH+1):0] in1,in2,in3,in4,in5,in6;
output [2*(SIG_WIDTH+1)+2:0] sum,carry;  //input 49 bits and output will be 51 bits

wire [2*(SIG_WIDTH+1)+2:0]s1,c1,s2,c2,s3,c3;
//wire cin={1'b0};
wire [2*(SIG_WIDTH+1)+2:0] cout;

wire [2*(SIG_WIDTH+1)+2:0] in1_pad,in2_pad,in3_pad,in4_pad,in5_pad,in6_pad;
assign in1_pad={{in1[2*(SIG_WIDTH+1)]},{in1[2*(SIG_WIDTH+1)]},in1};
assign in2_pad={{in2[2*(SIG_WIDTH+1)]},{in2[2*(SIG_WIDTH+1)]},in2};
assign in3_pad={{in3[2*(SIG_WIDTH+1)]},{in3[2*(SIG_WIDTH+1)]},in3};
assign in4_pad={{in4[2*(SIG_WIDTH+1)]},{in4[2*(SIG_WIDTH+1)]},in4};
assign in5_pad={{in5[2*(SIG_WIDTH+1)]},{in5[2*(SIG_WIDTH+1)]},in5};
assign in6_pad={{in6[2*(SIG_WIDTH+1)]},{in6[2*(SIG_WIDTH+1)]},in6};

genvar i;
generate
	for (i=0;i<2*(SIG_WIDTH+1)+3;i=i+1) begin
		compress3_2 m1 ({in1_pad[i],in2_pad[i],in3_pad[i]},s1[i],c1[i]);
		compress3_2 m2 ({in4_pad[i],in5_pad[i],in6_pad[i]},s2[i],c2[i]);
		if (i==0) begin
			compress4_2 m3 ({s1[i],s2[i],1'b0,1'b0},1'b0,cout[i],c3[i],s3[i]);
			//assign cin=cout;
		end
		else  begin
			compress4_2 m3 ({s1[i],s2[i],c1[i-1],c2[i-1]},cout[i-1],cout[i],c3[i],s3[i]);
			//assign cin=cout;
		end
	
	end
endgenerate


assign sum = s3;
assign carry = {c3[2*(SIG_WIDTH+1)+1:0],1'b0};



endmodule
