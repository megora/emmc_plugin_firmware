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
