// Phase-Frequency Detector
//
// George Smart, M1GEO.
// https://www.george-smart.co.uk/
// 11 Feb 2020

// Prescaler devices by 1000.
module prescaler (
	input in,
	output out
);

	reg [8:0] counter;
	reg output_bit;
	
	initial begin
		counter = 9'b0;
		output_bit = 1'b0;
	end
	
	always @(posedge in) begin
		counter <= counter + 1'b1;
		if (counter == 499) begin
			output_bit <= ~output_bit; // invert output
			counter <= 9'b0;
		end
	end
	assign out = output_bit;

endmodule

// D Flip Flop Latch with async positive reset
module d_flop(
	input D,
	input clk,
	input reset,
	output reg Q
);

	initial Q = 0;

	always @(posedge clk or posedge reset) begin
		if(reset==1'b1)
			Q <= 1'b0;
		else
			Q <= D;
	end
endmodule 

// Phase-frequency detector - in1 is the reference
module pfd 
	#(
	parameter LOCK_DELAY_LEN=10
	)(
	input in1,
	input in2,
	
	output up,
	output down,
	output lock
);

	// PFD Section
	wire q1;
	wire q2;
	wire rst;

	d_flop d1(.D(1'b1), .clk(in1), .reset(rst), .Q(q1));
	d_flop d2(.D(1'b1), .clk(in2), .reset(rst), .Q(q2));
	
	assign rst = q1 & q2;
	assign up = q1;
	assign down = q2;
	
	// LOCK DETECT Section - GS TODO: this bit needs some thinking about
	reg [LOCK_DELAY_LEN-1:0] locked_delay;
	initial locked_delay = 0;

	wire locked_this_cycle;
	assign locked_this_cycle = (q1 == 1'b0) & (q2 == 1'b0);
	
	always @(posedge in1 or posedge in2) begin
		locked_delay <= {locked_delay[LOCK_DELAY_LEN-2:0], locked_this_cycle};
	end
	
	assign lock = &locked_delay;
endmodule
