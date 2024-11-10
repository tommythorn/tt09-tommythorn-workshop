/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_tommythorn_workshop (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

   parameter	      frequency  = 50_000_000;
   parameter	      bps        =    115_200;

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[7:2] = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
   wire		      _unused = &{ena, clk, rst_n, 1'b0};


   reg [7:0]  transmit_data;
   reg	      we;
   wire	      busy;
   wire	      serial_out;
   wire	      serial_in = ui_in[0];
   wire	      attention;
   wire [7:0] received_data;
   wire	      pdm_out;
   reg [15:0] pdm_level;

   assign uo_out[0] = serial_out;
   assign uo_out[1] = pdm_out;

   always @(posedge clk) begin
      we <= attention & !busy;
      if (attention & !busy) begin
	 transmit_data <= received_data + 1;
	 pdm_level <= {pdm_level[7:0], received_data};
      end

      if (!rst_n) begin
	 we <= 0;
      end
   end

   rs232out #(bps, frequency) rs232out_inst
     (.clock(clk),
      .serial_out(serial_out),
      .transmit_data(transmit_data),
      .we(we),
      .busy(busy));

   rs232in #(bps, frequency) rs232in_inst
     (.clock(clk),
      .serial_in(serial_in),
      .attention(attention),
      .received_data(received_data));

   pdm pdm_inst(.clk(clk),
		.level(pdm_level), 
		.O(pdm_out));
endmodule

`ifdef TEST
module tb;
   reg rst_n = 0;
   reg clk = 1;
   always #5 clk = !clk;

   wire [7:0] ui_in;
   wire [7:0] uo_out;

   tt_um_tommythorn_workshop dut(.clk(clk), .rst_n(rst_n), .ui_in(ui_in), .uo_out(uo_out));

   initial begin
      $dumpfile("demo.vcd");
      $dumpvars();
      rst_n = 1;
      #1000 $finish;
      end
endmodule
`endif
