`timescale 1ns / 1ps
module mux4x32(a0,a1,a2,a3,s,y);
	input [31:0] a0,a1,a2,a3; // a0,a1: 32-bit
	input [1:0] s; // s: 1-bit
	output reg [31:0] y; // y: 32-bit
	always @(*)
	begin
		case(s)
		2'b00: y = a0;
		2'b01: y = a1;
		2'b10: y = a2;
		2'b11: y = a3;
		endcase
	end
endmodule
