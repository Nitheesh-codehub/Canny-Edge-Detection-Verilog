`timescale 1ns / 1ps

module canny_top #(
    parameter IMG_W = 256
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  pixel_in,

    output wire        out_valid,
    output wire [7:0]  pixel_out
);

    // --------------------------------------------------
    // 1. 3x3 Line Buffer for Sobel (RAW IMAGE)
    // --------------------------------------------------
    wire lb_valid;
    wire [7:0] p0,p1,p2,p3,p4,p5,p6,p7,p8;

    line_buffer_3x3 lb_img (
        .clk(clk),
        .rst(rst),
        .pixel_in(pixel_in),
        .p0(p0),.p1(p1),.p2(p2),
        .p3(p3),.p4(p4),.p5(p5),
        .p6(p6),.p7(p7),.p8(p8),
        .valid_out(lb_valid)
    );

    // --------------------------------------------------
    // 2. Sobel Gradient + Magnitude
    // --------------------------------------------------
    wire grad_valid;
    wire signed [10:0] fx, fy;
    wire [11:0] mag;
    wire quad;

    sobel_grad_mag_quad sobel (
        .clk(clk),
        .rst(rst),
        .valid_in(lb_valid),
        .p0(p0),.p1(p1),.p2(p2),
        .p3(p3),.p4(p4),.p5(p5),
        .p6(p6),.p7(p7),.p8(p8),
        .valid_out(grad_valid),
        .fx(fx),
        .fy(fy),
        .mag(mag),
        .quadrant_flag(quad)
    );

    // --------------------------------------------------
    // 3. Gradient Direction (8 zones)
    // --------------------------------------------------
    wire dir_valid;
    wire [3:0] dir;

    grad_dir_8zone dir8 (
        .clk(clk),
        .rst(rst),
        .valid_in(grad_valid),
        .fx(fx),
        .fy(fy),
        .quadrant_flag(quad),
        .valid_out(dir_valid),
        .zone(dir)
    );

    // --------------------------------------------------
    // 4. Line buffers for NMS
    // --------------------------------------------------
    wire mag_lb_valid, dir_lb_valid;
    wire [11:0] g0,g1,g2,g3,g4,g5,g6,g7,g8;
    wire [3:0]  d0,d1,d2,d3,d4,d5,d6,d7,d8;

    line_buffer_mag lbm (
        .clk(clk),
        .rst(rst),
        .pixel_in(mag),
        .g0(g0),.g1(g1),.g2(g2),
        .g3(g3),.g4(g4),.g5(g5),
        .g6(g6),.g7(g7),.g8(g8),
        .valid_out(mag_lb_valid)
    );

    line_buffer_dir lbd (
        .clk(clk),
        .rst(rst),
        .pixel_in(dir),
        .d0(d0),.d1(d1),.d2(d2),
        .d3(d3),.d4(d4),.d5(d5),
        .d6(d6),.d7(d7),.d8(d8),
        .valid_out(dir_lb_valid)
    );

    // --------------------------------------------------
    // 5. Non-Maximum Suppression
    // --------------------------------------------------
    wire nms_valid;
    wire [7:0] nms_out;

    nms_8dir nms (
        .clk(clk),
        .rst(rst),
        .valid_in(mag_lb_valid & dir_lb_valid),
        .g0(g0),.g1(g1),.g2(g2),
        .g3(g3),.g4(g4),.g5(g5),
        .g6(g6),.g7(g7),.g8(g8),
        .dir(d4),
        .valid_out(nms_valid),
        .nms_out(nms_out)
    );

    // --------------------------------------------------
    // 6. 3x3 Line Buffer AFTER NMS (for local mean)
    // --------------------------------------------------
    wire lb_nms_valid;
    wire [7:0] n0,n1,n2,n3,n4,n5,n6,n7,n8;

    line_buffer_3x3 lb_nms (
        .clk(clk),
        .rst(rst),
        .pixel_in(nms_out),
        .p0(n0),.p1(n1),.p2(n2),
        .p3(n3),.p4(n4),.p5(n5),
        .p6(n6),.p7(n7),.p8(n8),
        .valid_out(lb_nms_valid)
    );

    // --------------------------------------------------
    // 7. Local Mean + Double Threshold
    // --------------------------------------------------
    wire        thr_valid;
    wire [1:0]  edge_type;

    local_mean_threshold u_lmt (
        .clk(clk),
        .rst(rst),
        .in_valid(lb_nms_valid),
        .din(n4),          // center pixel
        .p0(n0),.p1(n1),.p2(n2),
        .p3(n3),.p4(n4),.p5(n5),
        .p6(n6),.p7(n7),.p8(n8),
        .out_valid(thr_valid),
        .edge_type(edge_type)
    );

    // --------------------------------------------------
    // 8. Hysteresis Tracker (connectivity)
    // --------------------------------------------------
    hysteresis_tracker #(
        .IMG_W(IMG_W)
    ) u_hyst (
        .clk(clk),
        .rst(rst),
        .in_valid(thr_valid),
        .edge_type(edge_type),
        .out_valid(out_valid),
        .dout(pixel_out)
    );

endmodule