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
    input clk,                  // System clock
    input BTNL,                  // BTNL (left button)
    input BTNR,                 // BTNR (right button)
    input BTNC,                // BTNC (center button)
    input BTNU,                 // BTNU (up button) Moves back one state
    input BTND,                // BTND (down button) Resets the FSM back to Start
    input rst,
    output [6:0] segments,          
    output reg [7:0] AN
    );
    
always @(posedge clk) begin
    if (rst) begin
        bank1 <= 5'd0;
        bank2 <= 5'd0;
        bank3 <= 5'd0;
        bank4 <= 5'd0;
        bank5 <= 5'd0;
        bank6 <= 5'd0;
        bank7 <= 5'd0;
    end else if (BTNC) begin
        bank1 <= states;
        bank2 <= bank1;
        bank3 <= bank2;
        bank4 <= bank3;
        bank5 <= bank4;
        bank6 <= bank5;
        bank7 <= bank6;
    end
end


//add debouncer pls


reg [CLK_WIDTH:0] counter;
wire [1:0] divCounter;
reg [3:0] input_hex;

reg [4:0] bank1,bank2,bank3,bank4,bank5,bank6,bank7;                // Holds 7 letters; these are the stored letters
reg [4:0] states,in;

morse_code morse(
.clk(clk),
.dot(BTNL),
.dash(BTNR),
.store(BTNC),
.undo(BTNU),
.clear(BTND),
.rst(rst),
.states(states));


seven_segment sev(
.in(in),
.seg(segments));


// State flip flops
    always @(posedge clk or posedge rst) begin
        if (rst) counter <= 0;
        else counter <= counter + 1;
    end

    assign divCounter = counter[CLK_WIDTH-:3];

    always @* begin
        case(divCounter)
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
