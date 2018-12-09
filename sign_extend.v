`timescale 1ns / 1ps
module sign_extend(
  input [15:0] in_data,
  input [1:0] s_ext,
  output reg [31:0] out_data
    );
  always @ ( * ) begin
    case(s_ext)
    2'b01:out_data <= {16'b0,in_data};
    2'b10:out_data <= {{16{in_data[15]}},in_data};
    endcase
  end
endmodule
