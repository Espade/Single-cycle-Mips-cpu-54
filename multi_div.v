`timescale 1ns / 1ps

module multi_div(
  input mul,
  input multu,
  input div,
  input divu,
  input [31:0] a,//rsdata
  input [31:0] b,//rtdata
  output [31:0] lo,
  output [31:0] hi,
  output reg [31:0] muldata
    );
    integer i;
    reg [63:0] ex_a;
    reg [63:0] ex_b;
    reg [1:0] OP;
    reg [63:0] zmul;
    reg [63:0] zmultu;
    reg [63:0] transition_1;
    reg [63:0] transition_2;
    wire [31:0] dividend = a;
    wire [31:0] divisor  = b;
    wire [31:0] q_div;
    wire [31:0] r_div;
    wire [31:0] q_divu;
    wire [31:0] r_divu;
    ////////////////////////div/////////////////////////////////////////////////
    reg [4:0]  count_div;
    reg [31:0] reg_q_div;
    reg [31:0] reg_r_div;
    reg [31:0] reg_b_div;
    reg r_sign_div;

    wire op = dividend[31]^divisor[31];
    wire [31:0] opps_dividend;
    wire [31:0] opps_divisor;
    assign opps_dividend = (dividend[31] == 1) ? ~(dividend - 1) : dividend;
    assign opps_divisor  = (divisor[31]  == 1) ? ~(divisor  - 1) : divisor;
    wire [31:0] transition_q;
    wire [31:0] transition_r;
    assign transition_r = r_sign_div? reg_r_div + reg_b_div : reg_r_div;
    assign transition_q = reg_q_div;
    wire [32:0] sub_add_div = r_sign_div?({reg_r_div,transition_q[31]}+{1'b0,reg_b_div}):({reg_r_div,transition_q[31]}-{1'b0,reg_b_div});
    assign q_div = (op == 1) ? (~transition_q + 1) : transition_q;
    assign r_div = (dividend[31] == 1) ? (~transition_r + 1) : transition_r;
    //////////////////////////div_end///////////////////////////////////////////
    //////////////////////////divu//////////////////////////////////////////////
    reg [4:0]  count_divu;
    reg [31:0] reg_q_divu;
    reg [31:0] reg_r_divu;
    reg [31:0] reg_b_divu;
    reg r_sign_divu;
    wire [32:0] sub_add_divu = r_sign_divu?({reg_r_divu,q_divu[31]}+{1'b0,reg_b_divu}):({reg_r_divu,q_divu[31]}-{1'b0,reg_b_divu});
    assign r_divu = r_sign_divu? reg_r_divu + reg_b_divu : reg_r_divu;
    assign q_divu = reg_q_divu;
    //////////////////////////divu_end//////////////////////////////////////////
    assign lo = (multu == 1) ? zmultu[31:0 ]:(div == 1) ? q_div :(divu == 1)?q_divu:32'b0;
    assign hi = (multu == 1) ? zmultu[63:32]:(div == 1) ? r_div :(divu == 1)?r_divu:32'b0;
always @(*)begin
  if(mul == 1) begin
      ex_a = {{32{a[31]}},a};
      ex_b = {{32{b[31]}},b};
      OP = {a[31],b[31]};
      case(OP)
      2'b11:begin
          ex_a = ~ex_a;
          ex_b = ~ex_b;
          ex_a = ex_a + 1;
          ex_b = ex_b + 1;
          end
      2'b01:begin
          ex_b = ~ex_b;
          ex_b = ex_b + 1;
          end
      2'b10:begin
          ex_a = ~ex_a;
          ex_a = ex_a + 1;
          end
      endcase
      zmul = 64'b0;
      for(i = 0;i<32;i=i+1)
             begin
              if(ex_b[0] == 0)
                  begin
                  ex_a = ex_a << 1;
                  ex_b = ex_b >> 1;
                  end
             else
                  begin
                  zmul = zmul + ex_a;
                  ex_a = ex_a << 1;
                  ex_b = ex_b >> 1;
                  end
             end
      if(OP == 2'b01 || OP == 2'b10) begin
          zmul = ~zmul;
          zmul = zmul + 1;
      end
    muldata = zmul[31:0];
  end//if mul == 1

  else if(multu == 1) begin
      transition_1 = {32'b0,a};
      transition_2 = {32'b0,b};
      zmultu = 64'b0;
      for(i = 0;i<32;i = i+1) begin
            if(b[i]==0) begin
                transition_1 = transition_1 << 1;
                transition_2 = transition_2 >> 1;
            end
            else begin
                zmultu = zmultu + transition_1;
                transition_1 = transition_1 << 1;
                transition_2 = transition_2 >> 1;
            end
      end
      
  end //if multu == 1

  else if(divu == 1) begin

      reg_r_divu = 32'b0;
      r_sign_divu = 0;
      reg_q_divu = dividend;
      reg_b_divu = divisor;

    for(i = 0;i<32;i=i+1)begin
      reg_r_divu = sub_add_divu[31:0];
      r_sign_divu = sub_add_divu[32];
      reg_q_divu = {reg_q_divu[30:0],~sub_add_divu[32]};
    end

  end

  else if(div == 1) begin

      reg_r_div = 32'b0;
      r_sign_div = 0;
      reg_q_div = opps_dividend;
      reg_b_div = opps_divisor;

    for(i = 0;i<32;i=i+1)begin
      reg_r_div = sub_add_div[31:0];
      r_sign_div = sub_add_div[32];
      reg_q_div = {reg_q_div[30:0],~sub_add_div[32]};
    end
  end

end
endmodule
