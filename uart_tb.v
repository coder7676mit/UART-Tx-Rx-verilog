`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2026 12:18:01
// Design Name: 
// Module Name: uart_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module uart_tb;

reg clk;
reg reset;

reg [7:0] data_in;
reg Tx_en;
reg Rx_en;

reg ready_clr;

wire Tx;
wire Tx_busy;
wire ready;

wire [7:0] data_out;

wire [7:0] LEDR;

wire [6:0] seg_hundreds;
wire [6:0] seg_tens;
wire [6:0] seg_units;

wire Rx;

/* Loopback connection */
assign Rx = Tx;


/* Instantiate DUT */

uart DUT(

    .clk_50m(clk),
    .reset(reset),

    .data_in(data_in),
    .Tx_en(Tx_en),
    .Rx_en(Rx_en),
    .Rx(Rx),

    .ready_clr(ready_clr),

    .Tx(Tx),
    .Tx_busy(Tx_busy),
    .ready(ready),

    .data_out(data_out),

    .LEDR(LEDR),

    .seg_hundreds(seg_hundreds),
    .seg_tens(seg_tens),
    .seg_units(seg_units)

);


/////////////////////////////////////////////////////////
// CLOCK GENERATION (50 MHz)
/////////////////////////////////////////////////////////

always #10 clk = ~clk;   // 20ns period


/////////////////////////////////////////////////////////
// TEST SEQUENCE
/////////////////////////////////////////////////////////

initial begin

    clk = 0;
    reset = 1;

    Tx_en = 0;
    Rx_en = 1;

    ready_clr = 0;

    data_in = 8'd0;

    /* reset period */
    repeat(10) @(posedge clk);

    reset = 0;

    repeat(10) @(posedge clk);

    /////////////////////////////////////////////////////
    // TRANSMIT BYTE
    /////////////////////////////////////////////////////

    data_in = 8'd123;

    $display("Sending Data = %d", data_in);

    @(posedge clk);
    Tx_en = 1;

    repeat(5) @(posedge clk);

    Tx_en = 0;

    /////////////////////////////////////////////////////
    // WAIT FOR RECEIVE
    /////////////////////////////////////////////////////

    wait(ready == 1);

    $display("Received Data = %d", data_out);

    if(data_out == 8'd123)
        $display("UART TEST PASSED");
    else
        $display("UART TEST FAILED");

    /////////////////////////////////////////////////////
    // CLEAR READY FLAG
    /////////////////////////////////////////////////////

    @(posedge clk);
    ready_clr = 1;

    @(posedge clk);
    ready_clr = 0;

    /////////////////////////////////////////////////////
    // END SIMULATION
    /////////////////////////////////////////////////////

    #200000;   // run long enough for UART frame

    $finish;

end

endmodule