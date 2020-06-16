`include "timescale.v"
`include "parameters.v"

module host_core(
    input        clk_100_i,
    input        nrst_i,

    output reg [37:0] cmd_o,
    output reg        cmd_strb_o,
    // emmc clock modes handling
    output reg  [2:0] clk_mode_o,



    input [31:0] cmd_resp_i,
    input        cmd_resp_valid_i

    );

    // ----- parameters, regs, and wires --------------------------------------
    localparam STATE_SIZE = 4; // state vector length

    // states list
    localparam [STATE_SIZE-1:0] RST_ST      = 0; // reset state
    localparam [STATE_SIZE-1:0] SET_400_CLK = 1; // start clocking emmc device with 400 kHz clock
    localparam [STATE_SIZE-1:0] SEND_CMD1   = 2; // send CMD and wait for the response
    localparam [STATE_SIZE-1:0] SEND_CMD2   = 3; // send CMD and wait for the response
    localparam [STATE_SIZE-1:0] SEND_CMD3   = 4; // send CMD and wait for the response

    reg  [STATE_SIZE-1:0] state, next_state;

    reg  [5:0] cmd_index;
    reg [31:0] cmd_arg;

    localparam CNT_LEN = 9;
    reg [CNT_LEN-1:0] cnt;
    // reg cnt_ld_flag; // flag to load value to the counter

    // ----- FSM --------------------------------------------------------------
    always @(posedge clk_100_i) begin
        if (!nrst_i) state <= RST_ST;
        else         state <= next_state;
    end

    always @* begin
        case (state)
            RST_ST:
                next_state = SET_400_CLK;
            SET_400_CLK:
                next_state = (cnt == 0) ? SEND_CMD1 : SET_400_CLK;
            SEND_CMD1:
                next_state = RST_ST; // stub
            default:
                next_state = RST_ST; // idle?
        endcase
    end

    // ----- cmd processing ---------------------------------------------------
    always @* begin
        case (next_state)
            RST_ST:      {cmd_index, cmd_arg} = {6'b0, 32'h0};
            SET_400_CLK: {cmd_index, cmd_arg} = {6'b0, 32'h0};
            SEND_CMD1:   {cmd_index, cmd_arg} = {6'b1, 32'hC0FF_8080};
            default:     {cmd_index, cmd_arg} = {6'b0, 32'h0};
        endcase
    end

    always @(posedge clk_100_i)
        cmd_o <= {cmd_index, cmd_arg};

    always @(posedge clk_100_i) begin
        if (!nrst_i)
            cmd_strb_o <= 1'b0;
        else
            // add checking if the next state is not RST!
            cmd_strb_o <= (state != next_state) ? 1'b1 : 1'b0;
    end   

    // ----- counter ----------------------------------------------------------
    always @(posedge clk_100_i) begin
        if (!nrst_i) cnt <= 474;
        else if (cnt != 0) cnt <= cnt - 1'b1;
    end

    // ----- e.MMC bus clock mode handling ------------------------------------
    // localparam [2:0] CLK_OFF_MODE = 3'b000; // clocking is off
    // localparam [2:0] CLK_400_MODE = 3'b001; // ~  0.4 MHz
    // localparam [2:0]  CLK_26_MODE = 3'b010; // ~ 26   MHz
    // localparam [2:0] CLK_200_MODE = 3'b100; // ~200   MHz

    always @(posedge clk_100_i) begin
        if (!nrst_i) clk_mode_o <= CLK_OFF_MODE;
        else begin
            case (next_state)
                RST_ST:      clk_mode_o <= CLK_OFF_MODE;
                SET_400_CLK: clk_mode_o <= CLK_400_MODE;
                default:     clk_mode_o <= CLK_OFF_MODE;
            endcase
        end
    end  


endmodule
