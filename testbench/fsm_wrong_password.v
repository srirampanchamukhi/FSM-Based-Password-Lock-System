`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2025 18:27:44
// Design Name: 
// Module Name: fsm_wrong_password
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


module fsm_wrong_password;
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

    // Instantiate the FSM module
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

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // Task to enter a digit
    task enter_digit(input [3:0] d);
    begin
        @(posedge clk);
        digit = d;
        enter = 1;
        @(posedge clk);
        enter = 0;
    end
    endtask

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        digit = 0;
        enter = 0;
        view_pass = 0;
        set_pass = 0;

        // Apply reset
        #12 reset = 0;

        // Enter wrong password: 4 3 2 1
        enter_digit(4);
        enter_digit(3);
        enter_digit(2);
        enter_digit(1);

        // Wait for FSM to process
        #50;

        // Display result
        $display("Wrong Password Test:");
        $display("Green LED = %b", green_led);
        $display("Red LED = %b", red_led);
        $display("Attempts Left = %d", attempts_left);

        // End simulation
        #20;
        $finish;
    end

    // Monitor to observe FSM behavior live
    always @(posedge clk) begin
        $display("T=%0t | State=%0d | Digit=%0h | Attempts=%d | Green=%b | Red=%b", 
                 $time, dut.curr_state, digit, attempts_left, green_led, red_led);
    end

endmodule


