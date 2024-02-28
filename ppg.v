// partial product generate
module #(shamt) ppg(
    input  reg  [2:0]       weight,
    input  reg  [33:0]      in,
    input  reg  [33:0]      neg_in;
    output reg  [63:0]      pp          // partial product
);
    reg  [33:0] temp;
    always @*   begin
        case (weight)
            // -2
            3'b110: temp = neg_in << 1;
            // -1
            3'b111: temp = neg_in;
            // 0
            3'b000: temp = 0;
            // 1
            3'b001: temp = in;
            // 2
            3'b010: temp = in << 1;
            default:
                temp = 114514;      // should not happen
        endcase
    end
    assign pp = {{30{temp[33]}}, temp} << shamt;       // sext 34 -> 64
endmodule