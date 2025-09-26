module t1b_cd_fd (
    input  clk_1MHz, cs_out,
    output reg [1:0] filter, color
);

// red   -> color = 1;
// green -> color = 2;
// blue  -> color = 3;

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////
/*
Add your logic here
*/
parameter S_CLEAR = 2'b10;  // Clear state (0)
parameter S_RED   = 2'b00;  // Red state (1)
parameter S_GREEN = 2'b11;  // Green state (2)
parameter S_BLUE  = 2'b01;  // Blue state (3);

// Parameters
parameter STATE_DURATION = 500; // Duration for each state in clock cycles

// State and counter registers
reg [1:0] state;   // Holds the current state
reg [8:0] counter; // 9-bit counter for timing

// Counters for colors
reg [14:0] red_counter;
reg [14:0] blue_counter;
reg [14:0] green_counter;

// State initialization
initial begin
    state = S_GREEN;     // Start from Green state
    color = 0;	 // Initialize color to Green
    counter = -1;         // Initialize counter to 0
    red_counter   = 0;
    blue_counter  = 0;
    green_counter = 0;
end

// State machine logic
always @(posedge clk_1MHz) begin
    // State timing logic
    if ((state == S_GREEN) || (state == S_RED)) begin
        if (counter == STATE_DURATION - 1) begin
            case (state)
                S_GREEN: state <= S_RED;
                S_RED:   state <= S_BLUE;
            endcase
            counter <= 0; // Reset counter at the end of each state
        end else begin
            counter <= counter + 1; // Increment counter
        end
    end else if (state == S_BLUE) begin
        if (counter == 499) begin
            state <= S_CLEAR;
				if ((red_counter > blue_counter) && (red_counter > green_counter)) begin
            color <= 1; // Red
				end else if ((blue_counter > red_counter) && (blue_counter > green_counter)) begin
            color <= 3; // Blue
				end else if ((green_counter > red_counter) && (green_counter > blue_counter)) begin
            color <= 2; // Green
				end
            counter <= 0;
        end else begin
            counter <= counter + 1;        
        end
    end else if (state == S_CLEAR) begin
        // In the S_CLEAR state, we compare the color counters and set the color
        // Transition to S_GREEN after one clock cycle
        state <= S_GREEN;
        counter <= 0;
    end
end

// Color counters
always @(posedge cs_out) begin
    case (state)
        S_RED:   red_counter   <= red_counter + 1;
        S_BLUE:  blue_counter  <= blue_counter + 1;
        S_GREEN: green_counter <= green_counter + 1;
        S_CLEAR: begin
            red_counter   <= 0;
            blue_counter  <= 0;
            green_counter <= 0;
        end
    endcase
end

// Filter follows the state
always @(*) begin
    filter = state;
end

endmodule