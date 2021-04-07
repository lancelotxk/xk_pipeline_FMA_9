
////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 1998  - 2009 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Rick Kelly               November 3, 1998
//
// VERSION:   Verilog Simulation Model for DW02_multp
//
// DesignWare_version: 435bc2ed
// DesignWare_release: B-2008.09-DWBB_0901
//
////////////////////////////////////////////////////////////////////////////////



//-----------------------------------------------------------------------------
//
// ABSTRACT:  Multiplier, parital products
//
//    **** >>>>  NOTE:	This model is architecturally different
//			from the 'wall' implementation of DW02_multp
//			but will generate exactly the same result
//			once the two partial product outputs are
//			added together
//
// MODIFIED:
//
//              Aamir Farooqui 7/11/02
//              Corrected parameter simplied sim model, checking, and X_processing 
//
//------------------------------------------------------------------------------


module my_multp( a, b, tc, out0, out1 );


// parameters
parameter a_width = 24;
parameter b_width = 24;
parameter out_width = 48;

`define npp ((a_width/2) + 2)  //14
`define xdim (a_width+b_width)  //48
`define bsxt (a_width) //24

//-----------------------------------------------------------------------------
// ports
input [a_width-1 : 0]	a;
input [b_width-1 : 0]	b;
input			tc;
output reg [out_width-1:0]	out0, out1 ;


reg   [`xdim-1 : 0]     pp_array [0 : `npp-1];  //49*14
reg   [`xdim-1 : 0]	tmp_OUT0, tmp_OUT1;  //48
wire  [a_width+2 : 0]	a_padded;  //27 bits
wire  [`xdim-1 : 0]	b_padded;  //49 bits
wire  [`xdim-b_width-1 : 0]	temp_padded;   //25 bits
wire  			a_sign, b_sign;


  assign a_sign = tc & a[a_width-1];  //tc==0
  assign b_sign = tc & b[b_width-1];
  assign a_padded = {a_sign, a_sign, a, 1'b0};  // pad a: put 0 to the LSB of a and two 0s to the MSB 
  assign temp_padded = {`bsxt{b_sign}}; // 24bits 0
  assign b_padded = {temp_padded, b};  //48bits

  always @ (a_padded or b_padded)
  begin : mk_pp_array
    reg [`xdim-1 : 0] temp_pp_array [0 : `npp-1];
    reg [`xdim-1 : 0] next_pp_array [0 : `npp-1];
    reg [`xdim+3 : 0] temp_pp; //53bits
    reg [`xdim-1 : 0] new_pp;  //49 bits
    reg [`xdim-1 : 0] tmp_pp_carry; 
    reg [a_width+2 : 0] temp_a_padded; //27bits
    reg [2 : 0] temp_bitgroup;  //the 3 bits of booth code
    integer bit_pair, pp_count, i;  //bit_pair is the number of times

    temp_pp_array[0] = {`xdim{1'b0}};  // the 0 column are 49 0s

    for (bit_pair=0 ; bit_pair < `npp-1 ; bit_pair = bit_pair+1)
    begin
      temp_a_padded = (a_padded >> (bit_pair*2));
      temp_bitgroup = temp_a_padded[2 : 0];

      case (temp_bitgroup)
        3'b000, 3'b111 :
          temp_pp = {`xdim{1'b0}};
        3'b001, 3'b010 :
          temp_pp = b_padded;
        3'b011 :
          temp_pp = b_padded << 1;
        3'b100 :
          temp_pp = (~(b_padded << 1) + 1);
        3'b101, 3'b110 :
          temp_pp =  ~b_padded + 1;
        default : temp_pp = {`xdim{1'b0}};
      endcase

      temp_pp = temp_pp << (2 * bit_pair);
      new_pp = temp_pp[`xdim-1 : 0];
      temp_pp_array[bit_pair+1] = new_pp;
    end
    pp_count = `npp; //14 partial products

    while (pp_count > 3)
    begin
      for (i=0 ; i < (pp_count/3) ; i = i+1)
      begin       //Each three digits generates a Sum and Carry signal
        next_pp_array[i*2] = temp_pp_array[i*3] ^ temp_pp_array[i*3+1] ^ temp_pp_array[i*3+2];   //sum bits

        tmp_pp_carry = (temp_pp_array[i*3] & temp_pp_array[i*3+1]) |      //deal with the carry
                       (temp_pp_array[i*3+1] & temp_pp_array[i*3+2]) |
                       (temp_pp_array[i*3] & temp_pp_array[i*3+2]);

        next_pp_array[i*2+1] = tmp_pp_carry << 1;
      end

      if ((pp_count % 3) > 0)
      begin
        for (i=0 ; i < (pp_count % 3) ; i = i + 1)
        next_pp_array[2 * (pp_count/3) + i] = temp_pp_array[3 * (pp_count/3) + i];
      end

      for (i=0 ; i < `npp ; i = i + 1) 
        temp_pp_array[i] = next_pp_array[i];  //update the pp array

      pp_count = pp_count - (pp_count/3);  //Reduce the number of rows
    end
	next_pp_array[0] = temp_pp_array[0] ^ temp_pp_array[1] ^ temp_pp_array[2];
	tmp_pp_carry = (temp_pp_array[0] & temp_pp_array[0+1]) |      //deal with the carry
                       (temp_pp_array[0+1] & temp_pp_array[0+2]) |
                       (temp_pp_array[0] & temp_pp_array[0+2]);
	next_pp_array[1] = tmp_pp_carry;
	temp_pp_array[0]=next_pp_array[0];
	temp_pp_array[1]=next_pp_array[1];


    tmp_OUT0 = temp_pp_array[0];   //this means the sum 

    if (pp_count > 1)
      tmp_OUT1 = temp_pp_array[1];   //this is the carry
    else
      tmp_OUT1 = {`xdim{1'b0}};
  end // mk_pp_array


  //assign out_sign = tmp_OUT0[`xdim-1] | tmp_OUT1[`xdim-1];

always @ *
begin
   out0 <= tmp_OUT0;
   out1 <= tmp_OUT1;
end

//assign out0 = tmp_OUT0;
//assign out1 = tmp_OUT1;

endmodule
