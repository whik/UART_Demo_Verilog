`timescale 1ns / 1ps

module uart_tx_8bit_tb;

	// Inputs
	reg clk;
	reg [7:0] data_in;
	reg trig;
    reg rst_n;
	// Outputs
	wire busy;
	wire tx;

	uart_tx_8bit uut (
        
        //input
		.clk(clk), 
		.data_in(data_in), 
        .rst_n(rst_n),
		.trig(trig), 
        
        //output
		.busy(busy), 
		.tx(tx)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		data_in = 0;
		trig = 0;
        rst_n = 0;
		// Wait 100 ns for global reset to finish
		#125;
        rst_n = 1;
        data_in = 8'h9a;        //1100 1010
        #200;
        trig = 1;
        #200
        trig = 0;
	end
    
    always #(50/2) clk = ~clk;
      
endmodule

