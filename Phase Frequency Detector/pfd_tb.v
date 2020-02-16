`timescale 10ns/1ns

// Phase-Frequency Detector Testbench
// Very simple test bench, but you can tinker!
//
// George Smart, M1GEO.
// https://www.george-smart.co.uk/
// 16 Feb 2020

module pfd_tb;

	reg refclk;
	reg vco10m;

	//
	// Connect up test devices
	//
	
	// divide 10 MHz to 10 kHz
	wire vco_div;
	prescaler div1000(
		.in(vco10m),
		.out(vco_div)
	);
	
	// put the reference and divided VCO into the phase detector
	wire p_up;
	wire p_dn;
	wire p_lk;
	pfd #(.LOCK_DELAY_LEN(10)) pha_det (
		.in1(refclk),
		.in2(vco_div),
		.up(p_up),
		.down(p_dn),
		.lock(p_lk)
	);

	//
	// Set up simulation
	//
	
	integer a;

	initial begin
		vco10m = 0; // 10 MHz
		refclk = 0; // 10 kHz
		a = 5000;
		#100000;
		a = 5100;
		#100000;
		a = 4900;
		#100000;
		a = 5000;
		#1000000;
		$finish;
	end
	
	//
	// Generage clocks
	//
	
	always begin
		#a refclk = ~refclk;
	end

	always begin
		#5 vco10m = ~vco10m;
	end

endmodule