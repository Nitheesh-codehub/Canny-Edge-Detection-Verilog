
`timescale 1ns/1ps

module nms_8dir #(
    parameter W = 12 
)(
    input  wire         clk,
    input  wire         rst,
    input  wire         valid_in,

    input  wire [W-1:0] g0, g1, g2,
    input  wire [W-1:0] g3, g4, g5,
    input  wire [W-1:0] g6, g7, g8,

    input  wire [3:0]   dir,

    output reg          valid_out,
    output reg  [7:0]   nms_out
);

    // ------------------------------------------------------------
    // Neighbor selection (strictly following Section 2.2.3)
    // ------------------------------------------------------------
    reg [W-1:0] a, b;

    always @(*) begin
        case (dir)
            4'd1, 4'd8: begin a = g3; b = g5; end   // Directions 1 or 8
            4'd2, 4'd3: begin a = g0; b = g8; end   // Directions 2 or 3
            4'd4, 4'd5: begin a = g5; b = g6; end   // Directions 4 or 5
            4'd6, 4'd7: begin a = g1; b = g7; end   // Directions 6 or 7
            default:    begin a = {W{1'b0}}; b = {W{1'b0}}; end
        endcase
    end

    // ------------------------------------------------------------
    // Comparator + clipping (Figure 9 CMP + limiter)
    // ------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            valid_out <= 1'b0;
            nms_out   <= 8'd0;
        end else begin
            valid_out <= valid_in;

            // Local maximum check
            if (valid_in && (g4 >= a) && (g4 >= b)) begin
                // 8-bit clipping (limit to 255)
                if (g4 > 12'd255)
                    nms_out <= 8'hFF;
                else
                    nms_out <= g4[7:0];
            end else begin
                nms_out <= 8'd0;
            end
        end
    end

endmodule