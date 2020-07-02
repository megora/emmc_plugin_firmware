// ----------------------------------------------------------------------------
//  emmc_plugin_firmware.v
//  eMMC plugin firmware top module
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

module emmc_plugin_firmware(
    input gclk
    );

    wire clk_locked, clk_100, clk_200;

    clock_generator clock_generator_inst(
        .clk_100(clk_100),
        .clk_200(clk_200),
        .locked (clk_locked),
        .gclk   (gclk)
        );

    wire nrst;
    
    reset_generator reset_generator_inst(
        .clk_100_i(clk_100),
        .locked_i (clk_locked),
        .nrst_o   (nrst)
        );

    emmc_host emmc_host_inst(
        .clk_100_i(clk_100),
        .clk_200_i(clk_200),
        .nrst_i(nrst),
        // e.MMC protocol host to devices lines
        .emmc_clk_o(),
        .emmc_rst_o(),
        .emmc_cmd_o(),
        .emmc_wr_dat_o(),
        // e.MMC protocol device to host lines
        .emmc_cmd_resp_i(),
        .emmc_rd_dat_i(),
        .emmc_ds_i(),
        );

    

    
endmodule