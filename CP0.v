`timescale 1ns / 1ps

module CP0(
    input clk,
    input rst,
    input we,
    input mfc0,
    input mtc0,
    input [4:0] addr,
    input [4:0] cause,
    input [31:0] data,
    input [31:0] pc,
    input exception,
    input eret,
    output [31:0] status,
    output [31:0] CP0_out,
    output [31:0] epc_out
    );

    reg [31:0] CP0 [0:31];
    reg [31:0] status_tmp;
    assign CP0_out = (mfc0==1) ? CP0[addr] : 32'd0;
    assign epc_out = (exception==1 && eret==1)?CP0[14]:(exception==1 && eret==0)? 32'h00400004: 32'b0 ;
    assign status  = CP0[12];
    integer i;

always @(negedge clk or posedge rst)begin
    if(rst)begin
        for(i=0;i<=11;i=i+1)
            CP0[i]=32'b0;
        CP0[12]={28'b0,4'b1};
        for(i=13;i<=31;i=i+1)
            CP0[i]=32'b0;
    end
    else begin
      if(we==1) begin
        if(!exception) begin
          if(mtc0==1) begin
              CP0[addr]=data;
          end
        end
        else if(exception==1) begin
                status_tmp=CP0[12];
              if(!eret) begin
                CP0[14]=pc;
                CP0[12]={CP0[12],5'b0};
                CP0[13][6:2]=cause;
              end
              else begin
                CP0[12]=status_tmp;
              end
        end
      end
    end
end

endmodule
