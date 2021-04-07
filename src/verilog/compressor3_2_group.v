module compressor3_2_group (in1,in2,in3,s,cout,csign);


parameter GRP_WIDTH=79;
    
input [GRP_WIDTH-1:0] in1, in2, in3;
input csign;
output [GRP_WIDTH-1:0] s, cout;

wire [GRP_WIDTH-1:0] c,cout_pre;

genvar i;
generate
  for (i=0;i<79;i=i+1)
	compress3_2 compress({in1[i], in2[i],in3[i]}, s[i], c[i]);
endgenerate

assign cout_pre=c<<1;
assign cout[GRP_WIDTH-1:1]=cout_pre[GRP_WIDTH-1:1];
assign cout[0]=csign?1'b1:1'b0;

endmodule
