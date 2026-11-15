`timescale 1ns / 1ps

module morse_code_tb;

    // DUT signals
    reg  clk = 0;
    reg  dot = 0, dash = 0, store = 0, undo = 0, clear = 0, rst = 0;
    wire [4:0] states;

    morse_code dut (
        .clk(clk), .dot(dot), .dash(dash), .store(store),
        .undo(undo), .clear(clear), .rst(rst), .states(states)
    );

    always #5 clk = ~clk;   // 100 MHz

    // State encodings (mirror the DUT)
    localparam S_START = 0,  S_E = 1,  S_T = 2,  S_I = 3,  S_A = 4,  S_N = 5,
               S_M = 6,      S_S = 7,  S_U = 8,  S_R = 9,  S_W = 10, S_D = 11,
               S_K = 12,     S_G = 13, S_O = 14, S_H = 15, S_V = 16, S_F = 17,
               S_L = 18,     S_P = 19, S_J = 20, S_B = 21, S_X = 22, S_C = 23,
               S_Y = 24,     S_Z = 25, S_Q = 26;

    integer pass_cnt = 0, fail_cnt = 0;
    reg [4:0] path [0:5];   // states visited while entering a letter
    integer i, k;

    // ------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------
    // Apply one clock cycle of inputs, then release them.
    task step(input d, input da, input u, input c, input s);
        begin
            dot = d; dash = da; undo = u; clear = c; store = s;
            @(posedge clk); #1;
            @(negedge clk);
            dot = 0; dash = 0; undo = 0; clear = 0; store = 0;
        end
    endtask

    task tap_dot;   begin step(1,0,0,0,0); end endtask
    task tap_dash;  begin step(0,1,0,0,0); end endtask
    task tap_undo;  begin step(0,0,1,0,0); end endtask
    task tap_clear; begin step(0,0,0,1,0); end endtask
    task tap_store; begin step(0,0,0,0,1); end endtask
    task idle;      begin step(0,0,0,0,0); end endtask

    task check(input [4:0] exp, input [8*40:1] name);
        begin
            if (states === exp) begin
                pass_cnt = pass_cnt + 1;
            end else begin
                fail_cnt = fail_cnt + 1;
                $display("[FAIL] %0s : expected %0d, got %0d (t=%0t)", name, exp, states, $time);
            end
        end
    endtask

    // Enter a letter (bits[len-1] is the first symbol; 0 = dot, 1 = dash),
    // check the final state, check that dot/dash are ignored where they
    // should be, then undo all the way back and verify each parent state.
    task test_letter(input [3:0] bits, input integer len, input [4:0] exp,
                     input ign_dot, input ign_dash, input [8*8:1] name);
        begin
            tap_clear;
            check(S_START, "pre-clear");
            path[0] = S_START;
            for (i = len-1; i >= 0; i = i - 1) begin
                if (bits[i]) tap_dash; else tap_dot;
                path[len-i] = states;
            end
            check(exp, name);

            if (ign_dot)  begin tap_dot;  check(exp, "dot ignored at dead end");  end
            if (ign_dash) begin tap_dash; check(exp, "dash ignored at dead end"); end

            for (k = len; k >= 1; k = k - 1) begin
                tap_undo;
                check(path[k-1], "undo returns to parent");
            end
            check(S_START, "undo path ends at START");
        end
    endtask

    // ------------------------------------------------------------
    // Test sequence
    // ------------------------------------------------------------
    initial begin
        $display("==== morse_code testbench start ====");
        @(negedge clk);

        // ---- 1. Reset ----
        rst = 1; idle; idle; rst = 0;
        check(S_START, "reset -> START");

        // Idle holds state
        idle; idle; idle;
        check(S_START, "idle holds START");

        // ---- 2. Every letter: path, dead ends, undo chain ----
        //                bits  len  exp   ign_dot ign_dash name
        test_letter(4'b0,    1, S_E, 0, 0, "E");
        test_letter(4'b1,    1, S_T, 0, 0, "T");
        test_letter(4'b00,   2, S_I, 0, 0, "I");
        test_letter(4'b01,   2, S_A, 0, 0, "A");
        test_letter(4'b10,   2, S_N, 0, 0, "N");
        test_letter(4'b11,   2, S_M, 0, 0, "M");
        test_letter(4'b000,  3, S_S, 0, 0, "S");
        test_letter(4'b001,  3, S_U, 0, 1, "U");   // U has no dash exit
        test_letter(4'b010,  3, S_R, 0, 1, "R");   // R has no dash exit
        test_letter(4'b011,  3, S_W, 0, 0, "W");
        test_letter(4'b100,  3, S_D, 0, 0, "D");
        test_letter(4'b101,  3, S_K, 0, 0, "K");
        test_letter(4'b110,  3, S_G, 0, 0, "G");
        test_letter(4'b111,  3, S_O, 1, 1, "O");
        test_letter(4'b0000, 4, S_H, 1, 1, "H");
        test_letter(4'b0001, 4, S_V, 1, 1, "V");
        test_letter(4'b0010, 4, S_F, 1, 1, "F");
        test_letter(4'b0100, 4, S_L, 1, 1, "L");
        test_letter(4'b0110, 4, S_P, 1, 1, "P");
        test_letter(4'b0111, 4, S_J, 1, 1, "J");
        test_letter(4'b1000, 4, S_B, 1, 1, "B");
        test_letter(4'b1001, 4, S_X, 1, 1, "X");
        test_letter(4'b1010, 4, S_C, 1, 1, "C");
        test_letter(4'b1011, 4, S_Y, 1, 1, "Y");
        test_letter(4'b1100, 4, S_Z, 1, 1, "Z");
        test_letter(4'b1101, 4, S_Q, 1, 1, "Q");

        // ---- 3. Undo at START does nothing ----
        tap_clear;
        tap_undo; check(S_START, "undo at START stays");
        tap_undo; check(S_START, "double undo at START stays");

        // ---- 4. Clear from every depth ----
        tap_dot; tap_dot; tap_dot; tap_dot;          // H
        check(S_H, "reach H");
        tap_clear; check(S_START, "clear from depth 4");
        tap_dash; tap_dash; tap_dot;                  // G
        tap_clear; check(S_START, "clear from depth 3");
        tap_dot;
        tap_clear; check(S_START, "clear from depth 1");
        tap_clear; check(S_START, "clear at START stays");

        // ---- 5. Store (alone) returns to START from every kind of state ----
        tap_dash; tap_dot; tap_dash; tap_dot;         // C
        check(S_C, "reach C");
        tap_store; check(S_START, "store from leaf -> START");
        tap_dot;
        tap_store; check(S_START, "store from E -> START");
        tap_store; check(S_START, "store at START stays");

        // ---- 6. Simultaneous inputs: dot > dash > undo priority ----
        tap_clear;
        step(1,1,0,0,0); check(S_E, "dot+dash at START: dot wins");
        step(0,1,1,0,0); check(S_A, "dash+undo at E: dash wins");
        step(1,0,1,0,0); check(S_R, "dot+undo at A: dot wins");
        step(1,1,1,0,0); check(S_L, "dot+dash+undo at R: dot wins");

        // ---- 7. Clear/store simultaneous with other buttons ----
        // INTENDED behavior: clear/store override everything.
        // These FAIL on the current code, because the case statement
        // overwrites next_state after the clear/store line.
        tap_clear; tap_dot;                           // E
        step(1,0,0,1,0); check(S_START, "clear+dot  -> START (intended)");
        tap_dot;
        step(0,1,0,1,0); check(S_START, "clear+dash -> START (intended)");
        tap_dot; tap_dot;                             // I
        step(0,0,1,1,0); check(S_START, "clear+undo -> START (intended)");
        tap_dot;
        step(1,0,0,0,1); check(S_START, "store+dot  -> START (intended)");
        tap_dot;
        step(0,1,0,0,1); check(S_START, "store+dash -> START (intended)");
        tap_dot; tap_dot;
        step(0,0,1,0,1); check(S_START, "store+undo -> START (intended)");

        // ---- 8. Button held for several cycles (no edge detection) ----
        tap_clear;
        dot = 1;
        @(posedge clk); #1; check(S_E, "held dot cycle 1");
        @(posedge clk); #1; check(S_I, "held dot cycle 2");
        @(posedge clk); #1; check(S_S, "held dot cycle 3");
        @(posedge clk); #1; check(S_H, "held dot cycle 4");
        @(posedge clk); #1; check(S_H, "held dot cycle 5 stays at H");
        @(negedge clk); dot = 0;

        // ---- 9. Reset in the middle of operation ----
        check(S_H, "pre-reset is H");
        rst = 1; dot = 1;                              // rst with dot held
        @(posedge clk); #1;
        check(S_START, "rst overrides dot");
        @(negedge clk); rst = 0; dot = 0;
        tap_dash; tap_dash;                            // M
        rst = 1; idle; rst = 0;
        check(S_START, "reset from M");
        rst = 1; clear = 1; idle; rst = 0; clear = 0;
        check(S_START, "rst+clear");

        // ---- 10. Illegal states 27..31 recover via default ----
        for (k = 27; k <= 31; k = k + 1) begin
            @(negedge clk);
            dut.state = k[4:0];                        // force an illegal state
            #1;
            @(posedge clk); #1;
            check(S_START, "illegal state -> START");
        end

        // ---- 11. Illegal state is NOT escaped by inputs other than default ----
        @(negedge clk); dut.state = 5'd29;
        step(1,0,0,0,0); check(S_START, "dot in illegal state -> START");

        // ---- 12. Full walk of a long sequence with mid-way undo ----
        tap_clear;
        tap_dot; tap_dash; tap_dash; tap_dot;          // P (.--.)
        check(S_P, "reach P");
        tap_undo; check(S_W, "P undo -> W");
        tap_dash; check(S_J, "W dash -> J");
        tap_undo; tap_undo; check(S_A, "undo twice -> A");
        tap_dot;  check(S_R, "A dot -> R");

        // ---- Summary ----
        $display("====================================");
        $display("PASS: %0d   FAIL: %0d", pass_cnt, fail_cnt);
        if (fail_cnt == 0) $display("ALL TESTS PASSED");
        else               $display("SOME TESTS FAILED");
        $finish;
    end

    // Safety timeout
    initial begin
        #2_000_000;
        $display("[TIMEOUT]");
        $finish;
    end

endmodule