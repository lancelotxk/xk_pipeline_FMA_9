module fpfma_pipeline(rst,clk,A1,A2,A3,A4,A5,A6,A7,A8,A9, 
	     B1,B2,B3,B4,B5,B6,B7,B8,B9,C, rnd,result_p3);
`include "parameters.v"
// pipeline 1

input clk,rst;
input [WIDTH-1:0] A1,A2,A3,A4,A5,A6,A7,A8,A9;
input [WIDTH-1:0] B1,B2,B3,B4,B5,B6,B7,B8,B9;
input [WIDTH-1:0] C;
input [1:0] rnd;
//input clk, rst;  
output [WIDTH-1:0] result_p3;
//debug 2021/3/24
//wire [WIDTH-1:0] AA, BB;
//wire aasign,bbsign;
//wire [EXP_WIDTH-1:0] aaExp,bbExp;
//wire [SIG_WIDTH-1:0] aaSig,bbSig;

//Unpacking and subnormal checks
wire aIsSubnormal, bIsSubnormal, cIsSubnormal;
wire [8:0] aSign, bSign;
wire cSign;
wire [EXP_WIDTH-1:0] a1Exp,a2Exp,a3Exp,a4Exp,a5Exp,a6Exp,a7Exp,a8Exp,a9Exp;
wire [EXP_WIDTH-1:0] b1Exp,b2Exp,b3Exp,b4Exp,b5Exp,b6Exp,b7Exp,b8Exp,b9Exp ;
wire [EXP_WIDTH-1:0] cExp;
wire [SIG_WIDTH:0] a1Sig,a2Sig,a3Sig,a4Sig,a5Sig,a6Sig,a7Sig,a8Sig,a9Sig; 
wire [SIG_WIDTH:0] b1Sig,b2Sig,b3Sig,b4Sig,b5Sig,b6Sig,b7Sig,b8Sig,b9Sig;
wire [SIG_WIDTH:0] cSig;
wire a1iszero,a2iszero,a3iszero,a4iszero,a5iszero,a6iszero,a7iszero,a8iszero,a9iszero,ciszero;
wire b1iszero,b2iszero,b3iszero,b4iszero,b5iszero,b6iszero,b7iszero,b8iszero,b9iszero;

unpack PACK1(.A(A1),.B(A2),.C(A3), .aSign(aSign[0]),.aExp(a1Exp),.aSig(a1Sig), .bSign(aSign[1]),.bExp(a2Exp),.bSig(a2Sig), 
	.cSign(aSign[2]),.cExp(a3Exp),.cSig(a3Sig),.cIsSubnormal(),.aiszero(a1iszero),.biszero(a2iszero),.ciszero(a3iszero));
unpack PACK2(.A(A4),.B(A5),.C(A6), .aSign(aSign[3]),.aExp(a4Exp),.aSig(a4Sig), .bSign(aSign[4]),.bExp(a5Exp),.bSig(a5Sig), 
	.cSign(aSign[5]),.cExp(a6Exp),.cSig(a6Sig),.cIsSubnormal(),.aiszero(a4iszero),.biszero(a5iszero),.ciszero(a6iszero));
unpack PACK3(.A(A7),.B(A8),.C(A9), .aSign(aSign[6]),.aExp(a7Exp),.aSig(a7Sig), .bSign(aSign[7]),.bExp(a8Exp),.bSig(a8Sig), 
	.cSign(aSign[8]),.cExp(a9Exp),.cSig(a9Sig),.cIsSubnormal(),.aiszero(a7iszero),.biszero(a8iszero),.ciszero(a9iszero));

unpack PACK4(.A(B1),.B(B2),.C(B3), .aSign(bSign[0]),.aExp(b1Exp),.aSig(b1Sig), .bSign(bSign[1]),.bExp(b2Exp),.bSig(b2Sig), 
	.cSign(bSign[2]),.cExp(b3Exp),.cSig(b3Sig),.cIsSubnormal(),.aiszero(b1iszero),.biszero(b2iszero),.ciszero(b3iszero));
unpack PACK5(.A(B4),.B(B5),.C(B6), .aSign(bSign[3]),.aExp(b4Exp),.aSig(b4Sig), .bSign(bSign[4]),.bExp(b5Exp),.bSig(b5Sig), 
	.cSign(bSign[5]),.cExp(b6Exp),.cSig(b6Sig),.cIsSubnormal(),.aiszero(b4iszero),.biszero(b5iszero),.ciszero(b6iszero));
unpack PACK6(.A(B7),.B(B8),.C(B9), .aSign(bSign[6]),.aExp(b7Exp),.aSig(b7Sig), .bSign(bSign[7]),.bExp(b8Exp),.bSig(b8Sig), 
	.cSign(bSign[8]),.cExp(b9Exp),.cSig(b9Sig),.cIsSubnormal(),.aiszero(b7iszero),.biszero(b8iszero),.ciszero(b9iszero));

//unpack PACK7(AA,BB,C,aasign,aaExp,aaSig,bbsign,bbExp,bbSig,cSign,cExp,cSig);
unpack PACK7(.A(),.B(),.C(C),.aSign(), .aExp(), .aSig(),.bSign(), .bExp(), .bSig(),.cSign(cSign), .cExp(cExp), 
	.cSig(cSig),.cIsSubnormal(cIsSubnormal),.ciszero(ciszero));

wire [8:0] product_sign=aSign ^ bSign;    // product_sign[0] is the sign of A1*B1

//Exponent comparison
wire [EXP_WIDTH-1:0] exp1;
wire [SHAMT_WIDTH-1:0] shamt_ab1,shamt_ab2,shamt_ab3,shamt_ab4,shamt_ab5,shamt_ab6,shamt_ab7,shamt_ab8,shamt_ab9,shamt_c;

exponentComparison  EC(a1Exp,a2Exp,a3Exp,a4Exp,a5Exp,a6Exp,a7Exp,a8Exp,a9Exp,
		       b1Exp,b2Exp,b3Exp,b4Exp,b5Exp,b6Exp,b7Exp,b8Exp,b9Exp,cExp,cIsSubnormal,
		       a1iszero,a2iszero,a3iszero,a4iszero,a5iszero,a6iszero,a7iszero,a8iszero,a9iszero,
		       b1iszero,b2iszero,b3iszero,b4iszero,b5iszero,b6iszero,b7iszero,b8iszero,b9iszero,
		       shamt_ab1,shamt_ab2,shamt_ab3,shamt_ab4,shamt_ab5,shamt_ab6,shamt_ab7,shamt_ab8,shamt_ab9,
		       shamt_c,exp1);

//align C
wire [3*(SIG_WIDTH+1)+6:0] CAligned ;  // 79bits which the MSB is the sign

align ALGN(cSig, shamt_c, cSign,CAligned);

// 9*booth multiplier and the outputs are 18 CSA sum and carry
wire [2*(SIG_WIDTH+1)-1:0] S1big,S2big,S3big,S4big,S5big,S6big,S7big,S8big,S9big;
wire [2*(SIG_WIDTH+1)-1:0] C1big,C2big,C3big,C4big,C5big,C6big,C7big,C8big,C9big;

my_multp #(.a_width(24),.b_width(24),.out_width(48)) multp_1(.a(a1Sig),.b(b1Sig),.tc(1'b0),.out0(S1big),.out1(C1big) ); 
my_multp #(.a_width(24),.b_width(24),.out_width(48)) multp_2(.a(a2Sig),.b(b2Sig),.tc(1'b0),.out0(S2big),.out1(C2big) ); 
my_multp #(.a_width(24),.b_width(24),.out_width(48)) multp_3(.a(a3Sig),.b(b3Sig),.tc(1'b0),.out0(S3big),.out1(C3big) ); 
my_multp #(.a_width(24),.b_width(24),.out_width(48)) multp_4(.a(a4Sig),.b(b4Sig),.tc(1'b0),.out0(S4big),.out1(C4big) ); 
my_multp #(.a_width(24),.b_width(24),.out_width(48)) multp_5(.a(a5Sig),.b(b5Sig),.tc(1'b0),.out0(S5big),.out1(C5big) ); 
my_multp #(.a_width(24),.b_width(24),.out_width(48)) multp_6(.a(a6Sig),.b(b6Sig),.tc(1'b0),.out0(S6big),.out1(C6big) ); 
my_multp #(.a_width(24),.b_width(24),.out_width(48)) multp_7(.a(a7Sig),.b(b7Sig),.tc(1'b0),.out0(S7big),.out1(C7big) ); 
my_multp #(.a_width(24),.b_width(24),.out_width(48)) multp_8(.a(a8Sig),.b(b8Sig),.tc(1'b0),.out0(S8big),.out1(C8big) ); 
my_multp #(.a_width(24),.b_width(24),.out_width(48)) multp_9(.a(a9Sig),.b(b9Sig),.tc(1'b0),.out0(S9big),.out1(C9big) ); 

wire cSign_p1;
wire [8:0] product_sign_p1;
wire [3*(SIG_WIDTH+1)+6:0] CAligned_p1;
wire [EXP_WIDTH-1:0] exp1_p1;
wire [SHAMT_WIDTH-1:0] shamt_ab1_p1,shamt_ab2_p1,shamt_ab3_p1,shamt_ab4_p1,shamt_ab5_p1,shamt_ab6_p1,shamt_ab7_p1,shamt_ab8_p1,shamt_ab9_p1;
wire [2*(SIG_WIDTH+1)-1:0] S1big_p1,S2big_p1,S3big_p1,S4big_p1,S5big_p1,S6big_p1,S7big_p1,S8big_p1,S9big_p1;
wire [2*(SIG_WIDTH+1)-1:0] C1big_p1,C2big_p1,C3big_p1,C4big_p1,C5big_p1,C6big_p1,C7big_p1,C8big_p1,C9big_p1;
reg_pipeline1  pipe1 (rst,clk,exp1,product_sign,cSign,CAligned,
	   	shamt_ab1,shamt_ab2,shamt_ab3,shamt_ab4,shamt_ab5,shamt_ab6,shamt_ab7,shamt_ab8,shamt_ab9,
	   	S1big,S2big,S3big,S4big,S5big,S6big,S7big,S8big,S9big,
	   	C1big,C2big,C3big,C4big,C5big,C6big,C7big,C8big,C9big,
	   exp1_p1,product_sign_p1,cSign_p1,CAligned_p1,
	   shamt_ab1_p1,shamt_ab2_p1,shamt_ab3_p1,shamt_ab4_p1,shamt_ab5_p1,shamt_ab6_p1,shamt_ab7_p1,shamt_ab8_p1,shamt_ab9_p1,
	   S1big_p1,S2big_p1,S3big_p1,S4big_p1,S5big_p1,S6big_p1,S7big_p1,S8big_p1,S9big_p1,
	   C1big_p1,C2big_p1,C3big_p1,C4big_p1,C5big_p1,C6big_p1,C7big_p1,C8big_p1,C9big_p1);

reg [WIDTH-1:0] A1_r1,A2_r1,A3_r1,A4_r1,A5_r1,A6_r1,A7_r1,A8_r1,A9_r1;
reg [WIDTH-1:0] B1_r1,B2_r1,B3_r1,B4_r1,B5_r1,B6_r1,B7_r1,B8_r1,B9_r1;
reg [WIDTH-1:0] C_r1;
always @(posedge clk or negedge rst) begin
    if(~rst) begin
      A1_r1 <= 0;
	  A2_r1 <= 0;
	  A3_r1 <= 0;
	  A4_r1 <= 0;
	  A5_r1 <= 0;
	  A6_r1 <= 0;
	  A7_r1 <= 0;
	  A8_r1 <= 0;
	  A9_r1 <= 0;
      B1_r1 <= 0;
	  B2_r1 <= 0;
	  B3_r1 <= 0;
	  B4_r1 <= 0;
	  B5_r1 <= 0;
	  B6_r1 <= 0;
	  B7_r1 <= 0;
	  B8_r1 <= 0;
	  B9_r1 <= 0;
      C_r1 <= 0;
    end else begin
      A1_r1 <= A1;
	  A2_r1 <= A2;
	  A3_r1 <= A3;
	  A4_r1 <= A4;
	  A5_r1 <= A5;
	  A6_r1 <= A6;
	  A7_r1 <= A7;
	  A8_r1 <= A8;
	  A9_r1 <= A9;
      B1_r1 <= B1;
	  B2_r1 <= B2;
	  B3_r1 <= B3;
	  B4_r1 <= B4;
	  B5_r1 <= B5;
	  B6_r1 <= B6;
	  B7_r1 <= B7;
	  B8_r1 <= B8;
	  B9_r1 <= B9;
      C_r1 <= C;
    end
end

   //2021/04/05
reg en; // Enable to output the result
reg en_r2;
always @ (A1 or B1 or C or en_r2) begin
    if(~rst) begin
        en <= 1;
    end else begin
    if((A1 != A1_r1) || (B1 != B1_r1) || (B2 != B2_r1)|| (B3 != B3_r1)|| (B4 != B4_r1)|| (B5 != B5_r1)|| (C != C_r1)) begin 
          en <= 1;
    end else begin
        if(~en_r2) begin
            en <= 0;
        end else begin
            en <= en;
        	end
        end
    end

end


  reg en_r1;
  always @ (posedge clk) begin
     //  if(~rst) begin
     //    en_r1 <= 0;
     // end else begin
        if(~en_r2) begin
          en_r1 <= en;
        end else begin
          en_r1 <= 0;
        // end
     end
  end




// pipeline 2
wire [2*(SIG_WIDTH+1):0] s1,s2,s3,s4,s5,s6,s7,s8,s9; //49bits
wire [2*(SIG_WIDTH+1):0] c1,c2,c3,c4,c5,c6,c7,c8,c9; //49bits

shifter mul_shift (S1big_p1,S2big_p1,S3big_p1,S4big_p1,S5big_p1,S6big_p1,S7big_p1,S8big_p1,S9big_p1,
		   C1big_p1,C2big_p1,C3big_p1,C4big_p1,C5big_p1,C6big_p1,C7big_p1,C8big_p1,C9big_p1,
		   shamt_ab1_p1,shamt_ab2_p1,shamt_ab3_p1,shamt_ab4_p1,shamt_ab5_p1,shamt_ab6_p1,shamt_ab7_p1,shamt_ab8_p1,shamt_ab9_p1,
		   product_sign_p1,
		   s1,s2,s3,s4,s5,s6,s7,s8,s9,c1,c2,c3,c4,c5,c6,c7,c8,c9);

//wire [48:0] test=s1+c1;
wire [2*(SIG_WIDTH+1)+4:0] result_9_man_sum ,result_9_man_carry;
adder_pp add (s1,s2,s3,s4,s5,s6,s7,s8,s9,c1,c2,c3,c4,c5,c6,c7,c8,c9,result_9_man_sum ,result_9_man_carry);
//wire [52:0] sumof6 = s1+s2+s3+s4+s5+s6+s7+s8+s9+c1+c2+c3+c4+c5+c6+c7+c8+c9;
//wire [2*(SIG_WIDTH+1)+4:0] result_9_man = result_9_man_sum+result_9_man_carry;

wire [25:0] pad_man_1 = {26{result_9_man_sum[2*(SIG_WIDTH+1)+4]}};
wire [3*(SIG_WIDTH+1)+6:0] pad_man_sum = {pad_man_1,result_9_man_sum};
wire [25:0] pad_man_2 = {26{result_9_man_carry[2*(SIG_WIDTH+1)+4]}};
wire [3*(SIG_WIDTH+1)+6:0] pad_man_carry = {pad_man_2,result_9_man_carry};
// send to a group of 3_2 compressors
wire [3*(SIG_WIDTH+1)+6:0] sum,carry;
compressor3_2_group compress_group (pad_man_sum,pad_man_carry,CAligned_p1,sum,carry,cSign_p1);
//wire [3*(SIG_WIDTH+1)+6:0] carry_shift = carry<<1;
//assign carry_shift[0]=cSign?1'b1:1'b0;

wire [EXP_WIDTH-1:0] exp1_p2;
wire [3*(SIG_WIDTH+1)+6:0] sum_p2,carry_p2;
reg_pipeline2 pipe2 (rst,clk,sum,carry,exp1_p1,exp1_p2,sum_p2,carry_p2);


always @ (posedge clk or negedge rst) begin
    if(~rst) begin
        en_r2 <= 0;
    end else begin
        if(en_r2) begin 
          en_r2 <= 0;
        end else begin
          en_r2 <= en_r1;
        end
    end
end
//pipeline 3

wire [3*(SIG_WIDTH+1)+6:0] man_abc_pre;
carry_select_adder  ADD_CSA (.A(sum_p2),.B(carry_p2),.cin(1'b0),.cout(),.S(man_abc_pre));
wire [3*(SIG_WIDTH+1)+6:0] man_abc;
wire sign_eff;
assign sign_eff = man_abc_pre[3*(SIG_WIDTH+1)+6];

assign man_abc = man_abc_pre[3*(SIG_WIDTH+1)+6]? (~ man_abc_pre)+1'b1 : man_abc_pre ; 

wire [3*(SIG_WIDTH+1)+5:0] man_abc_bin = man_abc[3*(SIG_WIDTH+1)+5:0];   //the MSB of man_abs is the sign of the result

wire [6:0] num;

LZC lzc (man_abc_bin,num);

wire [SIG_WIDTH:0] normalized;
wire [EXP_WIDTH-1:0] exp;
normalize normalize_shift (man_abc_bin,num,exp1_p2,normalized,exp);
wire [WIDTH-1:0] result;
assign result = {sign_eff,exp,normalized[SIG_WIDTH-1:0]};

reg_pipeline3 pipe3 (rst,clk,result,result_p3,en_r2);

endmodule

module reg_pipeline1 (rst,clk,exp1,product_sign,cSign,CAligned,
	   shamt_ab1,shamt_ab2,shamt_ab3,shamt_ab4,shamt_ab5,shamt_ab6,shamt_ab7,shamt_ab8,shamt_ab9,
	   S1big,S2big,S3big,S4big,S5big,S6big,S7big,S8big,S9big,
	   C1big,C2big,C3big,C4big,C5big,C6big,C7big,C8big,C9big,
	   exp1_p1,product_sign_p1,cSign_p1,CAligned_p1,
	   shamt_ab1_p1,shamt_ab2_p1,shamt_ab3_p1,shamt_ab4_p1,shamt_ab5_p1,shamt_ab6_p1,shamt_ab7_p1,shamt_ab8_p1,shamt_ab9_p1,
	   S1big_p1,S2big_p1,S3big_p1,S4big_p1,S5big_p1,S6big_p1,S7big_p1,S8big_p1,S9big_p1,
	   C1big_p1,C2big_p1,C3big_p1,C4big_p1,C5big_p1,C6big_p1,C7big_p1,C8big_p1,C9big_p1);
`include "parameters.v"
input rst,clk,cSign;
input [8:0] product_sign;
input [3*(SIG_WIDTH+1)+6:0] CAligned;
input [EXP_WIDTH-1:0] exp1;
input [SHAMT_WIDTH-1:0] shamt_ab1,shamt_ab2,shamt_ab3,shamt_ab4,shamt_ab5,shamt_ab6,shamt_ab7,shamt_ab8,shamt_ab9;
input [2*(SIG_WIDTH+1)-1:0] S1big,S2big,S3big,S4big,S5big,S6big,S7big,S8big,S9big;
input [2*(SIG_WIDTH+1)-1:0] C1big,C2big,C3big,C4big,C5big,C6big,C7big,C8big,C9big;
output reg cSign_p1;
output reg [8:0] product_sign_p1;
output reg [3*(SIG_WIDTH+1)+6:0] CAligned_p1;
output reg [EXP_WIDTH-1:0] exp1_p1;
output reg [SHAMT_WIDTH-1:0] shamt_ab1_p1,shamt_ab2_p1,shamt_ab3_p1,shamt_ab4_p1,shamt_ab5_p1,shamt_ab6_p1,shamt_ab7_p1,shamt_ab8_p1,shamt_ab9_p1;
output reg [2*(SIG_WIDTH+1)-1:0] S1big_p1,S2big_p1,S3big_p1,S4big_p1,S5big_p1,S6big_p1,S7big_p1,S8big_p1,S9big_p1;
output reg [2*(SIG_WIDTH+1)-1:0] C1big_p1,C2big_p1,C3big_p1,C4big_p1,C5big_p1,C6big_p1,C7big_p1,C8big_p1,C9big_p1;

always @(posedge clk or negedge rst) begin
	if(!rst) begin
		cSign_p1<=0;
		product_sign_p1<=0;
		CAligned_p1<=0;
		exp1_p1<=0;
		shamt_ab1_p1<=0;
		shamt_ab2_p1<=0;
		shamt_ab3_p1<=0;
		shamt_ab4_p1<=0;
		shamt_ab5_p1<=0;
		shamt_ab6_p1<=0;
		shamt_ab7_p1<=0;
		shamt_ab8_p1<=0;
		shamt_ab9_p1<=0;
		S1big_p1<=0;
		S2big_p1<=0;
		S3big_p1<=0;
		S4big_p1<=0;
		S5big_p1<=0;
		S6big_p1<=0;
		S7big_p1<=0;
		S8big_p1<=0;
		S9big_p1<=0;
		C1big_p1<=0;
		C2big_p1<=0;
		C3big_p1<=0;
		C4big_p1<=0;
		C5big_p1<=0;
		C6big_p1<=0;
		C7big_p1<=0;
		C8big_p1<=0;
		C9big_p1<=0;
	end else begin
		cSign_p1<=cSign;
		product_sign_p1<=product_sign;
		CAligned_p1<=CAligned;
		exp1_p1<=exp1;
		shamt_ab1_p1<=shamt_ab1;
		shamt_ab2_p1<=shamt_ab2;
		shamt_ab3_p1<=shamt_ab3;
		shamt_ab4_p1<=shamt_ab4;
		shamt_ab5_p1<=shamt_ab5;
		shamt_ab6_p1<=shamt_ab6;
		shamt_ab7_p1<=shamt_ab7;
		shamt_ab8_p1<=shamt_ab8;
		shamt_ab9_p1<=shamt_ab9;
		S1big_p1<=S1big;
		S2big_p1<=S2big;
		S3big_p1<=S3big;
		S4big_p1<=S4big;
		S5big_p1<=S5big;
		S6big_p1<=S6big;
		S7big_p1<=S7big;
		S8big_p1<=S8big;
		S9big_p1<=S9big;
		C1big_p1<=C1big;
		C2big_p1<=C2big;
		C3big_p1<=C3big;
		C4big_p1<=C4big;
		C5big_p1<=C5big;
		C6big_p1<=C6big;
		C7big_p1<=C7big;
		C8big_p1<=C8big;
		C9big_p1<=C9big;
	end
end

endmodule



module reg_pipeline2 (rst,clk,sum,carry,exp1_p1,exp1_p2,sum_p2,carry_p2);
`include "parameters.v"
input rst,clk;
input [3*(SIG_WIDTH+1)+6:0] sum,carry;
input [EXP_WIDTH-1:0] exp1_p1;
output reg [EXP_WIDTH-1:0] exp1_p2;
output reg [3*(SIG_WIDTH+1)+6:0] sum_p2,carry_p2;

always @ (posedge clk or negedge rst) begin
	if(!rst) begin
		exp1_p2<=0;
		sum_p2<=0;
		carry_p2<=0;
	end else begin
		exp1_p2<=exp1_p1;
		sum_p2<=sum;
		carry_p2<=carry;
	end
end
	
endmodule

module reg_pipeline3 (rst,clk,result,result_p3,en);
`include "parameters.v"
input rst,clk;
input [WIDTH-1:0] result;
input en;
output reg [WIDTH-1:0] result_p3;

always @ (posedge clk or negedge rst)begin
	if(!rst) begin
		result_p3<=0;
	end else if (en)begin
		result_p3<=result;
	end
end
endmodule
