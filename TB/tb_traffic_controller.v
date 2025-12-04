`timescale 1ns/1ps

module tb_traffic_controller;

    reg clk;
    reg rst_n;
    reg amb_ns;
    reg amb_ew;

    wire ns_red, ns_yellow, ns_green;
    wire ew_red, ew_yellow, ew_green;

    // Instantiate DUT
    traffic_controller dut (
        .clk(clk),
        .rst_n(rst_n),
        .amb_ns(amb_ns),
        .amb_ew(amb_ew),
        .ns_red(ns_red),
        .ns_yellow(ns_yellow),
        .ns_green(ns_green),
        .ew_red(ew_red),
        .ew_yellow(ew_yellow),
        .ew_green(ew_green)
    );

    // Clock generation: 10 ns period
    always begin
        #5 clk = ~clk;
    end

    initial begin
        // Initialize
        clk    = 0;
        rst_n  = 0;
        amb_ns = 0;
        amb_ew = 0;

        // Release reset
        #20;
        rst_n = 1;

        // Let normal cycle run for some time
        #200;

        // Trigger ambulance on NS
        amb_ns = 1;
        #30;
        amb_ns = 0;

        // Wait and observe
        #300;

        // Trigger ambulance on EW
        amb_ew = 1;
        #30;
        amb_ew = 0;

        // Run a bit more
        #400;

        $finish;
    end

endmodule
