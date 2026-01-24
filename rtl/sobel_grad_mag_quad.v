`timescale 1ns / 1ps

module sobel_grad_mag_quad (
    input  wire        clk,
    input  wire        rst,
    input  wire        valid_in,

    input  wire [7:0]  p0,p1,p2,
    input  wire [7:0]  p3,p4,p5,
    input  wire [7:0]  p6,p7,p8,

    output reg         valid_out,
    output reg signed [10:0] fx,
    output reg signed [10:0] fy,
    output reg  [11:0] mag,
    output reg         quadrant_flag
);
    wire signed [10:0] sx0=p0, sx1=p1, sx2=p2,
                       sx3=p3, sx5=p5,
                       sx6=p6, sx7=p7, sx8=p8;

    wire signed [10:0] fx_c =
          (sx2 - sx0) + ((sx5 - sx3) <<< 1) + (sx8 - sx6);

    wire signed [10:0] fy_c =
          (sx6 - sx0) + ((sx7 - sx1) <<< 1) + (sx8 - sx2);

    wire [10:0] abs_fx = fx_c[10] ? -fx_c : fx_c;
    wire [10:0] abs_fy = fy_c[10] ? -fy_c : fy_c;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            valid_out <= 0;
            fx <= 0; fy <= 0; mag <= 0; quadrant_flag <= 0;
        end else begin
            valid_out <= valid_in;
            if (valid_in) begin
                fx <= fx_c;
                fy <= fy_c;
                mag <= abs_fx + abs_fy;
                quadrant_flag <= fx_c[10] ^ fy_c[10];
            end
        end
    end
endmodule
