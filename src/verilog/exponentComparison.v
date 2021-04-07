module exponentComparison(a1Exp,a2Exp,a3Exp,a4Exp,a5Exp,a6Exp,a7Exp,a8Exp,a9Exp,
		          b1Exp,b2Exp,b3Exp,b4Exp,b5Exp,b6Exp,b7Exp,b8Exp,b9Exp,cExp,cIsSubnormal,
			  a1iszero,a2iszero,a3iszero,a4iszero,a5iszero,a6iszero,a7iszero,a8iszero,a9iszero,
		          b1iszero,b2iszero,b3iszero,b4iszero,b5iszero,b6iszero,b7iszero,b8iszero,b9iszero,
			  shamt_ab1,shamt_ab2,shamt_ab3,shamt_ab4,shamt_ab5,shamt_ab6,shamt_ab7,shamt_ab8,shamt_ab9,
		          shamt_c,exp1);
`include "parameters.v"
input [EXP_WIDTH-1:0] a1Exp,a2Exp,a3Exp,a4Exp,a5Exp,a6Exp,a7Exp,a8Exp,a9Exp; 
input [EXP_WIDTH-1:0] b1Exp,b2Exp,b3Exp,b4Exp,b5Exp,b6Exp,b7Exp,b8Exp,b9Exp; 
input [EXP_WIDTH-1:0] cExp;
input cIsSubnormal;
input a1iszero,a2iszero,a3iszero,a4iszero,a5iszero,a6iszero,a7iszero,a8iszero,a9iszero;
input b1iszero,b2iszero,b3iszero,b4iszero,b5iszero,b6iszero,b7iszero,b8iszero,b9iszero;
output [SHAMT_WIDTH-1:0] shamt_ab1,shamt_ab2,shamt_ab3,shamt_ab4,shamt_ab5,shamt_ab6,shamt_ab7,shamt_ab8,shamt_ab9;
output [SHAMT_WIDTH-1:0] shamt_c;
output [EXP_WIDTH-1:0] exp1;
 // output cExpIsSmall;
 // output [EXP_WIDTH:0]d;
wire allinput_iszero;
assign allinput_iszero = (a1iszero&a2iszero&a3iszero&a4iszero&a5iszero&a6iszero&a7iszero&a8iszero&a9iszero)|
			 (b1iszero&b2iszero&b3iszero&b4iszero&b5iszero&b6iszero&b7iszero&b8iszero&b9iszero);

wire [EXP_WIDTH:0] product_exp1= (a1iszero|b1iszero)?9'b0_0000_0000:a1Exp + b1Exp;
wire [EXP_WIDTH:0] product_exp2= (a2iszero|b2iszero)?9'b0_0000_0000:a2Exp + b2Exp;
wire [EXP_WIDTH:0] product_exp3= (a3iszero|b3iszero)?9'b0_0000_0000:a3Exp + b3Exp;
wire [EXP_WIDTH:0] product_exp4= (a4iszero|b4iszero)?9'b0_0000_0000:a4Exp + b4Exp;
wire [EXP_WIDTH:0] product_exp5= (a5iszero|b5iszero)?9'b0_0000_0000:a5Exp + b5Exp;
wire [EXP_WIDTH:0] product_exp6= (a6iszero|b6iszero)?9'b0_0000_0000:a6Exp + b6Exp;
wire [EXP_WIDTH:0] product_exp7= (a7iszero|b7iszero)?9'b0_0000_0000:a7Exp + b7Exp;
wire [EXP_WIDTH:0] product_exp8= (a8iszero|b8iszero)?9'b0_0000_0000:a8Exp + b8Exp;
wire [EXP_WIDTH:0] product_exp9= (a9iszero|b9iszero)?9'b0_0000_0000:a9Exp + b9Exp;
  
  
//assign product_exp = a1Exp + b1Exp;

// find the max exponent
wire [EXP_WIDTH:0] exp_max1,exp_max2,exp_max3,exp_max4,exp_max5,exp_max6,exp_max7,exp_pro;
assign exp_max1=(product_exp1>product_exp2)?product_exp1:product_exp2;
assign exp_max2=(product_exp3>product_exp4)?product_exp3:product_exp4;
assign exp_max3=(product_exp5>product_exp6)?product_exp5:product_exp6;
assign exp_max4=(product_exp7>product_exp8)?product_exp7:product_exp8;

assign exp_max5=(exp_max1>exp_max2)?exp_max1:exp_max2;
assign exp_max6=(exp_max3>exp_max4)?exp_max3:exp_max4;

assign exp_max7=(exp_max5>exp_max6)?exp_max5:exp_max6;

// exp_pro is the max exp of all the products
assign exp_pro=(product_exp9>exp_max7)?product_exp9:exp_max7;

// conculate the shift amount of the exps
assign shamt_ab1=exp_pro-product_exp1;
assign shamt_ab2=exp_pro-product_exp2;
assign shamt_ab3=exp_pro-product_exp3;
assign shamt_ab4=exp_pro-product_exp4;
assign shamt_ab5=exp_pro-product_exp5;
assign shamt_ab6=exp_pro-product_exp6;
assign shamt_ab7=exp_pro-product_exp7;
assign shamt_ab8=exp_pro-product_exp8;
assign shamt_ab9=exp_pro-product_exp9;

// conculate the shift amount of the C
wire [SHAMT_WIDTH-1:0] shamt_internal, shamt_pre;

assign shamt_pre = allinput_iszero? 30 : exp_pro - BIAS - cExp + (SIG_WIDTH+7);
assign shamt_internal = (cExp > (exp_pro - BIAS + (SIG_WIDTH+7)))?0:shamt_pre;
assign shamt_c=(cIsSubnormal)? shamt_internal+1:shamt_internal;
  
  
wire [EXP_WIDTH:0] exp_AB = exp_pro - BIAS;
//assign d = exp_AB - cExp;
wire cExpIsSmall;
assign cExpIsSmall = ((exp_pro - BIAS) >= cExp);
//assign exp1= ( cExpIsSmall )?exp_pro-BIAS:cExp;//Result exponent

assign exp1= allinput_iszero?cExp:exp_pro-BIAS;

endmodule
