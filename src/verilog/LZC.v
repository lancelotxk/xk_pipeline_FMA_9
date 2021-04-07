module LZC (in,num);

`include "parameters.v"

input [3*(SIG_WIDTH+1)+5:0] in;
output reg[6:0] num;

reg [63:0]sel1;
reg [13:0]sel2;
reg [31:0]sel3;
reg [15:0]sel4;
reg [7:0]sel5;
reg [3:0]sel6;
reg [1:0]sel7;

integer i;
always@(*)  begin
	if (|in[3*(SIG_WIDTH+1)+5:14]==0) begin
		num[6]=1;
		sel2=in[13:0];
	end
	else begin
		num[6]=0;
		sel1=in[3*(SIG_WIDTH+1)+5:14];
	end
end
always@(*)  begin
	if (|sel1[63:32]==0) begin
		num[5]=1;
		sel3=sel1[31:0];
	end
	else begin
		num[5]=0;
		sel3=sel1[63:32];
	end
end
always@(*)  begin
	if (|sel3[31:16]==0) begin
		num[4]=1;
		sel4=sel3[15:0];
	end
	else begin
		num[4]=0;
		sel4=sel3[31:16];
	end
end
always@(*)  begin
	if (|sel4[15:8]==0) begin
		num[3]=1;
		sel5=sel4[7:0];
	end
	else begin
		num[3]=0;
		sel5=sel4[15:8];
	end
end
always@(*)  begin
	if (|sel5[7:4]==0) begin
		num[2]=1;
		sel6=sel5[3:0];
	end
	else begin
		num[2]=0;
		sel6=sel5[7:4];
	end
end
always@(*)  begin
	if (|sel6[3:2]==0) begin
		num[1]=1;
		sel7=sel6[1:0];
	end
	else begin
		num[1]=0;
		sel7=sel6[3:2];
	end
end
always@(*)  begin
	if (sel7[1]==1)
		num[0]=0;
	else
		num[0]=1;

end

endmodule
