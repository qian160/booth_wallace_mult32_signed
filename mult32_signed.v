module mult32_signed(
    input  [31:0] a,
    input  [31:0] b,
    output [63:0] result
);
    wire [33:0] b_sext = {{2{b[31]}}, b};
    wire [33:0] neg_b = ~b_sext + 1;

    wire [2:0]  booth2_weight[0:15];
    wire [63:0] pp[0:15];
    // compress process
    // pp: 16 -> 8 -> 4 -> 2
    wire [63:0] pp_0[0:7];
    wire [63:0] pp_1[0:3];
    wire [63:0] pp_2[0:1];

    // apply booth encoding to 'a'. #encoder = 16
    // [1:-1]
    booth2_encoder b0(
        .in({a[1:0], 1'b0}),
        .weight(booth2_weight[0])
    );
    genvar i;
    generate
        // [1:-1] -> [3:1] -> [5:3] ...
        for (i = 1; i < 16; i = i + 1)  begin
            booth2_encoder b(
                .in(a[(2*i+1):(2*i-1)]),
                .weight(booth2_weight[i])
            );
        end
    endgenerate

    // partial product generate. #ppg = 16
    generate
        for (i = 0; i < 16; i = i + 1)  begin
            ppg #(2*i) b(
                .weight(booth2_weight[i]),
                .in(b_sext),
                .neg_in(neg_b),
                .pp(pp[i])
            );
        end
    endgenerate

    // compress
    // stage1: 16 -> 8. #compressor = 4
    generate
        for (i = 0; i < 4; i = i + 1)  begin
            compressor42 c(
                .a(pp[4*i]),
                .b(pp[4*i+1]),
                .c(pp[4*i+2]),
                .d(pp[4*i+3]),
                .e(pp_0[2*i]),
                .f(pp_0[2*i+1])
            );
        end
    endgenerate

    // stage2: 8 -> 4. #compressor = 2
    generate
        for (i = 0; i < 2; i = i + 1)  begin
            compressor42 c(
                .a(pp_0[4*i]),
                .b(pp_0[4*i+1]),
                .c(pp_0[4*i+2]),
                .d(pp_0[4*i+3]),
                .e(pp_1[2*i]),
                .f(pp_1[2*i+1])
            );
        end
    endgenerate

    // stage3: 4 -> 2. #compressor = 1
    generate
        for (i = 0; i < 1; i = i + 1)  begin
            compressor42 c(
                .a(pp_1[4*i]),
                .b(pp_1[4*i+1]),
                .c(pp_1[4*i+2]),
                .d(pp_1[4*i+3]),
                .e(pp_2[2*i]),
                .f(pp_2[2*i+1])
            );
        end
    endgenerate

    assign result = pp_2[0] + pp_2[1];
endmodule

module mult32_signed_tb ();
    // mult tb
    reg signed [31:0] a, b;
    reg signed [63:0] c;
    wire signed [63:0] s = a * b;
    mult32_signed m32(
        .a(a),
        .b(b),
        .result(c)
    );

    always @(posedge clock) begin
        a <= $random();
        b <= $random();
        $display("[pass] %d x %d = %d", a, b, c);
        if (c != s)   begin
            $display("%d * %d: expected %d, but got %d", a, b, s, c);
            $finish();
        end
    end
endmodule