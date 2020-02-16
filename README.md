# verilog-snippets
This respository is a collection of snippets or modules in Verilog to serve some purpose. They are free to be used however you'd like. They come with no implied fitness for purpose or warranty of any kind.

Pull requests are accepted for improvements on code here.

# MAX6951 8-digit 7-segment LED driver IC
This code takes a 32-bit number and displays it (in hex) on eight 7-segment displays. It uses 2 state machines, one to send the data in SPI-like fashion and another to control which registers to write.

# Phase-Frequency Detector
The phase-frequency detector (PFD) code uses two D type flip-flops to create a Type 2 phase detector. The code has been simulated (basic testbench included) and also deployed on FPGA to lock a 10 MHz VCO to a 10 kHz GPS frequency reference. [See here](https://www.george-smart.co.uk/2020/02/experiments-with-phase-frequency-detectors/).

![alt text](https://www.george-smart.co.uk/wordpress/wp-content/uploads/2020/02/m1geo_pfd_1.png "Simulation of PFD")
