module seven_segment (
    input [4:0] in,
    output [6:0] seg
)

reg [6:0] seg_out;

always @(*) begin
    case (in)
    5'd1:  seg_out = 7'b1111101; // A
    5'd2:  seg_out = 7'b0011111; // B
    5'd3:  seg_out = 7'b0001101; // C
    5'd4:  seg_out = 7'b0111101; // D
    5'd5:  seg_out = 7'b1001111; // E
    5'd6:  seg_out = 7'b1000111; // F
    5'd7:  seg_out = 7'b1011110; // G
    5'd8:  seg_out = 7'b0010111; // H
    5'd9:  seg_out = 7'b1110000; // I (?)
    5'd10:  seg_out = 7'b1111000; // J
    5'd11: seg_out = 7'b1010111; // K (?)
    5'd12: seg_out = 7'b0001110; // L
    5'd13: seg_out = 7'b1010101; // M (?)
    5'd14: seg_out = 7'b0010101; // N
    5'd15: seg_out = 7'b0011101; // O
    5'd16: seg_out = 7'b1100111; // P
    5'd17: seg_out = 7'b1110011; // Q
    5'd18: seg_out = 7'b0000101; // R
    5'd19: seg_out = 7'b1011011; // S
    5'd20: seg_out = 7'b0001111; // T
    5'd21: seg_out = 7'b0011100; // U
    5'd22: seg_out = 7'b0111110; // V (?)
    5'd23: seg_out = 7'b0111011; // W (?)
    5'd24: seg_out = 7'b0110110; // X (?)
    5'd25: seg_out = 7'b0111011; // Y
    5'd26: seg_out = 7'b1101100; // Z (?)
    default: seg_out = 7'b0000000; // 27-31 blank
    endcase
end

assign seg = ~seg_out;

endmodule