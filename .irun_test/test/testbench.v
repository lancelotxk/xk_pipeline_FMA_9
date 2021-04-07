
module testbench();
reg        rst_b;
reg        clk;
reg [3:0]  a,b;
reg        cin;
wire       cout;
wire [3:0] sout;

sync_adder4 adder4_inst(
                  .rst_b(rst_b),
                  .clk(clk),
                  .cin(cin),
                  .x(a),
                  .y(b),
                  .s(sout),
                  .cout(cout)
                  );

initial begin
rst_b = 0;
clk   = 0;
forever #10 clk = ~clk;
end

initial begin
cin = 0;
a   = 0;
b   = 0;

#50;
cin = 1;
a   = 4;
b   = 9;
#25;
rst_b = 1;

#50;
cin = 1;
a   = 7;
b   = 12;

#100 $finish;
end

initial begin
  $shm_open("wave.shm");
  $shm_probe(testbench,"AS");
end

endmodule
