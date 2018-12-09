`timescale 1ns / 1ps

module sccomp_dataflow(
  input clk_in,
  input reset,
  output [31:0] inst,
  output [31:0] pc,
  output [31:0] addr
    );
    wire [31:0] ip_in = pc - 32'h00400000;
    cpu sccpu(clk_in,reset,inst,pc,addr);
    dist_mem_gen_0 imem(ip_in[31:2],inst);
endmodule
