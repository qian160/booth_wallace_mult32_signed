module booth2_encoder(
    input  reg [2:0]    in,
    output reg [2:0]    weight
);
    always @(*) begin
        case (in)
            3'b000: weight = 0;      // no string of 1's
            3'b001: weight = 1;      // end of string of 1's
            3'b010: weight = 1;      // a string og 1's
            3'b011: weight = 2;      // end of string of 1's
            3'b100: weight = -2;     // begining of string of 1's
            3'b101: weight = -1;     // -2 + 1
            3'b110: weight = -1;     // beginning of string of 1's
            3'b111: weight = 0;      // center of string of 1's
        endcase
    end
endmodule