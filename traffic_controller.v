`timescale 1ns / 1ps


module traffic_controller (
    input  wire clk,
    input  wire rst_n,
    input  wire amb_ns,   // ambulance on North-South road
    input  wire amb_ew,   // ambulance on East-West road
    output reg  ns_red,
    output reg  ns_yellow,
    output reg  ns_green,
    output reg  ew_red,
    output reg  ew_yellow,
    output reg  ew_green
);

    // State encoding
    localparam NS_GREEN     = 3'd0;
    localparam NS_YELLOW    = 3'd1;
    localparam EW_GREEN     = 3'd2;
    localparam EW_YELLOW    = 3'd3;
    localparam NS_AMBULANCE = 3'd4;
    localparam EW_AMBULANCE = 3'd5;

    // Timing parameters (in clock cycles)
    localparam GREEN_TIME = 8'd10;
    localparam YELLOW_TIME = 8'd4;
    localparam AMB_TIME = 8'd15;

    reg [2:0] state;
    reg [7:0] cnt;   // simple counter for timing

    // State & counter update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= NS_GREEN;
            cnt   <= 8'd0;
        end else begin
            // Ambulance has highest priority
            if (amb_ns && state != NS_AMBULANCE) begin
                state <= NS_AMBULANCE;
                cnt   <= 8'd0;
            end else if (amb_ew && state != EW_AMBULANCE) begin
                state <= EW_AMBULANCE;
                cnt   <= 8'd0;
            end else begin
                // Normal timing-based transitions
                cnt <= cnt + 1'b1;
                case (state)
                    NS_GREEN: begin
                        if (cnt >= GREEN_TIME - 1) begin
                            state <= NS_YELLOW;
                            cnt   <= 8'd0;
                        end
                    end

                    NS_YELLOW: begin
                        if (cnt >= YELLOW_TIME - 1) begin
                            state <= EW_GREEN;
                            cnt   <= 8'd0;
                        end
                    end

                    EW_GREEN: begin
                        if (cnt >= GREEN_TIME - 1) begin
                            state <= EW_YELLOW;
                            cnt   <= 8'd0;
                        end
                    end

                    EW_YELLOW: begin
                        if (cnt >= YELLOW_TIME - 1) begin
                            state <= NS_GREEN;
                            cnt   <= 8'd0;
                        end
                    end

                    NS_AMBULANCE: begin
                        if (cnt >= AMB_TIME - 1) begin
                            state <= EW_GREEN;  // after NS ambulance, give EW chance
                            cnt   <= 8'd0;
                        end
                    end

                    EW_AMBULANCE: begin
                        if (cnt >= AMB_TIME - 1) begin
                            state <= NS_GREEN;  // after EW ambulance, go back to NS
                            cnt   <= 8'd0;
                        end
                    end

                    default: begin
                        state <= NS_GREEN;
                        cnt   <= 8'd0;
                    end
                endcase
            end
        end
    end

    // Output logic based on state
    always @(*) begin
        // default: all red
        ns_red    = 1'b1;
        ns_yellow = 1'b0;
        ns_green  = 1'b0;
        ew_red    = 1'b1;
        ew_yellow = 1'b0;
        ew_green  = 1'b0;

        case (state)
            NS_GREEN: begin
                ns_red   = 1'b0;
                ns_green = 1'b1;
                ew_red   = 1'b1;
            end

            NS_YELLOW: begin
                ns_red    = 1'b0;
                ns_yellow = 1'b1;
                ew_red    = 1'b1;
            end

            EW_GREEN: begin
                ew_red   = 1'b0;
                ew_green = 1'b1;
                ns_red   = 1'b1;
            end

            EW_YELLOW: begin
                ew_red    = 1'b0;
                ew_yellow = 1'b1;
                ns_red    = 1'b1;
            end

            NS_AMBULANCE: begin
                ns_red   = 1'b0;
                ns_green = 1'b1; // NS free, EW blocked
                ew_red   = 1'b1;
            end

            EW_AMBULANCE: begin
                ew_red   = 1'b0;
                ew_green = 1'b1; // EW free, NS blocked
                ns_red   = 1'b1;
            end
        endcase
    end

endmodule
