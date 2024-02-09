// partial product generate
module ppg8(
    input  reg  [2:0]       weight,
    input  reg  [7:0]       in,
    output reg  [15:0]      pp      // partial product
);
    wire [9:0] sext = {{2{in[7]}}, in};     // sext 8 -> 10
    reg  [9:0] temp;
    always @*   begin
        case (weight)
            // -2
            3'b110: temp = (~sext + 1) << 1;
            // -1
            3'b111: temp = ~sext + 1;
            // 0
            3'b000: temp = 0;
            // 1
            3'b001: temp = sext;
            // 2
            3'b010: temp = sext << 1;
            default:
                temp = 114514;     // should not happen
        endcase
    end
    assign pp = {{6{temp[9]}}, temp};       // sext 10 -> 16
endmodule