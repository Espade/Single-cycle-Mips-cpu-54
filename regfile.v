`timescale 1ns / 1ps
module regfile (clk,rst,we,raddr1,raddr2,waddr,wdata,rdata1,rdata2);
	input [4:0] raddr1,raddr2,waddr;
	input [31:0] wdata;
	input we,clk,rst;
	output [31:0] rdata1,rdata2;
	reg [31:0] array_reg[31:0]; // r0 - r31
	integer i;
	assign rdata1 = array_reg[raddr1] ;
	assign rdata2 = array_reg[raddr2] ;
	always @(negedge clk or posedge rst) begin

		if (rst == 1) begin // reset
			for (i=0; i<32; i=i+1)
				array_reg[i] <= 0;
		end else begin
		if (we == 1) // write
			array_reg[waddr] <= wdata;
		end
		array_reg[0] <= 0;
	end

endmodule
