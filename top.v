`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2026 05:25:08 PM
// Design Name: 
// Module Name: top
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


module top #(parameter CLK_WIDTH = 16) (
    input clk,                      // System clock
    input BTNL,                     // BTNL (left button)
    input BTNR,                     // BTNR (right button)
    input BTNC,                     // BTNC (center button)
    input BTNU,                     // BTNU (up button) Moves back one state
    input BTND,                     // BTND (down button) Resets the FSM back to Start
    input rst,                      // Active-high synchronous reset
    output [6:0] segments,          // Drives seven segment display
    output reg [7:0] AN
    );
    
// 8 banks; first bank holds the current letter; rest of them store letters
reg [4:0] bank1, bank2, bank3, bank4, bank5, bank6, bank7;

// Display multiplexer
reg [4:0] in;
// Morse output
wire [4:0] states;
// Debounced buttons
wire d_dot, d_dash, d_store, d_undo, d_clear;

// Bank 1 holds the value of current letter
// When 'store' is pressed, bank 2 holds the previous value of current letter; each 'store' sets the value of the next bank equal to the current bank
always @(posedge clk) begin
    if (rst) begin
        bank1 <= 5'd0;
        bank2 <= 5'd0;
        bank3 <= 5'd0;
        bank4 <= 5'd0;
        bank5 <= 5'd0;
        bank6 <= 5'd0;
        bank7 <= 5'd0;
    end else if (d_store) begin
        bank1 <= states;
        bank2 <= bank1;
        bank3 <= bank2;
        bank4 <= bank3;
        bank5 <= bank4;
        bank6 <= bank5;
        bank7 <= bank6;
    end
end

morse_code morse(
.clk(clk),
.dot(d_dot),
.dash(d_dash),
.store(d_store),
.undo(d_undo),
.clear(d_clear),
.rst(rst),
.states(states));

seven_segment sev(
.in(in),
.seg(segments));

// Debouncers
debouncer b_dot(.clk(clk),
.rst(rst),
.button(BTNL),
.single_cycle_button(d_dot));

debouncer b_dash(.clk(clk),
.rst(rst),
.button(BTNR),
.single_cycle_button(d_dash));

debouncer b_store(.clk(clk),
.rst(rst),
.button(BTNC),
.single_cycle_button(d_store));

debouncer b_undo(.clk(clk),
.rst(rst),
.button(BTNU),
.single_cycle_button(d_undo));

debouncer b_clear(.clk(clk),
.rst(rst),
.button(BTND),
.single_cycle_button(d_clear));

// Refresh counter
reg [CLK_WIDTH:0] counter;
wire [2:0] divCounter;
reg [3:0] input_hex;

always @(posedge clk or posedge rst) begin
    if (rst) counter <= 0;
    else counter <= counter + 1;
end

assign divCounter = counter[CLK_WIDTH-:3];

always @(*) begin
    case (divCounter)
    0: begin
    AN = 8'b11111110;
    in = states;
    end
    
    1: begin
    AN = 8'b11111101;           
    in = bank1;
    
    end
    2: begin
    AN = 8'b11111011;          
    in = bank2;
    end
 
    3:begin
    AN = 8'b11110111;           
    in = bank3;
    end
    
    4:begin
    AN = 8'b11101111;
    in = bank4;
    end
    
    5:begin
    AN = 8'b11011111;
    in = bank5;
    end
    
    6:begin
    AN = 8'b10111111;
    in = bank6;
    end
    
    7:begin
    AN = 8'b01111111;
    in = bank7;
    end
    
    endcase
end
    
    
endmodule
