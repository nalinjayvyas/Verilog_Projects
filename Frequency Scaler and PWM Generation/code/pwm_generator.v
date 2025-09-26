/* EcoMender Bot : Task 1A : PWM Generator
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a module which will scale down the 100KHz Clock Frequency to 500Hz and perform Pulse Width Modulation on it.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//PWM Generator
//Inputs : clk_1MHz, pulse_width
//Output : clk_500Hz, pwm_signal

module pwm_generator(
    input clk_1MHz,
    input [3:0] pulse_width,
    output reg clk_500Hz, pwm_signal
);

initial begin
    clk_500Hz = 1; pwm_signal = 1;
end

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

reg [9:0] clk_div_1MHz = -1;        // 10-bit counter to divide 1 MHz clock for 500 Hz
always @(posedge clk_1MHz) begin
    if (clk_div_1MHz == 999) begin  // 1000 cycles of 1MHz = 1 half cycle of 500Hz
        clk_div_1MHz <= 0;
        clk_500Hz <= ~clk_500Hz;    // Toggle the 500 Hz clock
    end else begin
        clk_div_1MHz <= clk_div_1MHz + 1;
    end
end

// PWM Signal Generation
reg [10:0] pwm_counter = 0;         // 11-bit counter for PWM signal generation
always @(posedge clk_1MHz) begin
    if (pwm_counter < (pulse_width * 100)) begin
        pwm_signal <= 1;           // PWM signal high for duty cycle based on pulse width
    end else begin
        pwm_signal <= 0;           // PWM signal low after duty cycle
    end
    
    /* Increment PWM counter at every +ve edge of 1MHz clock and 
	 reset it once 1 full 500Hz cycle is done i.e next pulse width is just about to be sent
    */
	 if (pwm_counter > 1998) begin
        pwm_counter <= 0;
    end else begin
        pwm_counter <= pwm_counter + 1;
    end
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule   