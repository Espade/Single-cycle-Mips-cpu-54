`timescale 1ns / 1ps

module shift2(ShiftIn, ShiftOut);

	input [31:0] ShiftIn;
	output reg [31:0] ShiftOut;
	always @(*)
	begin
	  ShiftOut <= (ShiftIn << 2 );
	end

endmodule
