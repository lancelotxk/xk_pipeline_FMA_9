//////////////
module sync_adder4(rst_b, clk, cin, x, y, s, cout);
  input        rst_b;
  input        clk;
  input        cin;
  input  [3:0] x;
  input  [3:0] y;
  output [3:0] s;
  output       cout;

  reg    [3:0] s;
  reg          cout;

  always@(posedge clk or negedge rst_b)
  begin
  if(!rst_b) {cout,s[3:0]} <= 5'b00000;
  else       {cout,s[3:0]} <= x[3:0] + y[3:0] + cin;
  end
endmodule
