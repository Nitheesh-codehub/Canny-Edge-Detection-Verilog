`timescale 1ns/1ps
module tb_canny;

    parameter IMG_W = 256;
    parameter IMG_H = 256;
    parameter PIXELS = IMG_W*IMG_H;

    reg clk = 0, rst = 1;
    reg [7:0] pixel_in;

    wire        out_valid;
    wire [7:0]  pixel_out;

    reg [7:0] img [0:PIXELS-1];
    integer i, fout, count;

    // --------------------------------------------------
    // DUT
    // --------------------------------------------------
    canny_top dut (
        .clk(clk),
        .rst(rst),
        .pixel_in(pixel_in),
        .out_valid(out_valid),
        .pixel_out(pixel_out)
    );

    // --------------------------------------------------
    // Clock
    // --------------------------------------------------
    always #5 clk = ~clk;

    // --------------------------------------------------
    // Stimulus
    // --------------------------------------------------
    initial begin
        $readmemh("image.hex", img);
        fout = $fopen("canny_output20.hex", "w");
        count = 0;

        #50 rst = 0;

        for (i = 0; i < PIXELS; i = i + 1) begin
            @(posedge clk);
            pixel_in <= img[i];
        end

        repeat(2000) @(posedge clk);

        $display("Pixels written = %0d", count);
        $fclose(fout);
        $finish;
    end

    // --------------------------------------------------
    // Capture OUTPUT (FINAL IMAGE)
    // --------------------------------------------------
    always @(posedge clk) begin
        if (!rst && count < PIXELS) begin
            if (out_valid)
                $fwrite(fout, "%02x\n", pixel_out);
            else
                $fwrite(fout, "00\n");
            count = count + 1;
        end
    end

endmodule
