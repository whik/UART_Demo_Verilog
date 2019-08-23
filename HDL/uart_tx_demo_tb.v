
`timescale 1ns/100ps

module uart_tx_demo_tb;

parameter SYSCLK_PERIOD = 62.5;// 16MHZ

reg SYSCLK;
reg NSYSRESET;

initial
begin
    SYSCLK = 1'b0;
    NSYSRESET = 1'b0;
end

initial
begin
    #(SYSCLK_PERIOD * 10 )
        NSYSRESET = 1'b1;
end

always @(SYSCLK)
    #(SYSCLK_PERIOD / 2.0) SYSCLK <= !SYSCLK;

uart_tx_demo uart_tx_ctrl_0 (
    // Inputs
    .clk(SYSCLK),
    .rst_n(NSYSRESET),

    // Outputs
    .led(led ),
    .idle( idle),
    .tx( tx)

);

endmodule

