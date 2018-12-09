`timescale 1ns / 1ps

module add(pcout, shitfout, addout);

	input [31:0] pcout;
	input [31:0] shitfout;

	output reg [31:0] addout;

	always @(*) begin
		addout <= pcout + shitfout;
	end
endmodule
