`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2025 09:19:58
// Design Name: 
// Module Name: fsm_password_lock
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


module fsm_password_lock(
    input clk,
    input reset,
    input [3:0] digit,
    input enter,
    input view_pass,
    input set_pass,
    output reg green_led,
    output reg red_led,
    output reg alarm,
    output reg [15:0] viewed_pass,
    output reg [1:0] attempts_left
    );
    
    //registers to store data and states
    reg [3:0] entered_pass [3:0];   
    reg [3:0] stored_pass [3:0];    
    reg [3:0] curr_state;
    reg [3:0] next_state;                 
    reg [1:0] index;
    
    //Helper functions
    wire valid_digit;
    assign valid_digit = (digit <= 4'hF);
    wire password_matches;
    assign password_matches = (entered_pass[0] == stored_pass[0]) &&
                              (entered_pass[1] == stored_pass[1]) &&
                              (entered_pass[2] == stored_pass[2]) &&
                              (entered_pass[3] == stored_pass[3]);
   
    
    //defining states 
    localparam IDLE        = 4'd0;
    localparam READ_1      = 4'd1;
    localparam READ_2      = 4'd2;
    localparam READ_3      = 4'd3;
    localparam READ_4      = 4'd4;
    localparam CHECK       = 4'd5;
    localparam UNLOCKED    = 4'd6;
    localparam ERROR       = 4'd7;
    localparam LOCKED      = 4'd8;
    localparam VIEW_PASS   = 4'd9;
    localparam SET_PASS_1  = 4'd10;
    localparam SET_PASS_2  = 4'd11;
    localparam SET_PASS_3  = 4'd12;
    localparam SET_PASS_4  = 4'd13;
    localparam RESET_STATE = 4'd14;
    
    //1. Defining the job of each state
    always @(posedge clk) begin
        $display("State: %d | password_matches = %b | current: %h %h %h %h ", curr_state, password_matches,stored_pass[3],stored_pass[2],stored_pass[1],stored_pass[0]);
        if (reset) begin
            curr_state <= IDLE;
            next_state <= IDLE;
            index <= 2'd0;
            attempts_left <= 2'd3;
            green_led <= 0;
            red_led <= 0;
            alarm <= 0;
            viewed_pass <= 16'b0;
            //stored_pass and cleared pass yet to add
            //initial password
            stored_pass[0] <= 4'd1; entered_pass[0] <= 4'd0;
            stored_pass[1] <= 4'd2; entered_pass[1] <= 4'd0;
            stored_pass[2] <= 4'd3; entered_pass[2] <= 4'd0;
            stored_pass[3] <= 4'd4; entered_pass[3] <= 4'd0;
            
        end
        else begin 
            curr_state <= next_state;
           
            
            
            case (curr_state)
            
                IDLE, RESET_STATE: begin
                    green_led <= 0;
                    red_led   <= 0;
                    alarm     <= 0;
                    index     <= 0;
                end
                
                    
                READ_1,READ_2,READ_3,READ_4: begin
                    if(enter) begin 
                        entered_pass[index] <= digit;
                        index <= index + 1;
                    end
                end
                
                CHECK: begin
                    //password comparison logic will come here
                    
                end
                
                UNLOCKED: begin
                    green_led <= 1;
                    red_led <= 0;
                end
                
                ERROR: begin
                    red_led <= 1;
                    green_led <= 0;
                    if (attempts_left > 0)
                        attempts_left <= attempts_left - 1;
                end
                
                LOCKED: begin 
                    alarm <= 1;
                end
                
                VIEW_PASS: begin
                    viewed_pass[15:12] <= stored_pass[3];
                    viewed_pass[11:8] <= stored_pass[2];
                    viewed_pass[7:4] <= stored_pass[1];
                    viewed_pass[3:0] <= stored_pass[0];
                end
                
                SET_PASS_1,SET_PASS_2,SET_PASS_3,SET_PASS_4: begin
                    if(enter) begin
                        stored_pass[index] <= digit;
                        index <= index + 1;
                    end
                end
                
                RESET_STATE: begin
                    attempts_left <=2'd3;
                    red_led <= 0;
                    alarm <= 0;
                    green_led <= 0;
                    index <= 0;
                end
                
                default begin end
             endcase
         end
     end
              
    //2. State Transition Logic
    always @(*) begin
        next_state=curr_state;
        
        case (curr_state)
            IDLE: begin
                if(valid_digit) 
                    next_state = READ_1;
            end
            
            READ_1: begin
                if (enter && valid_digit) 
                    next_state = READ_2;
            end
            
            READ_2: begin
                if (enter && valid_digit) 
                    next_state = READ_3;
            end
            
            READ_3: begin 
                if (enter && valid_digit) 
                    next_state = READ_4;
            end
            
            READ_4: begin
                if (enter && valid_digit) 
                    next_state = CHECK;
            end
            
            CHECK: begin
                if(password_matches)
                    next_state = UNLOCKED;
                else if (attempts_left == 1)
                    next_state = LOCKED;
                else
                    next_state = ERROR; 
            end
            
            ERROR: begin
                next_state = IDLE;
            end
            
            LOCKED: begin
                if (reset)
                    next_state = RESET_STATE;
            end
            
            RESET_STATE: next_state = IDLE;
            
            UNLOCKED: begin
                if (view_pass)
                    next_state = VIEW_PASS;
                else if (set_pass)
                    next_state = SET_PASS_1;
                else if (reset)
                    next_state = RESET_STATE;
            end
            
            VIEW_PASS: begin
                next_state = UNLOCKED;
            end
            
            SET_PASS_1: begin
                if (enter && valid_digit) 
                    next_state = SET_PASS_2;
            end
            
            SET_PASS_2: begin
                if (enter && valid_digit) 
                    next_state = SET_PASS_3;
            end
            
            SET_PASS_3: begin
                if (enter && valid_digit) 
                    next_state = SET_PASS_4;
            end
                               
            SET_PASS_4: begin
                if (enter && valid_digit) 
                    next_state = UNLOCKED;
            end
            
            default: next_state =IDLE;
        endcase
    end    
            
             
       
        
        
               

    
endmodule
