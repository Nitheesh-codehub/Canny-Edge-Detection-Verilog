`timescale 1ns / 1ps

module hysteresis_tracker #(
    parameter IMG_W = 256
)(
    input  wire        clk,
    input  wire        rst,
    input  wire        in_valid,
    input  wire [1:0]  edge_type,

    output reg         out_valid,
    output reg  [7:0]  dout
);

    reg prev_row [0:IMG_W-1];
    reg [$clog2(IMG_W)-1:0] col;
    reg connected;
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            col <= 0;
            dout <= 0;
            out_valid <= 0;
            for (i=0;i<IMG_W;i=i+1)
                prev_row[i] <= 0;
        end else if (in_valid) begin
            connected <=
                ((col>0)        && dout==8'hFF) ||
                ((col>0)        && prev_row[col-1]) ||
                (                prev_row[col]) ||
                ((col<IMG_W-1) && prev_row[col+1]);

            if (edge_type==2'b10 || (edge_type==2'b01 && connected))
                dout <= 8'hFF;
            else
                dout <= 8'h00;

            prev_row[col] <=
                (edge_type==2'b10) ||
                (edge_type==2'b01 && connected);

            col <= (col==IMG_W-1) ? 0 : col+1;
            out_valid <= 1'b1;
        end else begin
            out_valid <= 0;
        end
    end
endmodule