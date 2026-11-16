`timescale 1ns / 1ps
module debouncer(
    input clk,
    input rst,
    input button,
    output reg single_cycle_button    
    );
    reg [31:0] counter;
    reg debounced_button;
    always @ (posedge clk) begin
        if (rst) begin
            counter <= 0;
            debounced_button <= 0;
        end else begin
            // 10 ms debounce interval
            if (button) begin
                counter <= counter + 1;
                if (counter == 32'd1_000_000) begin
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
    
    reg button_trigger;
    // Button_trigger is one cycle behind debounced_button because it triggers off of debounced_button and not when the button is pressed
    // Single_cycle_button is active when debounced_button initially triggers
    always @ (posedge clk) begin
        if (rst) begin
            button_trigger <= 0;
            single_cycle_button <= 0;
        end else begin
            if (debounced_button) begin
                button_trigger <= 1;
            end else begin
                button_trigger <= 0;
            end
            
            if (debounced_button & ~button_trigger) begin
                single_cycle_button <= 1;
            end else begin
                single_cycle_button <= 0;
            end
        end
    end
    
endmodule