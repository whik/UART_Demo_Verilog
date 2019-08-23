`timescale 1ns / 1ps


module my_uart_rx_tb;

	// Inputs
	reg clk;
	reg rx;
    reg rst_n;
    
	// Outputs
	wire [7:0] dataout;
	wire rx_ok;
	wire err_check;
	wire err_frame;

	// Instantiate the Unit Under Test (UUT)
	my_uart_rx uut (
		.clk(clk), 
		.rx(rx), 
        .rst_n(rst_n),
		.dataout(dataout), 
		.rx_ok(rx_ok), 
		.err_check(err_check), 
		.err_frame(err_frame)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rx = 1;
        rst_n = 0;
		// Wait 100 ns for global reset to finish
		#1225;
        rst_n = 1;
        rx = 1;
        #800;
        rx = 0;     //起始位
        #800
        rx = 1;     //LSB
        #800
        rx = 1;
        #800
        rx = 0;
        #800;
        rx = 0;
        #800
        rx = 1;
        #800
        rx = 0;
        #800
        rx = 0;
        #800
        rx = 1; //MSB
        #800
        rx = 0; //校验位
        #800
        rx = 1; //停止位
		// Add stimulus here
        // #800;
        // rx = 0;
        #800
        rx = 1;
        #800
        rx = 1;
        #800
        rx = 1;
        #800
        rx = 0;     //起始位
        #800
        rx = 0;     //LSB
        #800;
        rx = 1;
        #800
        rx = 1;
        #800
        rx = 1;
        #800
        rx = 0;
        #800
        rx = 0;
        #800
        rx = 0;
        #800
        rx = 1;     //MSB
        #800
        rx = 0;     //校验位
        #800
        rx = 1;     //停止位
	end
    
    always #(50/2) clk = ~clk; 
    
      
endmodule

