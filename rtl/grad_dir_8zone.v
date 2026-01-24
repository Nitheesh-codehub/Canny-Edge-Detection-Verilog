`timescale 1ns / 1ps
module grad_dir_8zone (
    input  wire        clk,
    input  wire        rst,
    input  wire        valid_in,
    input  wire signed [10:0] fx,
    input  wire signed [10:0] fy,
    input  wire        quadrant_flag,

    output reg         valid_out,
    output reg  [3:0]  zone
);
    wire [10:0] ax = fx[10] ? -fx : fx;
    wire [10:0] ay = fy[10] ? -fy : fy;

    wire [15:0] ax_e = {5'b0, ax};
    wire [15:0] ay_e = {5'b0, ay};

    wire [15:0] tan22 = (ax_e>>2)+(ax_e>>3)+(ax_e>>5)+(ax_e>>7);
    wire [15:0] tan45 = ax_e;
    wire [15:0] tan67 = ax_e + tan22;

    reg [3:0] q1;

    always @* begin
        if (ay_e < tan22)      q1 = 4'd1;
        else if (ay_e < tan45) q1 = 4'd2;
        else if (ay_e < tan67) q1 = 4'd3;
        else                   q1 = 4'd4;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            valid_out <= 0; zone <= 0;
        end else begin
            valid_out <= valid_in;
            if (valid_in) begin
                if (!quadrant_flag)
                    zone <= q1;
                else
                    case (q1)
                        4'd1: zone <= 4'd8;
                        4'd2: zone <= 4'd7;
                        4'd3: zone <= 4'd6;
                        default: zone <= 4'd5;
                    endcase
            end
        end
    end
endmodule
