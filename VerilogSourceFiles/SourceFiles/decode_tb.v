// Name: Nathan Ackermann, Zhe Deng
// BU ID: U10490015, U16716991
// EC413 Project: Decode Test Bench

module decode_tb();

parameter NOP = 32'b000000000000_00000_000_00000_0010011; // addi zero, zero, 0
parameter ADDRESS_BITS = 16;

// Inputs from Fetch
reg [ADDRESS_BITS-1:0] PC;
reg [31:0] instruction;

// Inputs from Execute/ALU
reg [ADDRESS_BITS-1:0] JALR_target;
reg branch;

// Outputs to Fetch
wire next_PC_select;
wire [ADDRESS_BITS-1:0] target_PC;

// Outputs to Reg File
wire [4:0] read_sel1;
wire [4:0] read_sel2;
wire [4:0] write_sel;
wire wEn;

// Outputs to Execute/ALU
wire branch_op; // Tells ALU if this is a branch instruction
wire [31:0] imm32;
wire [1:0] op_A_sel;
wire op_B_sel;
wire [5:0] ALU_Control;

// Outputs to Memory
wire mem_wEn;

// Outputs to Writeback
wire wb_sel;

decode #(
  .ADDRESS_BITS(ADDRESS_BITS)
) uut (

  // Inputs from Fetch
  .PC(PC),
  .instruction(instruction),

  // Inputs from Execute/ALU
  .JALR_target(JALR_target),
  .branch(branch),

  // Outputs to Fetch
  .next_PC_select(next_PC_select),
  .target_PC(target_PC),

  // Outputs to Reg File
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .wEn(wEn),

  // Outputs to Execute/ALU
  .branch_op(branch_op), // Tells ALU if this is a branch instruction
  .imm32(imm32),
  .op_A_sel(op_A_sel),
  .op_B_sel(op_B_sel),
  .ALU_Control(ALU_Control),

  // Outputs to Memory
  .mem_wEn(mem_wEn),

  // Outputs to Writeback
  .wb_sel(wb_sel)

);



task print_state;
  begin
	 //$display("uj_imm:  %b", uut.uj_imm);
    $display("Time:         %0d", $time);
    $display("instruction:  %b", instruction);
    $display("PC:           %h", PC);
    $display("JALR_target:  %h", JALR_target);
    $display("branch        %b", branch);
    $display("next_PC_sel   %b", next_PC_select);
    $display("target_PC     %h", target_PC);
    $display("read_sel1:    %d", read_sel1);
    $display("read_sel2:    %d", read_sel2);
    $display("write_sel:    %d", write_sel);
    $display("wEn:          %b", wEn);
    $display("branch_op:    %b", branch_op);
    $display("imm32:        %b", imm32);
    $display("op_A_sel:     %b", op_A_sel);
    $display("op_B_sel:     %b", op_B_sel);
    $display("ALU_Control:  %b", ALU_Control);
    $display("mem_wEn:      %b", mem_wEn);
    $display("wb_sel:       %b", wb_sel);
    $display("--------------------------------------------------------------------------------");
    $display("\n\n");
  end
endtask



initial begin
  $display("Starting Decode Test");
  $display("--------------------------------------------------------------------------------");
  instruction = NOP;
  PC          = 0;
  JALR_target = 0;
  branch      = 0;

  #10
  // Display output of NOP instruction
  $display("addi zero, zero, 0");
  print_state();
  // Test a new instruction
  instruction = 32'b111111111111_00000_000_01011_0010011; // addi a1, zero, -1

  #10
  // Here we are printing the state of the register file.
  // We should see the result of the add a6, a1, a2 instruction but not the
  // sub a7, a2, a4 instruction because there has not been a posedge clock yet
  $display("addi a1, zero, -1");
  print_state();
  instruction = 32'b0000000_01100_01011_000_10000_0110011; // add a6, a1, a2

  #10
  $display("add a6, a1, a2");
  print_state();
  instruction = 32'b0100000_01110_01100_000_10001_0110011; // sub a7, a2, a4

  #10
  $display("sub a7, a2, a4");
  print_state();
  instruction = 32'b0000000_01111_01011_010_01010_0110011; // slt a0, a1, a5

  #10
  $display("slt a0, a1, a5");
  print_state();
  instruction = 32'b0000000_01111_01011_100_01110_0110011; // xor a4, a1, a5

  #10
  $display("xor a4, a1, a5");
  print_state();
  instruction = 32'b0000000_01011_01101_111_01101_0110011; // and a3, a3, a1

  #10
  $display("and a3, a3, a1");
  print_state();
  instruction = 32'b011000000000_00000_000_01011_0010011; // addi a1, zero, 1536

  #10
  $display("addi a1, zero, 1536");
  print_state();
  instruction = 32'b0000000_01100_01011_010_00000_0100011; // sw a2, 0(a1);

  #10
  $display("sw a2, 0(a1)");
  print_state();
  instruction = 32'b000000000000_01011_010_10010_0000011; // lw s2, 0(a1);

  #10
  $display("lw s2, 0(a1)");
  print_state();
  instruction = NOP;

  PC = 16'h0114;
  instruction = 32'h0140006f; //jal	zero,20 (Should jump to 0x128)

  #10
  $display("jal	zero, 20");
  print_state();

  JALR_target = 16'h0154;
  PC = 16'h0094;
  instruction = 32'h0c4080e7; // jalr ra,196(ra) (should jump to ra+0x196)

  #10
  $display("jalr ra,196(ra)");
  print_state();

/******************************************************************************
*                     Add Test Cases Here
******************************************************************************/
  
  instruction = 32'b00000000000000100000_00010_0110111; // lui 32, x2;

  #10
  $display("lui 32, x2");
  print_state();
  
  PC = 16'h0004;
  
  instruction = 32'b00000000000000000100_00010_0010111; // AUIPC 4, x2;

  #10
  $display("AUIPC 4, x2");
  print_state();
  instruction = 32'b0000001_00010_00001_000_00000_1100011; // BEQ x2, x1, 16);
  
  #10
  $display("BEQ x2, x1, 16");
  print_state();
  instruction = 32'b0000001_00010_00001_001_00000_1100011; // BNE x2, x1, 16);
  
  #10
  $display("BNE x2, x1, 16");
  print_state();
  instruction = 32'b0000001_00010_00001_100_00000_1100011; // BLT x2, x1, 16);
  
  #10
  $display("BLT x2, x1, 16");
  print_state();
  instruction = 32'b0000001_00010_00001_101_00000_1100011; // BGE x2, x1, 16);
  
  #10
  $display("BGE x2, x1, 16");
  print_state();
  instruction = 32'b0000001_00010_00001_110_00000_1100011; // BLTU x2, x1, 16);
  
  #10
  $display("BLTU x2, x1, 16");
  print_state();
  instruction = 32'b0000001_00010_00001_111_00000_1100011; // BGEU x2, x1, 16);
  
  #10
  $display("BGEU x2, x1, 16");
  print_state();
  instruction = 32'b000000000100_00010_010_00001_0010011; // slti x2, x1, 4  
  
  #10
  $display("slti x2, x1, 4 ");
  print_state();
  instruction = 32'b000000001000_00010_011_00001_0010011; // sltiu x2, x1, 8  
  
  #10
  $display("sltiu x2, x1, 8 ");
  print_state();
  instruction = 32'b000000000100_00010_100_00001_0010011; // xori x2, x1, 4 
  
  #10
  $display("xori x2, x1, 4");
  print_state();
  instruction = 32'b000000001000_00010_110_00001_0010011; // ori x2, x1, 8 
  
  #10
  $display("ori x2, x1, 8");
  print_state();
  instruction = 32'b000000010000_00010_111_00001_0010011; // andi x2, x1, 16 
  
  #10
  $display("andi x2, x1, 16");
  print_state();
  instruction = 32'b0000000_00001_00010_001_00001_0010011; // slli x2, x1, 1 
  
  #10
  $display("slli x2, x1, 1 ");
  print_state();
  instruction = 32'b0000000_00010_00010_101_00001_0010011; // srli x2, x1, 2 
  
  #10
  $display("srli x2, x1, 2 ");
  print_state();
  instruction = 32'b0100000_00100_00010_101_00001_0010011; // srai x2, x1, 4 
  
  #10
  $display("srai x2, x1, 4 ");
  print_state();
  instruction = 32'b0000000_00010_00011_001_00100_0110011; // sll x4, x3, x2
  
  #10
  $display("sll x4, x3, x2");
  print_state();
  instruction = 32'b0000000_00010_00011_011_00100_0110011; // sltu x4, x3, x2
  
  #10
  $display("sltu x4, x3, x2");
  print_state();
  instruction = 32'b0000000_00010_00011_101_00100_0110011; // srl x4, x3, x2
  
  #10
  $display("srl x4, x3, x2");
  print_state();
  instruction = 32'b0100000_00010_00011_101_00100_0110011; // sra x4, x3, x2
  
  #10
  $display("sra x4, x3, x2");
  print_state();
  instruction = 32'b0000000_00010_00011_110_00100_0110011; // or x4, x3, x2
  
  #10
  $display("or x4, x3, x2");
  print_state();
  
  #10
  $stop();
end

endmodule
