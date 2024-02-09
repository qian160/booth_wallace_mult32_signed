// carry-save adder: a + b + cin = t + carry
module csa (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    output [15:0] d,
    output [15:0] e
);
	assign d = a ^ b ^ c;
    assign e = ((a & b) | (a & c) | (b & c)) << 1;
endmodule