`include "timescale.v"

module crc7(
    input            clk_100_i,
    input            nrst_i,
    input    [119:0] dat_i,
    input            dat_valid_i,
    input            sh_dat_i, // protected data length (1 - 40-bit, 0 - 120-bit)
    output reg [6:0] crc_o,
    output reg       crc_valid_o
    );

    localparam [6:0] init = 7'h0;

    reg   [6:0] crc;
    reg [118:0] dat_reg;
    reg   [6:0] cnt;

    always @(posedge clk_100_i) begin
        if (!nrst_i)
            crc <= init;
        else if (dat_valid_i)
            crc <= {crc[5:0],dat_i[119]}^{5'b0,{3'b0,crc[6],2'b0,crc[6]};
        else
            crc <= {crc[5:0],dat_reg[118]}^{5'b0,{3'b0,crc[6],2'b0,crc[6]};
    end

    always @(posedge clk_100_i) begin
        if (!nrst_i) dat_reg <= 16'b0;
        else dat_reg <= (dat_valid_i) ? dat_i[118:0] : (dat_reg << 1);
    end

    always @(posedge clk_100_i) begin
        if      (!nrst_i)     cnt <= 7'd0;
        else if (dat_valid_i) cnt <= (sh_dat_i) ? 7'd46 : 7'd126;
        else if (cnt != 5'd0) cnt <= cnt - 1;
    end

    always @(posedge clk_100_i)
        crc_valid_o <= (cnt == 5'd1) ? 1'b1 : 1'b0;

    assign crc_o = crc;

endmodule
