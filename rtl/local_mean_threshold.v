`timescale 1ns / 1ps

module local_mean_threshold (
    input  wire        clk,
    input  wire        rst,
    input  wire        in_valid,

    // center pixel (NMS)
    input  wire [7:0]  din,

    // 3x3 neighborhood from NMS
    input  wire [7:0]  p0,p1,p2,
    input  wire [7:0]  p3,p4,p5,
    input  wire [7:0]  p6,p7,p8,

    output reg         out_valid,
    output reg  [1:0]  edge_type   // 10=strong, 01=weak, 00=none
);

    // thresholds (you already tuned these)
    localparam [7:0] HIGH_TH = 8'd155;
    localparam [7:0] LOW_TH  = 8'd130;

    reg [11:0] mean;

    always @(posedge clk) begin
        if (rst) begin
            out_valid <= 0;
            edge_type <= 2'b00;
        end else if (in_valid) begin
            mean <= (p0+p1+p2+p3+p4+p5+p6+p7+p8) / 9;

            if (din >= HIGH_TH && din >= mean)
                edge_type <= 2'b10;   // strong
            else if (din >= LOW_TH && din >= mean)
                edge_type <= 2'b01;   // weak
            else
                edge_type <= 2'b00;

            out_valid <= 1'b1;
        end else begin
            out_valid <= 1'b0;
        end
    end

endmodule