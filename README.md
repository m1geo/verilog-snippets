# verilog-snippets
This respository is a collection of snippets or modules in Verilog to serve some purpose. They are free to be used however you'd like. They come with no implied fitness for purpose or warranty of any kind.

Pull requests are accepted for improvements on code.

# MAX6951 8-digit 7-segment LED driver IC
This code takes a 32-bit number and displays it (in hex) on eight 7-segment displays. It uses 2 state machines, one to send the data in SPI-like fashion and another to control which registers to write.
