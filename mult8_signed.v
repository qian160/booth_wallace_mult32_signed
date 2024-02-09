module mult8_signed(
    input [7:0] a,
    input [7:0] b,
    output [15:0] result
);
    booth2_encoder b0(
        .in({a[1:0], 1'b0}),
    );

    booth2_encoder b1(
        .in(a[3:1]),
    );

    booth2_encoder b2(
        .in(a[5:3]),
    );

    booth2_encoder b3(
        .in(a[7:5]),
    );

    ppg8 p0(
        .weight(b0.weight),
        .in(b),
    );

    ppg8 p1(
        .weight(b1.weight),
        .in(b),
    );
    ppg8 p2(
        .weight(b2.weight),
        .in(b),
    );
    ppg8 p3(
        .weight(b3.weight),
        .in(b),
    );

    csa #(8) csa0(
        .a(p1.pp << 2),
        .b(p2.pp << 4),
        .c(p3.pp << 6),
    );

    csa #(8) csa1(
        .a(p0.pp),
        .b(csa0.d),
        .c(csa0.e),
    );

    assign result = csa1.d + csa1.e;
endmodule

module mult8_signed_tb ();
    // mult tb
    reg signed [7:0] a, b;
    reg signed [15:0] c;
    wire signed [15:0] s = a * b;
    mult8_signed m8(
        .a(a),
        .b(b),
        .result(c)
    );

    always @(posedge clock) begin
        a <= $random() % 256;
        b <= $random() % 256;
        $display("%d x %d = %d", a, b, c);
        if (c != s)   begin
            $display("%d * %d: expected %d, but got %d", a, b, s, c);
        end
    end
endmodule