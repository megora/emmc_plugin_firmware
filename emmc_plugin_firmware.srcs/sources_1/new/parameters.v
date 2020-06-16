// ----- e.MMC bus clock modes -------------------------------------------
localparam [2:0] CLK_OFF_MODE = 3'b000; // clocking is off
localparam [2:0] CLK_400_MODE = 3'b001; // ~  0.4 MHz
localparam [2:0]  CLK_26_MODE = 3'b010; // ~ 26   MHz
localparam [2:0] CLK_200_MODE = 3'b100; // ~200   MHz