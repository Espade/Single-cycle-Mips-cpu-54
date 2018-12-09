`timescale 1ns / 1ps

module mux2x32 (a0,a1,s,y);
	input [31:0] a0,a1; // a0,a1: 32-bit
	input s; // s: 1-bit
	output [31:0] y; // y: 32-bit
	assign y = (s == 1) ? a1 : a0; // like C
endmodule
