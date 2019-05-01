// Name: Nathan Ackermann, Zhe Deng
// BU ID: U10490015, U16716991
// EC413 Project: Decode Module

module decode #(
  parameter ADDRESS_BITS = 16
) (
  // Inputs from Fetch
  input [ADDRESS_BITS-1:0] PC,
  input [31:0] instruction,

  // Inputs from Execute/ALU
  input [ADDRESS_BITS-1:0] JALR_target,
  input branch,

  // Outputs to Fetch
  output next_PC_select,
  output [ADDRESS_BITS-1:0] target_PC,

  // Outputs to Reg File
  output [4:0] read_sel1,
  output [4:0] read_sel2,
  output [4:0] write_sel,
  output wEn,

  // Outputs to Execute/ALU
  output branch_op, // Tells ALU if this is a branch instruction
  output [31:0] imm32,
  output [1:0] op_A_sel,
  output op_B_sel,
  output [5:0] ALU_Control,

  // Outputs to Memory
  output mem_wEn,

  // Outputs to Writeback
  output wb_sel

);

localparam [6:0]R_TYPE  = 7'b0110011,
                I_TYPE  = 7'b0010011,
                STORE   = 7'b0100011,
                LOAD    = 7'b0000011,
                BRANCH  = 7'b1100011,
                JALR    = 7'b1100111,
                JAL     = 7'b1101111,
                AUIPC   = 7'b0010111,
                LUI     = 7'b0110111;


// These are internal wires that I used. You can use them but you do not have to.
// Wires you do not use can be deleted.
wire[6:0]  s_imm_msb = instruction[31:25];
wire[4:0]  s_imm_lsb = instruction[11:7];
wire[19:0] u_imm = instruction[31:12];
wire[11:0] i_imm_orig = instruction [31:20];
wire[19:0] uj_imm = {{instruction[31]},  {instruction[19:12]}, {instruction[20]}, {instruction[30:21]}};
wire[11:0] s_imm_orig = {s_imm_msb,s_imm_lsb};
wire[12:0] sb_imm_orig = {instruction[31], instruction[7], instruction[30:25], instruction[11:8],1'b0};

wire[31:0] sb_imm_32 = {{19 {sb_imm_orig[12]}}, sb_imm_orig};
wire[31:0] u_imm_32 = {u_imm,{12'd0}};
wire[31:0] i_imm_32 = {{20{i_imm_orig[11]}},i_imm_orig};
wire[31:0] s_imm_32 = {{ 20{s_imm_orig[11]} }   ,s_imm_orig};
wire[31:0] uj_imm_32 = {{11{uj_imm[19]}},{uj_imm[19:0]},{1'd0}};

wire [6:0] opcode;
wire [6:0] funct7;
wire [2:0] funct3;
wire [1:0] extend_sel;
wire [ADDRESS_BITS-1:0] branch_target = PC + sb_imm_32[15:0];
wire [ADDRESS_BITS-1:0] JAL_target = uj_imm_32 + PC;
wire [ADDRESS_BITS-1:0] AUIPC_target = u_imm_32[15:0] + PC;

// Read registers
assign read_sel2  = instruction[24:20];
assign read_sel1  = instruction[19:15];

/* Instruction decoding */
assign opcode = instruction[6:0];
assign funct7 = instruction[31:25];
assign funct3 = instruction[14:12];

/* Write register */
assign write_sel = instruction[11:7];


/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

assign next_PC_select = (branch==1 || opcode==JALR || opcode==JAL)?1:0;
assign target_PC = (opcode == BRANCH)?branch_target:
						 (opcode == JAL)?JAL_target:
						 (opcode == AUIPC)?AUIPC_target:
						 JALR_target;
assign wEn=(opcode==BRANCH ||opcode == STORE)?0:1;
assign branch_op = (opcode==BRANCH)?1:0;
assign imm32 = (opcode==BRANCH)?sb_imm_32:
					(opcode==AUIPC || opcode==LUI)?u_imm_32:
					(opcode==I_TYPE || opcode==LOAD||opcode==JALR)?i_imm_32:
					(opcode==STORE)?s_imm_32:
					(opcode==JAL)?uj_imm_32:
					32'd0;
assign op_A_sel = (opcode == AUIPC) ? 2'd1 : // selects PC
						(opcode == JALR || opcode == JAL) ? 2'd2: // selects PC +4
						2'd0; // selects rd1
assign op_B_sel = (opcode == R_TYPE || opcode == BRANCH) ? 0 : 1; // 0 selects rd2 1 selects imm32
assign ALU_Control = (opcode == LOAD || opcode == STORE || opcode == LUI || opcode == AUIPC) ? 6'd0 :
							(opcode == JAL) ? 6'b011111:
							(opcode == JALR) ? 6'b111111:
							(opcode == BRANCH) ? {3'b010, funct3}: 
							((opcode == I_TYPE || opcode == R_TYPE) && funct7 == 7'b0100000) ? {3'b001, funct3}:
							{3'b000, funct3};
assign wb_sel = (opcode == LOAD)? 1 : 0; // active 1 when wb memory
assign mem_wEn = (opcode == STORE)? 1 : 0; // active 1 when storing into memory module

endmodule
