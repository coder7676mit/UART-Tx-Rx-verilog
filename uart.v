`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2026 12:16:48
// Design Name: 
// Module Name: uart
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


module uart(
    input wire clk_50m,
    input wire reset,

    input wire [7:0] data_in,
    input wire Tx_en,
    input wire Rx_en,
    input wire Rx,

    input wire ready_clr,

    output wire Tx,
    output wire Tx_busy,
    output wire ready,

    output wire [7:0] data_out,

    output wire [7:0] LEDR,

    output wire [6:0] seg_hundreds,
    output wire [6:0] seg_tens,
    output wire [6:0] seg_units
);

assign LEDR = data_in;

wire Txclk_en;
wire Rxclk_en;

baudrate baud_gen(
    .clk_50m(clk_50m),
    .reset(reset),
    .Txclk_en(Txclk_en),
    .Rxclk_en(Rxclk_en)
);

transmitter tx(
    .clk(clk_50m),
    .reset(reset),
    .clken(Txclk_en),
    .Tx_en(Tx_en),
    .data_in(data_in),
    .Tx(Tx),
    .Tx_busy(Tx_busy)
);

receiver rx(
    .clk(clk_50m),
    .reset(reset),
    .clken(Rxclk_en),
    .Rx(Rx),
    .Rx_en(Rx_en),
    .ready_clr(ready_clr),
    .ready(ready),
    .data(data_out)
);

wire [3:0] hundreds;
wire [3:0] tens;
wire [3:0] units;

assign hundreds = data_out / 100;
assign tens     = (data_out % 100) / 10;
assign units    = data_out % 10;

seven_segment_decoder ssd_h(
    .binary_in(hundreds),
    .seg(seg_hundreds)
);

seven_segment_decoder ssd_t(
    .binary_in(tens),
    .seg(seg_tens)
);

seven_segment_decoder ssd_u(
    .binary_in(units),
    .seg(seg_units)
);

endmodule


module baudrate(
    input clk_50m,
    input reset,
    output Txclk_en,
    output Rxclk_en
);

parameter BAUD = 115200;
parameter CLK_FREQ = 50000000;

parameter TX_DIV = CLK_FREQ / BAUD;
parameter RX_DIV = CLK_FREQ / (BAUD*16);

reg [$clog2(TX_DIV)-1:0] tx_cnt;
reg [$clog2(RX_DIV)-1:0] rx_cnt;

assign Txclk_en = (tx_cnt == 0);
assign Rxclk_en = (rx_cnt == 0);

always @(posedge clk_50m or posedge reset) begin
    if(reset)
        tx_cnt <= 0;
    else if(tx_cnt == TX_DIV-1)
        tx_cnt <= 0;
    else
        tx_cnt <= tx_cnt + 1;
end

always @(posedge clk_50m or posedge reset) begin
    if(reset)
        rx_cnt <= 0;
    else if(rx_cnt == RX_DIV-1)
        rx_cnt <= 0;
    else
        rx_cnt <= rx_cnt + 1;
end

endmodule



module transmitter(
    input clk,
    input reset,
    input clken,
    input Tx_en,
    input [7:0] data_in,

    output reg Tx,
    output Tx_busy
);

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

reg [1:0] state;
reg [7:0] data;
reg [2:0] bit_pos;

assign Tx_busy = (state != IDLE);

always @(posedge clk or posedge reset) begin

    if(reset) begin
        state <= IDLE;
        Tx <= 1'b1;
        bit_pos <= 0;
    end

    else begin

        case(state)

        IDLE: begin
            Tx <= 1'b1;
            if(Tx_en) begin
                data <= data_in;
                bit_pos <= 0;
                state <= START;
            end
        end

        START: begin
            if(clken) begin
                Tx <= 1'b0;
                state <= DATA;
            end
        end

        DATA: begin
            if(clken) begin
                Tx <= data[bit_pos];
                bit_pos <= bit_pos + 1;

                if(bit_pos == 3'd7)
                    state <= STOP;
            end
        end

        STOP: begin
            if(clken) begin
                Tx <= 1'b1;
                state <= IDLE;
            end
        end

        endcase

    end

end

endmodule



module receiver(
    input clk,
    input reset,
    input clken,
    input Rx,
    input Rx_en,
    input ready_clr,

    output reg ready,
    output reg [7:0] data
);

parameter START = 2'b00;
parameter DATA  = 2'b01;
parameter STOP  = 2'b10;

reg [1:0] state;
reg [3:0] sample;
reg [2:0] bit_pos;

reg [7:0] scratch;

always @(posedge clk or posedge reset) begin

    if(reset) begin
        state <= START;
        ready <= 0;
        data <= 0;
        sample <= 0;
        bit_pos <= 0;
    end

    else begin

        if(ready_clr)
            ready <= 0;

        if(clken && Rx_en) begin

            case(state)

            START: begin
                if(!Rx) begin
                    sample <= sample + 1;

                    if(sample == 15) begin
                        state <= DATA;
                        sample <= 0;
                        bit_pos <= 0;
                        scratch <= 0;
                    end
                end
                else
                    sample <= 0;
            end

            DATA: begin
                sample <= sample + 1;

                if(sample == 8)
                    scratch[bit_pos] <= Rx;

                if(sample == 15) begin
                    sample <= 0;
                    bit_pos <= bit_pos + 1;

                    if(bit_pos == 3'd7)
                        state <= STOP;
                end
            end

            STOP: begin
                sample <= sample + 1;

                if(sample == 15) begin
                    data <= scratch;
                    ready <= 1;
                    state <= START;
                    sample <= 0;
                end
            end

            endcase

        end

    end

end

endmodule



module seven_segment_decoder(
    input [3:0] binary_in,
    output reg [6:0] seg
);

always @(*) begin

    case(binary_in)

    4'd0: seg = 7'b0111111;
    4'd1: seg = 7'b0000110;
    4'd2: seg = 7'b1011011;
    4'd3: seg = 7'b1001111;
    4'd4: seg = 7'b1100110;
    4'd5: seg = 7'b1101101;
    4'd6: seg = 7'b1111101;
    4'd7: seg = 7'b0000111;
    4'd8: seg = 7'b1111111;
    4'd9: seg = 7'b1101111;

    default: seg = 7'b0000000;

    endcase

end

endmodule
