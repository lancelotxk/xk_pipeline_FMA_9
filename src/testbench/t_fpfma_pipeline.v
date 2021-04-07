module t_fpfma_pipeline();
  `include "parameters.v"

  reg [WIDTH-1:0] A1,A2,A3,A4,A5,A6,A7,A8,A9,B1,B2,B3,B4,B5,B6,B7,B8,B9,C;
  reg [31:0] x_ideal;
  reg [23:0] x_man;
  reg [7:0] idealExp;
  reg [1:0] rnd;  
  wire [WIDTH-1:0] result;
  wire res_compare;
  reg clk,rst;
  
  fpfma_pipeline UUT(rst,clk,A1,A2,A3,A4,A5,A6,A7,A8,A9, 
	     B1,B2,B3,B4,B5,B6,B7,B8,B9,C, rnd,result);

  always #5 clk = ~clk;
  initial
  begin
    rst = 0;
    clk = 1;
    #5 rst = 1;
    #100000 $stop;
  end

  integer fd;
  initial begin
    rnd=2'b01;
	fd=$fopen("../data/data.txt", "r");//   //fd=$fopen("testInputs.txt", "r");
    //op=0;
  end
  integer i;
  
  always @ * begin
    while(!$feof(fd)) begin
      $fscanf(fd, "%x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x", A1,A2,A3,A4,A5,A6,A7,A8,A9,B1,B2,B3,B4,B5,B6,B7,B8,B9,C, x_ideal);
     idealExp=x_ideal[30:23];
     x_man={1'b1,x_ideal[22:0]};
      #50;
    $display("A1=%x, B1=%x, C=%x, X=%x\n", A1, B1, C, x_ideal);
   end

  end
 
 //wire sig_compare = (UUT.renormalized!=x_man);
assign res_compare = result!=x_ideal;
//initial
//  # 5 $stop;

  
endmodule
