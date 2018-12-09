`timescale 1ns / 1ps

module datamem(clock,address, MemWrite, MemRead, WriteData, ReadData);

	input clock;
	input [10:0] address;
	input MemWrite, MemRead;
	input [31:0] WriteData;
    integer i;
	output [31:0] ReadData;

	reg [31:0] Mem[0:1024]; //32 bits memory with 128 entries

	initial begin
	for(i = 0;i<= 1024;i = i + 1)
	    Mem[i] <= 32'b0;
	end

	always @ (negedge clock) begin

		if (MemWrite == 1)
			Mem[address[10:2]] <= WriteData;
	end

  assign ReadData = (MemRead == 1) ? Mem[address[10:2]] : 32'b0;

endmodule
