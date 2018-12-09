`timescale 1ns / 1ps

module DM_extend(
  input [2:0] DM_ext,
  input [31:0] rdata,
  output reg [31:0] DM_ext_out
    );
  always @ ( * ) begin
      case(DM_ext)
      3'b000:DM_ext_out <= {24'b0,rdata[7:0]};
      3'b001:DM_ext_out <= {{24{rdata[7]}},rdata[7:0]};
      3'b010:DM_ext_out <= {18'b0,rdata[15:0]};
      3'b011:DM_ext_out <= {{18{rdata[15]}},rdata[15:0]};
      3'b100:DM_ext_out <= rdata;
      endcase
  end
endmodule
