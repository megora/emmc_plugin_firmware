// ----------------------------------------------------------------------------
//  reset_generator.v
//  Reset Generator module
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

module reset_generator(
    input  clk_100_i,
    input  locked_i,
    output nrst_o
    );

    reg [7:0] locked_sreg;

    always @(negedge clk_100_i) begin
        locked_sreg <= {locked_i, locked_sreg[7:1]};
        nrst_o <= &locked_sreg[3:0];
    end

endmodule
