`timescale 1ns / 1ps

module cpu(
    input clk,
    input rst,
    input [31:0]inst,
    output [31:0]pc,
    output [31:0]addr
    );
    wire DM_R,DM_W,write_reg ,rf_we,mux3,mux4,mux5,jal,hilo_W,mfhi,mflo,mthi,mtlo,div,divu,multu,mul,exception,mtc0,mfc0,CP0_we,eret;
    wire [4:0]  write_reg_addr;
    wire [4:0]  cause;
    wire [31:0] rdata;
    wire [31:0] wdata;
    wire [31:0] pcin;
    wire [31:0] rdata1;
    wire [31:0] rdata2;
    wire [31:0] write_reg_data;
    wire [31:0] extend32_1;
    wire [31:0] extend32_2;
    wire [31:0] alu_a;
    wire [31:0] alu_b;
    wire [31:0] alu_r;
    wire [31:0] shiftout;
    wire [31:0] mux2_out;
    wire [31:0] append;
    wire [31:0] add_out3;
    wire [1:0] s_ext;//s_ext indicates zero extend or signed extend
    wire [4:0] aluc;//aluc indicates the operation of alu
    wire [1:0] mux1;//mux1 indicates the source of pc
    wire [1:0] mux2;//mux2 indicates the source of write_reg_data
    wire [2:0] DM_ext;
    wire [31:0] pcplus_4;
    wire [31:0] dm_addr;
    wire [31:0] hilo_out;
    wire [31:0] exc_addr;
    wire [31:0] status;
    wire [31:0] lodata;
    wire [31:0] hidata;
    wire [31:0] muldata;
    wire [31:0] DM_ext_out;
    wire [31:0] CP0_out;

    assign dm_addr = addr - 32'h10010000;
    assign write_reg_addr = (jal == 1) ? 5'b11111 : ((write_reg == 1)?inst[15:11]:inst[20:16]);
    assign extend32_2 = {27'b0,inst[10:6]};
    assign append = {pc[31:28],inst[25:0],2'b0};
    assign addr = alu_r;
    assign wdata = rdata2;
  //connection of the resource of pc
  pc pc_0(clk,rst,(exception==1)?exc_addr:pcin,pc);

  //connection of the control unit
  mccu mccu(inst[31:26],inst[5:0],inst[25:21],rdata1,rdata2,write_reg, DM_R, DM_W,DM_ext, rf_we, mux3, mux4, mux2, aluc, mux1, mux5,jal,
  	          s_ext,hilo_W,mfhi,mflo,mthi,mtlo,div,divu,multu,mul,exception,mtc0,mfc0,cause,CP0_we,eret);

  //the address of writing regfiles

//the output data from regfiles
  regfile  cpu_ref(clk,rst,rf_we,inst[25:21],inst[20:16],write_reg_addr,write_reg_data,rdata1,rdata2);
  datamem  dmem(clk,dm_addr[10:0],DM_W,DM_R,wdata,rdata);
  hilo     hilo(clk,rst,hilo_W,mtlo,mthi,mflo,mfhi,multu,div,divu,(mtlo==1)?rdata1:lodata,(mthi==1)?rdata1:hidata,hilo_out);
  CP0      CP0(clk,rst,CP0_we,mfc0,mtc0,inst[15:11],cause,rdata2,pc,exception,eret,status,CP0_out,exc_addr);

  multi_div md(,mul,multu,div,divu,rdata1,rdata2,lodata,hidata,muldata);
  //extend immediate
  DM_extend D_e(DM_ext,rdata,DM_ext_out);
  sign_extend s_e(inst[15:0],s_ext,extend32_1);

  //extend sll/srl/sra instruction

  mux2x32 mux_4(rdata2,extend32_1,mux4,alu_b);
  mux2x32 mux_3(rdata1,extend32_2,mux3,alu_a);

  alu alu(alu_a,alu_b,aluc,alu_r);

  shift2 s_two(extend32_1,shiftout);

  add a_1(pc,32'd4,pcplus_4);
  add a_3(shiftout,pcplus_4,add_out3);

  mux4x32 mux_2(alu_r,DM_ext_out,(mul==1)?muldata:hilo_out,CP0_out,mux2,mux2_out);
  mux2x32 mux_5((mul==1)?muldata:mux2_out,pcplus_4,mux5,write_reg_data);

  mux4x32 mux_1(pcplus_4,add_out3,rdata1,append,mux1,pcin);

endmodule
