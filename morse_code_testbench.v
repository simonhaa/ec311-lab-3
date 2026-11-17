`timescale 1ns/1ns

module morse_code_testbench;
    reg  clk = 0;
    reg  dot = 0, dash = 0, store = 0, undo = 0, clear = 0, rst = 0;
    wire [4:0] states;

    // DUT Instantiation
    morse_code dut (
        .clk(clk),
        .dot(dot),
        .dash(dash),
        .store(store),
        .undo(undo),
        .clear(clear),
        .rst(rst),
        .states(states)
    );

    localparam S_START = 0;
    localparam S_E = 1;             // .
    localparam S_T = 2;             // -
    localparam S_I = 3;             // ..
    localparam S_A = 4;             // .-
    localparam S_N = 5;             // -.
    localparam S_M = 6;             // --
    localparam S_S = 7;             // ...
    localparam S_U = 8;             // ..-
    localparam S_R = 9;             // .-.
    localparam S_W = 10;            // .--
    localparam S_D = 11;            // -..
    localparam S_K = 12;            // -.-
    localparam S_G = 13;            // --.
    localparam S_O = 14;            // ---
    localparam S_H = 15;            // ....
    localparam S_V = 16;            // ...-
    localparam S_F = 17;            // ..-.
    localparam S_L = 18;            // .-..
    localparam S_P = 19;            // .--.
    localparam S_J = 20;            // .---
    localparam S_B = 21;            // -...
    localparam S_X = 22;            // -..-
    localparam S_C = 23;            // -.-.
    localparam S_Y = 24;            // -.--
    localparam S_Z = 25;            // --..
    localparam S_Q = 26;            // --.-

    // Clock generation
    always #5 clk = ~clk;           // 10 ns period = 100 MHz

    // helper functions so i dont manually type out every input
    task pulse_dot; begin dot = 1; #10; dot = 0; #10; end endtask
    task pulse_dash; begin dash = 1; #10; dash = 0; #10; end endtask
    task pulse_store; begin store = 1; #10; store = 0; #10; end endtask
    task pulse_undo; begin undo = 1; #10; undo = 0; #10; end endtask
    task pulse_clear; begin clear = 1; #10; clear = 0; #10; end endtask

    task check_state;
        $display("[%0t ns] states = %b", $time, states);
    endtask

    // morse_code DUT outputs its states
    initial begin
        // Resets to S_START state
        rst = 1; #10; rst = 0; #10;

        // Make sure S_START remains in S_START while clear, undo, and store are pressed
        $display("Begin start state checks: ");
        pulse_store;
        check_state;

        pulse_undo;
        check_state;

        pulse_clear;
        check_state;
        $display("\n");

        $display("Working clear: 00000");
        pulse_dot;
        pulse_clear;
        check_state;
        $display("\n");

        $display("Working reset: 00000");
        pulse_dot; pulse_dash; pulse_dot;
        rst = 1; #10; rst = 0; #10;
        check_state;
        $display("\n");

        $display("E state check: 00001");
        pulse_dot;
        check_state;
        $display("\n");
        pulse_clear;

        $display("T state check: 00010");
        pulse_dash;
        check_state;
        $display("\n");
        pulse_clear;

        $display("I state check: 00011");
        pulse_dot; pulse_dot;
        check_state;
        $display("\n");
        pulse_clear;

        $display("A state check: 00100");
        pulse_dot; pulse_dash;
        check_state;
        $display("\n");
        pulse_clear;

        $display("N state check: 00101");
        pulse_dash; pulse_dot;
        check_state;
        $display("\n");
        pulse_clear;

        $display("M state check: 00110");
        pulse_dash; pulse_dash;
        check_state;
        $display("\n");
        pulse_clear;

        $display("S state check: 00111");
        pulse_dot; pulse_dot; pulse_dot;
        check_state;
        $display("\n");
        pulse_clear;

        $display("U state check: 01000");
        pulse_dot; pulse_dot; pulse_dash;
        check_state;
        $display("\n");
        pulse_clear;

        $display("R state check: 01001");
        pulse_dot; pulse_dash; pulse_dot;
        check_state;
        $display("\n");
        pulse_clear;

        $display("W state check: 01010");
        pulse_dot; pulse_dash; pulse_dash;
        check_state;
        $display("\n");
        pulse_clear;

        $display("D state check: 01011");
        pulse_dash; pulse_dot; pulse_dot;
        check_state;
        $display("\n");
        pulse_clear;

        $display("K state check: 01100");
        pulse_dash; pulse_dot; pulse_dash;
        check_state;
        $display("\n");
        pulse_clear;

        $display("G state check: 01101");
        pulse_dash; pulse_dash; pulse_dot;
        check_state;
        $display("\n");
        pulse_clear;

        $display("O state check: 01110");
        pulse_dash;; pulse_dash; pulse_dash;
        check_state;
        $display("\n");
        pulse_clear;

        $display("H state check: 01111");
        pulse_dot; pulse_dot; pulse_dot; pulse_dot;
        check_state;
        $display("\n");
        pulse_clear;

        $display("V state check: 10000");
        pulse_dot; pulse_dot; pulse_dot; pulse_dash;
        check_state;
        $display("\n");
        pulse_clear;

        $display("F state check: 10001");
        pulse_dot; pulse_dot; pulse_dash; pulse_dot;
        check_state;
        $display("\n");
        pulse_clear;

        $display("L state check: 10010");
        pulse_dot; pulse_dash; pulse_dot; pulse_dot;
        check_state;
        $display("\n");
        pulse_clear;

        $display("P state check: 10011");
        pulse_dot; pulse_dash; pulse_dash; pulse_dot;
        check_state;
        $display("\n");
        pulse_clear;

        $display("J state check: 10100");
        pulse_dot; pulse_dash; pulse_dash; pulse_dash;
        check_state;
        $display("\n");
        pulse_clear;

        $display("B state check: 10101");
        pulse_dash; pulse_dot; pulse_dot; pulse_dot;
        check_state;
        $display("\n");
        pulse_clear;

        $display("X state check: 10110");
        pulse_dash; pulse_dot; pulse_dot; pulse_dash;
        check_state;
        $display("\n");
        pulse_clear;

        $display("C state check: 10111");
        pulse_dash; pulse_dot; pulse_dash; pulse_dot;
        check_state;
        $display("\n");
        pulse_clear;

        $display("Y state check: 11000");
        pulse_dash; pulse_dot; pulse_dash; pulse_dash;
        check_state;
        $display("\n");
        pulse_clear;

        $display("Z state check: 11001");
        pulse_dash; pulse_dash; pulse_dot; pulse_dot;
        check_state;
        $display("\n");
        pulse_clear;

        $display("Q state check: 11010");
        pulse_dash; pulse_dash; pulse_dot; pulse_dash;
        check_state;
        $display("\n");
        pulse_clear;

        $display("State stays in H state (01111) after more than 4 dot pulses");
        pulse_dot; pulse_dot; pulse_dot; pulse_dot; pulse_dot; pulse_dash;
        check_state;
        $display("\n");
        pulse_clear;

        $display("Working undo (H -> S : 01111 -> 00111)");
        pulse_dot; pulse_dot; pulse_dot; pulse_dot; pulse_undo;
        check_state;
        $display("\n");
        pulse_clear;

        $display("Store check (resets back to start)");
        pulse_dot; pulse_dash; pulse_store;
        check_state;
        $display("\n");
        pulse_clear;

        $finish;
    end

endmodule