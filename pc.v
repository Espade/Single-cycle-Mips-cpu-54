`timescale 1ns / 1ps
module pc(clock, reset, PCin, PCout);

	input clock, reset;
	input [31:0] PCin;

	output reg [31:0] PCout;

	always @(posedge clock or posedge reset) begin
		if (reset == 1)
			PCout <= 32'h00400000;
		else
			PCout <= PCin;
	end
endmodule
