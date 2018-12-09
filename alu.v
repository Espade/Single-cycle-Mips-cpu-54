`timescale 1ns / 1ps

module logical(
  input [31:0] a,
  input [31:0] b,
  input [1:0] aluc,
  output reg [31:0] r,
  output zero,
  output negative
    );
    assign zero = (r == 32'b0) ? 1'b1 : 1'b0;
    assign negative = r[31];

    always @(*)
    begin
      case(aluc)
        2'b00:r <= a & b;
        2'b01:r <= a | b;
        2'b10:r <= a ^ b;
        2'b11:r <= ~(a | b);
      endcase
    end
endmodule
///////////////////////////////////////////////////
module comparer(
  input [31:0] a,
  input [31:0] b,
  input [1:0] aluc,
  output reg [31:0] r,
  output reg zero,
  output reg carry,
  output reg negative
    );
    always @(*)
    begin
      case(aluc)
        2'b11: begin r <= ( $signed(a) < $signed(b) ) ? 1 : 0;negative <= r;zero <= ( $signed(a) == $signed(b) ) ? 1 : 0;end
        2'b10: begin r <= ( a < b ) ? 1 : 0;negative <= r[31];zero <= ( a ==  b ) ? 1 : 0;carry <= r;end
        default: r <= {b[15:0],16'b0};
      endcase
    end
endmodule
/////////////////////////////////////////////////
module arithmetic(
  input [31:0] a,
  input [31:0] b,
  input [1:0] aluc,
  output reg [31:0] r,
  output zero,
  output reg carry,
  output reg negative,
  output reg overflow
    );
    assign zero = (r == 32'b0) ? 1'b1 : 1'b0;
    always @(*)
    begin
        case(aluc)
          2'b00:       begin {carry, r} <= {1'b0,a} + {1'b0,b};negative <= r[31];end                                                         //addu
          2'b10:
          begin
          r <= a + b;
          overflow <= ({a[31],b[31],r[31]} == 3'b001 || {a[31],b[31],r[31]} == 3'b110) ? 1 : 0;
          negative <= r[31];
          end
          2'b01:       begin {carry, r} <= {1'b0,a} - {1'b0,b};negative <= r[31];end                                                        //subu
          2'b11:
          begin
          r <= a - b;
          overflow <= ({a[31],b[31],r[31]} == 3'b011 || {a[31],b[31],r[31]} == 3'b100) ? 1 : 0;
          negative <= r[31];
          end
        endcase
    end
endmodule
/////////////////////////////////////////////////////////
module shift(
  input [31:0] a,
  input [31:0] b,
  input [1:0] aluc,
  output reg [31:0] r,
  output zero,
  output reg carry
    );
    assign zero = (r == 32'b0) ? 1'b1 : 1'b0;
    always @(*)
    begin
      case(aluc)
        2'b00: begin r <= $signed(b) >>> a ;carry <= b[a-1];end
        2'b01: begin r <= b >> a;carry <= b[a-1];end
        default:begin r <= b << a;carry <= b[32-a];end
      endcase
    end
endmodule
///////////////////////////////////////////////////////////
module alu(
  input [31:0] a,
  input [31:0] b,
  input [4:0] aluc,
  output reg [31:0] r,
  output reg zero,
  output reg carry,
  output reg negative,
  output reg overflow
    );
    reg [5:0] tmp;
    parameter [1:0] C_arithmetic = 2'b00,
                    C_logical    = 2'b01,
                    C_comparer   = 2'b10,
                    C_shift      = 2'b11;

    wire [31:0] arithmetic_r,logical_r,comparer_r,shift_r;
    wire arithmetic_zero,arithmetic_carry,arithmetic_negative,a_overflow;
    wire comparer_zero,comparer_carry,comparer_negative;
    wire logical_zero,logical_negative;
    wire shift_zero,shift_carry;

    arithmetic arithmetic_inst(a,b,aluc[1:0],arithmetic_r,arithmetic_zero,arithmetic_carry,arithmetic_negative,a_overflow);
    comparer comparer_inst(a,b,aluc[1:0],comparer_r,comparer_zero,comparer_carry,comparer_negative);
    logical logical_inst(a,b,aluc[1:0],logical_r,logical_zero,logic_negative);
    shift shift_inst(a,b,aluc[1:0],shift_r,shift_zero,shift_carry);

    always @(*)
    begin
    if(aluc[4] == 0)begin
      case(aluc[3:2])
        C_arithmetic: begin r <= arithmetic_r; zero <= arithmetic_zero; carry <= arithmetic_carry;negative <= arithmetic_negative;overflow <= a_overflow;end
        C_comparer:   begin r <= comparer_r;   zero <= comparer_zero;  carry <= comparer_carry;negative <= comparer_negative;end
        C_logical:    begin r <= logical_r;    zero <= logical_zero; negative <= logic_negative;  end
        C_shift:      begin r <= shift_r;      zero <= shift_zero; carry <= shift_carry;     end
      endcase
    end
    else if(aluc == 5'b10001)//clz
      begin
      if(a[31])
      tmp=0;
      else if(a[30])
      tmp=1;
      else if(a[29])
      tmp=2;
      else if(a[28])
      tmp=3;
      else if(a[27])
      tmp=4;
      else if(a[26])
      tmp=5;
      else if(a[25])
      tmp=6;
      else if(a[24])
      tmp=7;
      else if(a[23])
      tmp=8;
      else if(a[22])
      tmp=9;
      else if(a[21])
      tmp=10;
      else if(a[20])
      tmp=11;
      else if(a[19])
      tmp=12;
      else if(a[18])
      tmp=13;
      else if(a[17])
      tmp=14;
      else if(a[16])
      tmp=15;
      else if(a[15])
      tmp=16;
      else if(a[14])
      tmp=17;
      else if(a[13])
      tmp=18;
      else if(a[12])
      tmp=19;
      else if(a[11])
      tmp=20;
      else if(a[10])
      tmp=21;
      else if(a[9])
      tmp=22;
      else if(a[8])
      tmp=23;
      else if(a[7])
      tmp=24;
      else if(a[6])
      tmp=25;
      else if(a[5])
      tmp=26;
      else if(a[4])
      tmp=27;
      else if(a[3])
      tmp=28;
      else if(a[2])
      tmp=29;
      else if(a[1])
      tmp=30;
      else if(a[0])
      tmp=31;
      else
      tmp=32;
      r=tmp;
      if(tmp==0)
      zero=1;
      else
      zero=0;
      end
    end

endmodule
