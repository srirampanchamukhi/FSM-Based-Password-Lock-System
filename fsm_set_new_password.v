`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2025 18:47:07
// Design Name: 
// Module Name: fsm_set_new_password
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


module fsm_set_new_password;
    

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

    // Instantiate DUT
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

    // Clock generation
    always #5 clk = ~clk;

    // Task: enter one digit with enter high
    task enter_digit(input [3:0] d);
    begin
        @(posedge clk);
        digit = d;
        enter = 1;
        @(posedge clk);
        enter = 0;
    end
    endtask

    // Task: enter full password
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

        // Reset FSM
        #10 reset = 0;

        // Enter correct password (default 1234)
        enter_password(1, 2, 3, 4);
        #50;

        // Set new password 9 8 7 6
        @(posedge clk);
        set_pass = 1;
        @(posedge clk);
        set_pass = 0;

        enter_password(9, 8, 7, 6);  // new password
        #50;

        // Now test new password works
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        #10;

        enter_password(9, 8, 7, 6);  // new password again
        #50;

        $display("Test completed.");
        $finish;
    end

    // Debug Monitor
    always @(posedge clk) begin
        $display("T=%0t | State=%0d | Digit=%h | Attempts=%d | Green=%b | Red=%b | Alarm=%b", 
                 $time, dut.curr_state, digit, attempts_left, green_led, red_led, alarm);
    end

endmodule


