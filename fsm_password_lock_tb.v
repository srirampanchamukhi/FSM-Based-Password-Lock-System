`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2025 11:47:30
// Design Name: 
// Module Name: fsm_password_lock_tb
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


module fsm_password_lock_tb;
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

    // Instantiate your FSM module (DUT)
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
    
    always #5 clk = ~clk;  // 10ns clock period
    
    
    initial begin
        //intital values
        clk = 0;
        reset = 1;
        digit = 4'd0;
        enter = 0;
        view_pass = 0;
        set_pass = 0;
    
        
        
        //apply reset
        #10 reset = 0;
        
        //input digit 1
        digit = 4'd1;
        enter = 1;
        #12;
        enter = 0;
        #8;
        
        //input digit 2
        digit = 4'd2;
        enter = 1;
        #12;
        enter = 0;
        #8;
        
        //input digit 3
        digit = 4'd3;
        enter = 1;
        #12;
        enter = 0;
        #8;
        
        //input digit 4
        digit = 4'd4;
        enter = 1;
        #12;
        enter = 0;
        #8;
        
        #50;
        
        $finish;
    end   
endmodule
