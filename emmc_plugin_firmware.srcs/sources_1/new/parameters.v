// ----------------------------------------------------------------------------
//  parameters.v
//  Global parameters
//  Version 0.1
//
//  Copyright (C) 2020 M.Gorchichko
//
//  This program is free software: you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation, either version
//  3 of the License, or (at your option) any later version.
// ----------------------------------------------------------------------------

// simulation flag
localparam SIMULATION = 1'b1;

// ----- e.MMC bus clock modes ------------------------------------------------
localparam [2:0] CLK_OFF_MODE = 3'b000; // clocking is off
localparam [2:0] CLK_400_MODE = 3'b001; // ~  0.4 MHz
localparam [2:0]  CLK_26_MODE = 3'b010; // ~ 26   MHz
localparam [2:0] CLK_200_MODE = 3'b100; // ~200   MHz