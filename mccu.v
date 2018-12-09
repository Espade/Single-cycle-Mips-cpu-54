`timescale 1ns / 1ps

module mccu(op, func, instr_25_21, rdata1,rdata2,write_reg, DM_R, DM_W,DM_ext, rf_we, mux3, mux4, mux2, aluc, mux1, mux5,jal,
	          s_ext,hilo_W,mfhi,mflo,mthi,mtlo,div,divu,multu,mul,exception,mtc0,mfc0,cause,CP0_we,eret);
	input [5:0] op,func;
	input [4:0] instr_25_21;
	input [31:0] rdata1;
	input [31:0] rdata2;
	output DM_R,DM_W,write_reg ,rf_we,mux3,mux5,mux4,jal,hilo_W,mfhi,mflo,mthi,mtlo,div,divu,multu,mul,exception,mtc0,mfc0,CP0_we,eret;
  //rf_we = write regfile�ߵ�ƽд�����ݣ��͵�ƽ��������
  output [1:0] s_ext;//s_ext indicates zero extend or signed extend
	output [4:0] aluc;//aluc indicates the operation of alu
	output [1:0] mux1;//mux1 indicates the source of pc
	output [1:0] mux2;//mux2 indicates the source of write_reg_data
	output [2:0] DM_ext;
	output [4:0] cause;
	wire r_type = ~|op;
	wire x_type = ~op[5] & op[4]  &  op[3] &  op[2] & ~op[1] & ~op[0];
	assign write_reg = (r_type == 1 || x_type == 1) ? 1 : 0;
	wire i_or        = r_type &  func[5] & ~func[4] & ~func[3] &  func[2] & ~func[1] &  func[0] ;
	wire i_xor       = r_type &  func[5] & ~func[4] & ~func[3] &  func[2] &  func[1] & ~func[0] ;
  wire i_nor       = r_type &  func[5] & ~func[4] & ~func[3] &  func[2] &  func[1] &  func[0] ;
	wire i_add       = r_type &  func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0] ;
	wire i_addu      = r_type &  func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] &  func[0] ;
	wire i_sub       = r_type &  func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0] ;
	wire i_subu      = r_type &  func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] &  func[0] ;
	wire i_and       = r_type &  func[5] & ~func[4] & ~func[3] &  func[2] & ~func[1] & ~func[0] ;
  wire i_slt       = r_type &  func[5] & ~func[4] &  func[3] & ~func[2] &  func[1] & ~func[0] ;
  wire i_sltu      = r_type &  func[5] & ~func[4] &  func[3] & ~func[2] &  func[1] &  func[0] ;
	wire i_sll       = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0] ;
	wire i_srl       = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0] ;
	wire i_sra       = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] &  func[0] ;
  wire i_sllv      = r_type & ~func[5] & ~func[4] & ~func[3] &  func[2] & ~func[1] & ~func[0] ;
  wire i_srlv      = r_type & ~func[5] & ~func[4] & ~func[3] &  func[2] &  func[1] & ~func[0] ;
  wire i_srav      = r_type & ~func[5] & ~func[4] & ~func[3] &  func[2] &  func[1] &  func[0] ;
	wire i_jr        = r_type & ~func[5] & ~func[4] &  func[3] & ~func[2] & ~func[1] & ~func[0] ;
	///////////////  //////////extra R-type///////////////////////////////////////////////////////
	wire i_div       = r_type & ~func[5] &  func[4] &  func[3] & ~func[2] &  func[1] & ~func[0] ;
	wire i_multu     = r_type & ~func[5] &  func[4] &  func[3] & ~func[2] & ~func[1] &  func[0] ;
	wire i_divu      = r_type & ~func[5] &  func[4] &  func[3] & ~func[2] &  func[1] &  func[0] ;
	wire i_syscall   = r_type & ~func[5] & ~func[4] &  func[3] &  func[2] & ~func[1] & ~func[0] ;
	wire i_teq       = r_type &  func[5] &  func[4] & ~func[3] &  func[2] & ~func[1] & ~func[0] ;
	wire i_break     = r_type & ~func[5] & ~func[4] &  func[3] &  func[2] & ~func[1] &  func[0] ;
	wire i_mfhi      = r_type & ~func[5] &  func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0] ;
	wire i_mflo      = r_type & ~func[5] &  func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0] ;
	wire i_mthi      = r_type & ~func[5] &  func[4] & ~func[3] & ~func[2] & ~func[1] &  func[0] ;
	wire i_mtlo      = r_type & ~func[5] &  func[4] & ~func[3] & ~func[2] &  func[1] &  func[0] ;
	wire i_jalr      = r_type & ~func[5] & ~func[4] &  func[3] & ~func[2] & ~func[1] &  func[0] ;
	wire i_clz       = x_type &  func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0] ;
	wire i_mul       = x_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] &  func[1] & ~func[0] ;
	///////////////  //////////end R-type/////////////////////////////////////////////////////////
	wire i_addi      = ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0];
  wire i_addiu     = ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] &  op[0];
	wire i_andi      = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0];
	wire i_ori       = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] &  op[0];
	wire i_xori      = ~op[5] & ~op[4] &  op[3] &  op[2] &  op[1] & ~op[0];
	wire i_lw        =  op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] &  op[0];
	wire i_sw        =  op[5] & ~op[4] &  op[3] & ~op[2] &  op[1] &  op[0];
	wire i_beq       = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] & ~op[0];
	wire i_bne       = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] &  op[0];
  wire i_slti      = ~op[5] & ~op[4] &  op[3] & ~op[2] &  op[1] & ~op[0];
  wire i_sltiu     = ~op[5] & ~op[4] &  op[3] & ~op[2] &  op[1] &  op[0];
	wire i_lui       = ~op[5] & ~op[4] &  op[3] &  op[2] &  op[1] &  op[0];
	wire i_j         = ~op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] & ~op[0];
	wire i_jal       = ~op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] &  op[0];
	///////////////  //////////extra I-type/////////////////////////////////
	wire i_lbu       =  op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] & ~op[0];
  wire i_lb        =  op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];
	wire i_lhu       =  op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] &  op[0];
  wire i_lh        =  op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] &  op[0];
	wire i_sb        =  op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0];
	wire i_sh        =  op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] &  op[0];
	wire i_bgez      = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] &  op[0];
	///////////////  //////////end I-type///////////////////////////////////
	wire i_eret      = ~op[5] &  op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0] & ~func[5] &  func[4] &  func[3] & ~func[2] & ~func[1] & ~func[0] ;
	wire i_mfc0      = ~op[5] &  op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0] & ~func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0]
	                          & ~instr_25_21[2];
	wire i_mtc0      = ~op[5] &  op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0] & ~func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0]
	                          &  instr_25_21[2];
	///////////////  //////////end COP0///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	assign s_ext[0]  = i_andi |i_ori    |i_xori |i_lui ;
  assign s_ext[1]  = i_addi |i_addiu  |i_lw   |i_sw  |i_beq  |i_bne  |i_slti  |i_sltiu |i_lbu  |i_lb    |i_lhu  |i_lh  |i_sb |i_sh |i_bgez;
	assign aluc[0]   = i_sub  |i_subu   |i_or   |i_nor |i_slt  |i_srl  |i_srlv  |i_ori   |i_slti |i_clz;
	assign aluc[1]   = i_add  |i_sub    |i_xor  |i_nor |i_slt  |i_sltu |i_sll   |i_sllv  |i_addi |i_xori  |i_slti |i_sltiu;
	assign aluc[2]   = i_and  |i_or     |i_xor  |i_nor |i_sll  |i_srl  |i_sra   |i_sllv  |i_srlv |i_srav  |i_andi |i_ori |i_xori;
	assign aluc[3]   = i_slt  |i_sltu   |i_sll  |i_srl |i_sra  |i_sllv |i_srlv  |i_srav  |i_slti |i_sltiu |i_lui ;
	assign aluc[4]   = i_clz;
 	assign mux1[0]   = ((rdata1==rdata2) & i_beq) | ((rdata1!=rdata2) & i_bne)  |i_j |i_jal |(!rdata1[31] & i_bgez);
	assign mux1[1]   = i_jr   |i_j     |i_jal  |i_jalr;

	assign rf_we     = i_add  |i_addu   |i_sub   |i_subu |i_and |i_or |i_xor |i_nor |i_slt |i_sltu |
				             i_sll  |i_srl    |i_sra   |i_sllv |i_srlv |i_srav |i_addi |i_addiu |i_andi |
				             i_ori  |i_xori   |i_lw    |i_slti |i_sltiu |i_lui |i_jal |i_mul |
									 	 i_clz  |i_mfhi   |i_mflo  |i_lbu  |i_lb |i_lh |i_lhu |i_jalr |i_mfc0;
	assign mux4      = i_lui  |i_addi   |i_addiu |i_andi |i_ori |i_xori |i_lw |i_sw |i_slti |i_sltiu |i_lb |i_lbu |i_lh |i_lhu |i_sb |i_sh;
	assign mux3      = i_sll  |i_srl    |i_sra;
	assign mux5      = i_jal  |i_jalr;//1 --> write
	assign jal       = i_jal;
	assign mux2[0]   = i_lw   |i_lbu    |i_lb |i_lh |i_lhu  |i_mfc0 ;
	assign mux2[1]   = i_mfhi |i_mflo   |i_mfc0;
	assign DM_W      = i_sw   |i_sh     |i_sb;
	assign DM_R      = i_lw   |i_lbu    |i_lb |i_lh |i_lhu;
	assign DM_ext[0] = i_lb   |i_lh ; //lbu-->00 lb-->01 lhu-->10 lh-->11
	assign DM_ext[1] = i_lhu  |i_lh ;
	assign DM_ext[2] = i_lw;
	assign mtc0      = i_mtc0;
	assign mfc0      = i_mfc0;
	assign exception = i_syscall |i_break |(i_teq&(rdata1==rdata2)) |i_eret;
	assign hilo_W    = i_mthi |i_mtlo |i_div |i_divu |i_multu;
	assign mfhi      = i_mfhi;
	assign mflo      = i_mflo;
	assign mthi      = i_mthi;
	assign mtlo      = i_mtlo;
	assign div       = i_div;
	assign divu      = i_divu;
	assign multu     = i_multu;
	assign mul       = i_mul;
	assign cause[4]  = 1'b0;
	assign cause[3]  = i_break | i_syscall | (i_teq & rdata1 == rdata2);
	assign cause[2]  = i_teq;
	assign cause[1]  = 1'b0;
	assign cause[0]  = i_break | (i_teq & rdata1 == rdata2);
  assign CP0_we    = i_mfc0  | i_mtc0 |i_syscall |i_break |(i_teq&(rdata1==rdata2)) |i_eret;
	assign eret      = i_eret;
endmodule
