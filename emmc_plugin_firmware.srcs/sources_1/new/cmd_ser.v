// ----------------------------------------------------------------------------
//  cmd_ser.v
//  Command Serializer
//  Version 0.1
//
//  Copyright (C) 2020 M.Gorchichko
//
//  This program is free software: you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation, either version
//  3 of the License, or (at your option) any later version.
// ----------------------------------------------------------------------------

`include "timescale.v"

module cmd_ser(
    // common signals
    input        clk_100_i,
    input        clk_200_i,
    input        nrst_i,
    // 
    input [37:0] cmd_i,
    input        cmd_strb_i,
    input  [2:0] clk_mode_i,

    output       emmc_clk_o,
    output       emmc_cmd_o
    );

    `include "parameters.v"

    reg  [7:0] cnt;
    wire low_freq_clk;
    reg  [2:0] clk_mode_reg;
    wire [7:0] cnt_clk_re; // Counter value assosiated with the low frequency clock rising edge

    reg  [5:0] cmd_index;
    reg [31:0] cmd_arg;

    // latching an input command
    always @(posedge clk_100_i) begin
        if (cmd_strb_i) begin
            cmd_index <= cmd_i[37:32];
            cmd_arg   <= cmd_i[31:0];
        end
    end

    // ----- managing e.MMC bus clocking --------------------------------------
    always @(posedge clk_100_i)
        if (cnt == 0) clk_mode_reg <= clk_mode_i;

    // low frequency (400 kHz or 25 MHz) clock gen
    always @(posedge clk_100_i) begin
        if (!nrst_i) cnt <= 0;
        else
            begin
                if (cnt == 0)
                    if (clk_mode_i == CLK_400_MODE)
                        cnt <= 8'd249;
                    else if (clk_mode_i == CLK_26_MODE)
                        cnt <= 8'd3;
                else
                    cnt <= cnt - 1'b1;
            end
    end

    always @* begin
        case (clk_mode_reg)
            CLK_400_MODE: cnt_clk_re = 8'd125; // CLK_400_MODE -> count 249...0
            CLK_26_MODE:  cnt_clk_re = 8'd2;   // CLK_26_MODE  -> count 3...0
            default:      cnt_clk_re = 8'd255; // ureachable value to make full case
        endcase
    end

    always @(posedge clk_100_i) begin
        if (!nrst_i)
            low_freq_clk <= 0;
        else
            begin
                if      (cnt == 0)          low_freq_clk <= 0;
                else if (cnt == cnt_clk_re) low_freq_clk <= 1;
            end
    end

    BUFGMUX #(.CLK_SEL_TYPE("SYNC")) BUFGMUX_inst (
        .O(emmc_clk_o),   // 1-bit output: Clock output
        .I0(low_freq_clk), // 1-bit input: Clock input (S=0)
        .I1(clk_200_i), // 1-bit input: Clock input (S=1)
        .S(0)    // 1-bit input: Clock select
        );

    // 


endmodule
