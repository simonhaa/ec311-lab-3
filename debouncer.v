`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2026 06:33:35 PM
// Design Name: 
// Module Name: debouncer
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


module debouncer(
    input clk,
    input rst,
    input button,
    output reg debounced_button
    );
    
    reg [31:0] counter;
    always @ (posedge clk) begin
        if(rst) begin
            counter <= 0;
            debounced_button <= 0;
        end else begin
            if(button) begin
                counter <= counter + 1;
                if(counter == 32'd1_000_000) begin
                    debounced_button <= 1;
                end else begin
                    debounced_button <= debounced_button;
                end
            end else begin
                counter <= 0;
                debounced_button <= 0;
            end
        end
    end
    
    
    
    
    
endmodule
