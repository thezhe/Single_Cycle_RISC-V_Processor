// Name: Nathan Ackermann, Zhe Deng
// BU ID: U10490015, U16716991
// EC413 Project: ALU

module ALU (
  input branch_op,
  input [5:0]  ALU_Control,
  input [31:0] operand_A,
  input [31:0] operand_B,
  output [31:0] ALU_result,
  output branch
);

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
assign ALU_result = (ALU_Control == 6'b000000)?operand_A+operand_B:
					(ALU_Control[4:0] == 5'b11111)?operand_A:
					(ALU_Control == 6'b010000)?operand_A==operand_B:
					(ALU_Control == 6'b010001)?operand_A!=operand_B:
					(ALU_Control == 6'b010100 || ALU_Control == 6'b000010)?($signed(operand_A) < $signed(operand_B)):
					(ALU_Control == 6'b010101)?$signed(operand_A) >= $signed(operand_B):
					(ALU_Control == 6'b010110|| ALU_Control == 6'b000011)?operand_A < operand_B:
					(ALU_Control == 6'b010111)?operand_A >= operand_B:
					(ALU_Control == 6'b000100)?(operand_A)^(operand_B):
					(ALU_Control == 6'b000110)?(operand_A)|(operand_B):
					(ALU_Control == 6'b000111)?(operand_A)&(operand_B):
					(ALU_Control == 6'b000001)? operand_A << operand_B[4:0]:
					(ALU_Control == 6'b000101)? operand_A >> operand_B[4:0]:
					(ALU_Control == 6'b001101)? {{32{operand_A[31]}}, operand_A} >> operand_B[4:0]:
					(ALU_Control == 6'b001000)?operand_A-operand_B:
					32'd0;
							
assign branch = (branch_op == 1)?ALU_result:0;

endmodule
