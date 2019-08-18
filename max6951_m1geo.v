`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: M1GEO
// Engineer: George Smart
// Web: https://www.george-smart.co.uk   or   github.com/m1geo
// 
// Create Date: 18.08.2019 20:05:11
// Module Name: max6951_m1geo
// 
// Revision: 1.00
// Comments: Simple two-stage FSM to write to MAX6951.
//             'bit_fsm_counter' iterates over the number of bits sending data.
//             'ctrl_fsm_counter' iterates over the messages to send.
//             Tested working on Xilinx AC7A35T Arty with MAX6951 and 8 digits.
// 
//////////////////////////////////////////////////////////////////////////////////

module max6951_m1geo
    (
    input clk,         // 66.6667 MHz positive edge
    input resetn,      // negative edge async reset
    input [31:0] data, // to display. 0xDEADBEEF will put DEADBEEF on the display
    input [7:0] dps,   // display 7:0 decimal points.
    output DI_nCS, //
    output DI_DTA, // 3 lines to display controller
    output DI_CKS  //
    );
    
    ////
    //// Slow Clock (div 8)
    ////   slow_clock must be less 26 MHz. See datasheet for timings. 
    ////
    wire slow_clock;
    reg [2:0] clk_div;
    always @(posedge clk or negedge resetn) begin
        if (~resetn)
            clk_div <= 'b0;
        else
            clk_div <= clk_div + 1'b1;
    end
    assign slow_clock = clk_div[2]; // Divided clock twice as much as that's what you were doing manually
    
    // I like naming my state machine states
    parameter s_IDLE = 0;
    parameter s_SENDING = 1;
    parameter s_DONE = 2;

    ////
    //// Bit FSM
    ////     Code toggles "update_data" when "reg_data" can be updated.
    ////     Use this 'clock' to run another FSM to setup the registers.
    ////
    reg [15:0] reg_data;        // data to write to the display
    reg [15:0] reg_data_t;         // holds the current data being sent while sending, when idle holds the last value sent
    reg [2:0] bit_fsm_state;  // holds states.
    reg [3:0] r_bitCounter; //which bit is being currently sent
    wire update_data;

    // update_data pulsed high for a single slow clock cycle when data has finished sending
    assign update_data = (bit_fsm_state == s_DONE);

    // clock is clocking out data as long as we are not idle
    assign DI_CKS = (bit_fsm_state == s_SENDING);

    // if we are sending, send the data bit indicated by r_bitCounter, otherwise send 0
    assign DI_DTA = (bit_fsm_state == s_SENDING) ? reg_data_t[r_bitCounter]: 1'b0;


    always @(negedge slow_clock or negedge resetn) begin
        if (~resetn) begin
            bit_fsm_state <= S_IDLE;
            reg_data_t <= 'b0;
        end else begin
        
            case (bit_fsm_state)
                s_IDLE: begin
                    if (reg_data != reg_data_t) begin
                        // We have new data to send
                        reg_data_t <= reg_data;
                        bit_fsm_state <= s_SENDING; 
                        r_bitCounter <= 4'd15;
                    end else begin
                        reg_data_t <= reg_data_t;
                        bit_fsm_state <= s_IDLE;
                        r_bitCounter <= 4'b0;
                    end
                end

                s_SENDING: begin
                    if (r_bitCounter == 0) begin
                        bit_fsm_state <= s_DONE;
                        r_bitCounter <= 4'b0;
                    end else begin
                        bit_fsm_state <= s_SENDING;
                        r_bitCounter <= r_bitCounter - 1;
                    end
                end

                s_DONE: begin
                    // single iteration in this state to pulse update_data
                    bit_fsm_state <= s_IDLE;
                end

            endcase
        end
    end
    
    ////
    //// Control FSM
    ////
    reg [3:0] ctrl_fsm_counter; // holds states
    always @(posedge update_data or negedge resetn) begin
        if (~resetn)
            ctrl_fsm_counter <= 'b0; // from reset, send everything.
        else begin
            if (ctrl_fsm_counter >= 11) // once we've got to the end, go back to 4. Just update digits.
                ctrl_fsm_counter <= 'h4;
            else
                ctrl_fsm_counter <= ctrl_fsm_counter + 1'b1;
        end
        
        case (ctrl_fsm_counter)
            // control registers updated
            0 :  reg_data <= {8'h04, 8'h01}; // Config Reg:     basic on    (addr: 0x04, data: 0x01)
            1 :  reg_data <= {8'h02, 8'h0F}; // Brightness Reg: full bright (addr: 0x02, data: 0x0F)
            2 :  reg_data <= {8'h03, 8'h07}; // Scan Reg:       8 digits    (addr: 0x03, data: 0x07)
            3 :  reg_data <= {8'h01, 8'hFF}; // Decode Reg:     all hex     (addr: 0x01, data: 0xFF)
            // digits registers updated            
            4 :  reg_data <= {8'h67, dps[0], 3'h0, data[3:0]};
            5 :  reg_data <= {8'h66, dps[1], 3'h0, data[7:4]};
            6 :  reg_data <= {8'h65, dps[2], 3'h0, data[11:8]};
            7 :  reg_data <= {8'h64, dps[3], 3'h0, data[15:12]};
            8 :  reg_data <= {8'h63, dps[4], 3'h0, data[19:16]};
            9 :  reg_data <= {8'h62, dps[5], 3'h0, data[23:20]};
            10 : reg_data <= {8'h61, dps[6], 3'h0, data[27:24]};
            11 : reg_data <= {8'h60, dps[7], 3'h0, data[31:28]};
            default : reg_data <= {8'h60, 8'h8F}; // on error send "F."
        endcase
    end
endmodule
