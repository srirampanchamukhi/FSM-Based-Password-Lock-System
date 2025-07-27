`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2025 18:51:55
// Design Name: 
// Module Name: fsm_full_flow
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


module fsm_tb_full_flow;

    // Inputs
    reg clk;
    reg reset;
    reg [3:0] digit;
    reg enter;
    reg view_pass;
    reg set_pass;

    // Outputs
    wire green_led;
    wire red_led;
    wire alarm;
    wire [15:0] viewed_pass;
    wire [1:0] attempts_left;

    // DUT Instance
    fsm_password_lock dut (
        .clk(clk),
        .reset(reset),
        .digit(digit),
        .enter(enter),
        .view_pass(view_pass),
        .set_pass(set_pass),
        .green_led(green_led),
        .red_led(red_led),
        .alarm(alarm),
        .viewed_pass(viewed_pass),
        .attempts_left(attempts_left)
    );

    // Clock
    always #5 clk = ~clk;

    // Task to enter one digit
    task enter_digit(input [3:0] d);
    begin
        @(posedge clk);
        digit = d;
        enter = 1;
        @(posedge clk);
        enter = 0;
    end
    endtask

    // Task to enter 4-digit password
    task enter_password(input [3:0] d0, d1, d2, d3);
    begin
        enter_digit(d0);
        enter_digit(d1);
        enter_digit(d2);
        enter_digit(d3);
    end
    endtask

    initial begin
        // Init
        clk = 0;
        reset = 1;
        digit = 0;
        enter = 0;
        view_pass = 0;
        set_pass = 0;

        // 1. Reset system
        #10 reset = 0;

        // 2. Enter correct default password: 1 2 3 4
        enter_password(1, 2, 3, 4);
        #30;

        // 3. Set new password: 9 8 7 6
        @(posedge clk); set_pass = 1; @(posedge clk); set_pass = 0;
        enter_password(9, 8, 7, 6);
        #30;

        // 4. Re-lock system via manual reset
        @(posedge clk); reset = 1; @(posedge clk); reset = 0;
        #10;

        // 5. Enter wrong password 3 times → LOCKED
        enter_password(1, 1, 1, 1);
        #30;
        enter_password(2, 2, 2, 2);
        #30;
        enter_password(3, 3, 3, 3);
        #50;

        // 6. Reset system again
        @(posedge clk); reset = 1; @(posedge clk); reset = 0;
        #10;

        // 7. Try new password (9 8 7 6)
        enter_password(9, 8, 7, 6);
        #30;

        // 8. View new password
        @(posedge clk); view_pass = 1; @(posedge clk); view_pass = 0;
        #20;

        $display("\n✅ Final Output:");
        $display("Green LED = %b", green_led);
        $display("Red LED = %b", red_led);
        $display("Alarm = %b", alarm);
        $display("Viewed Pass = %h", viewed_pass); // Should be 0x9876

        $finish;
    end

    // Monitor
    always @(posedge clk) begin
        $display("T=%0t | State=%0d | Digit=%h | Attempts=%d | Green=%b | Red=%b | Alarm=%b | ViewPass=%h", 
            $time, dut.curr_state, digit, attempts_left, green_led, red_led, alarm, viewed_pass);
    end

endmodule
