// carry-save adder: a + b + c = d + e
module csa (
    input   [63:0]  a,
    input   [63:0]  b,
    input   [63:0]  c,
    output  [63:0]  d,
    output  [63:0]  e
);
	assign d = a ^ b ^ c;
    assign e = ((a & b) | (a & c) | (b & c)) << 1;
endmodule

// a + b + c + d = e + f
/*  a   b   c   d
    |   |   |   |
    ---------   |
    |  csa0 |   |
    ---------   |
      |   |    |
    -------------
    |   csa1    |
    -------------
        |   |
        e   f
*/
module compressor42(
    input   [63:0]  a,
    input   [63:0]  b,
    input   [63:0]  c,
    input   [63:0]  d,
    output  [63:0]  e,
    output  [63:0]  f
);
    csa csa0(
        .a(a),
        .b(b),
        .c(c)
    );

    csa csa1(
        .a(csa0.d),
        .b(csa0.e),
        .c(d)
    );

    assign e = csa1.d;
    assign f = csa1.e;

endmodule