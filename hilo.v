`timescale 1ns / 1ps

module hilo(
input clk,
input rst,
input we,
input mtlo,
input mthi,
input mflo,
input mfhi,
input multu,
input div,
input divu,
input [31:0] a,//rsdata//lo
input [31:0] b,//rtdata//hi
output  [31:0] data_out
);
    reg [31:0] LO;
    reg [31:0] HI;

    assign data_out = (mfhi == 1) ? HI : (( mflo == 1) ? LO : 32'b0);

always @(negedge clk or posedge rst) begin
    if(rst == 1)
        begin
          LO <= 32'h0;
          HI <= 32'h0;
        end
    else begin
      if(we == 1) begin
        if(mtlo == 1)
          LO <= a;
        else if(mthi == 1)
          HI <= b;
        else if(multu || div || divu)
            begin
              LO <= a;
              HI <= b;
            end
       end
    end
 end

endmodule
