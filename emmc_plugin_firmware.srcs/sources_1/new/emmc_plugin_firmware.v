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