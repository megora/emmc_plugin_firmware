// ----------------------------------------------------------------------------
//  emmc_host.v
//  eMMC host module
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

module emmc_host(
    input        clk_100_i,
    input        clk_200_i,
    input        nrst_i,
    // e.MMC protocol host to devices lines
    output       emmc_clk_o,
    output       emmc_rst_o,
    output       emmc_cmd_o,
    output [7:0] emmc_wr_dat_o,
    // e.MMC protocol device to host lines
    input        emmc_cmd_resp_i,
    input  [7:0] emmc_rd_dat_i,
    input        emmc_ds_i
);

    wire [37:0] cmd;
    wire        cmd_strb;
    wire  [2:0] clk_mode;

    host_core host_core_inst(
        .clk_100_i (clk_100_i),
        .nrst_i    (nrst_i),
        .cmd_o     (cmd),
        .cmd_strb_o(cmd_strb),
        .clk_mode_o(clk_mode)
        );

    cmd_ser cmd_ser_inst(
        .clk_100_i(clk_100_i),
        .clk_200_i(clk_200_i),
        .nrst_i(nrst_i),
        .cmd_i(cmd),
        .cmd_strb_i(cmd_strb),
        .clk_mode_i(clk_mode),
        .emmc_clk_o(emmc_clk_o),
        .emmc_cmd_o(emmc_cmd_o)
        );

endmodule
