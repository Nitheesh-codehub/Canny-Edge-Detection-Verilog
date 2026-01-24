`timescale 1ns / 1ps

module line_buffer_3x3 #(
    parameter IMG_W = 256
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  pixel_in,

    output reg  [7:0]  p0,p1,p2,
    output reg  [7:0]  p3,p4,p5,
    output reg  [7:0]  p6,p7,p8,
    output reg         valid_out
);

    reg [7:0] line1 [0:IMG_W-1];
    reg [7:0] line2 [0:IMG_W-1];
    reg [7:0] r0_0,r0_1,r0_2;
    reg [7:0] r1_0,r1_1,r1_2;
    reg [7:0] r2_0,r2_1,r2_2;
    reg [$clog2(IMG_W)-1:0] col;
    reg [15:0] row;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            col <= 0; row <= 0; valid_out <= 0;
            for (i=0;i<IMG_W;i=i+1) begin
                line1[i] <= 0; line2[i] <= 0;
            end
        end else begin
            r2_2 <= line2[col];
            r1_2 <= line1[col];
            r0_2 <= pixel_in;

            r2_1 <= r2_2; r2_0 <= r2_1;
            r1_1 <= r1_2; r1_0 <= r1_1;
            r0_1 <= r0_2; r0_0 <= r0_1;

            line2[col] <= line1[col];
            line1[col] <= pixel_in;

            if (col == IMG_W-1) begin
                col <= 0; row <= row + 1;
            end else col <= col + 1;

            {p0,p1,p2} <= {r2_0,r2_1,r2_2};
            {p3,p4,p5} <= {r1_0,r1_1,r1_2};
            {p6,p7,p8} <= {r0_0,r0_1,r0_2};

            valid_out <= (row >= 2 && col >= 2);
        end
    end
endmodule
