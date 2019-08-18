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
    output reg DI_nCS, //
    output reg DI_DTA, // 3 lines to display controller
    output reg DI_CKS  //
    );
    
    ////
    //// Slow Clock (div 4)
    ////   slow_clock must be less 26 MHz. See datasheet for timings. 
    ////
    wire slow_clock;
    reg [1:0] clk_div;
    always @(posedge clk or negedge resetn) begin
        if (~resetn)
            clk_div <= 'b0;
        else
            clk_div <= clk_div + 1'b1;
    end
    assign slow_clock = clk_div[1];
    
    ////
    //// Bit FSM
    ////     Code toggles "update_data" when "reg_data" can be updated.
    ////     Use this 'clock' to run another FSM to setup the registers.
    ////
    reg [15:0] reg_data;        // data to write to the display
    reg [15:0] reg_data_t;         // temporary, only updated when bit_fsm_counter is ready
    reg [5:0] bit_fsm_counter;  // holds states.
    reg update_data;
    always @(posedge slow_clock or negedge resetn) begin
        if (~resetn) begin
            bit_fsm_counter <= 'b0;
            reg_data_t <= 'b0;
        end else begin
        if (bit_fsm_counter >= 33)
            bit_fsm_counter <= 'b0;
        else
            bit_fsm_counter <= bit_fsm_counter + 1'b1;
        end
        
        case (bit_fsm_counter)
            default : begin // reset state, ensure clock low
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b1;
                DI_DTA <= 1'b0;
                reg_data_t <= reg_data;
                update_data <= 1'b0;
            end
            1 : begin // take low low, set data 15
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[15];
            end
            2 : begin // clock in data 15
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[15];
            end
            3 : begin // take low low, set data 14
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[14];
            end
            4 : begin // clock in data 14
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[14];
            end
            5 : begin // take low low, set data 13
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[13];
            end
            6 : begin // clock in data 13
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[13];
            end
            7 : begin // take low low, set data 12
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[12];
            end
            8 : begin // clock in data 12
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[12];
            end
            9 : begin // take low low, set data 11
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[11];
            end
            10 : begin // clock in data 11
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[11];
            end
            11 : begin // take low low, set data 10
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[10];
            end
            12 : begin // clock in data 10
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[10];
            end
            13 : begin // take low low, set data 9
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[9];
            end
            14 : begin // clock in data 9
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[9];
            end
            15 : begin // take low low, set data 8
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[8];
            end
            16 : begin // clock in data 8
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[8];
            end
            17 : begin // take low low, set data 7
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[7];
            end
            18 : begin // clock in data 7
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[7];
            end
            19 : begin // take low low, set data 6
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[6];
            end
            20 : begin // clock in data 6
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[6];
            end
            21 : begin // take low low, set data 5
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[5];
            end
            22 : begin // clock in data 5
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[5];
            end
            23 : begin // take low low, set data 4
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[4];
            end
            24 : begin // clock in data 4
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[4];
            end
            25 : begin // take low low, set data 3
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[3];
            end
            26 : begin // clock in data 3
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[3];
            end
            27 : begin // take low low, set data 2
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[2];
            end
            28 : begin // clock in data 2
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[2];
            end
            29 : begin // take low low, set data 1
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[1];
            end
            30 : begin // clock in data 1
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[1];
            end
            31 : begin // take low low, set data 0
                DI_CKS <= 1'b0;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[0];
            end
            32 : begin // clock in data 0
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b0;
                DI_DTA <= reg_data_t[0];
            end
            33 : begin // latch data in, nCS high
                DI_CKS <= 1'b1;
                DI_nCS <= 1'b1;
                DI_DTA <= 1'b0;
                update_data <= 1'b1;
            end
        endcase
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
