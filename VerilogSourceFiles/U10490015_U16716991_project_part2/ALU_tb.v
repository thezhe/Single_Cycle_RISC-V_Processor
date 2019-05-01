// Name: Nathan Ackermann, Zhe Deng
// BU ID: U10490015, U16716991
// EC413 Project: ALU Test Bench

module ALU_tb();
reg branch_op;
reg [5:0] ctrl;
reg [31:0] opA, opB;

wire [31:0] result;
wire branch;

ALU dut (
  .branch_op(branch_op),
  .ALU_Control(ctrl),
  .operand_A(opA),
  .operand_B(opB),
  .ALU_result(result),
  .branch(branch)
);

initial begin
  branch_op = 1'b0;
  ctrl = 6'b000000;
  opA = 4;
  opB = 5;

  #10
  $display("ALU Result 4 + 5: %d",result); //ADD, effective add
  #10
  ctrl = 6'b000010;
  #10
  $display("ALU Result 4 < 5: %d",result); //SLTI, effective signed less than
  #10
  opB = 32'hffffffff;
  #10
  $display("ALU Result 4 < -1: %d",result); //SLTI, effective signed less than
  #10
  branch_op = 1'b1;
  opB = 32'hffffffff;
  opA = 32'hffffffff;
  ctrl = 6'b010_000; 
  #10
  $display("ALU Result: -1==-1: %d",result); //BEQ, effective equals
  $display("branch: branch_op=1 and result: %b", branch);

/******************************************************************************
*                      Add Test Cases Here
******************************************************************************/
  branch_op = 1'b0;
  opB = 32'h00000001;
  opA = 32'h00000001;
  ctrl = 6'b011_111;
  #10
  $display("ALU Result: JAL opA=1: %d",result); //JAL, effective op_A pass through
  opB = 32'hffffffff;
  opA = 32'hffffffff;
  ctrl = 6'b111_111; 
  #10
  $display("ALU Result: JALR, opA=-1: (binary)%b",result);//JALR, effective op_A pass through
  branch_op = 1'b1;
  opB = 32'hffffffff;
  opA = 32'hfffffffe;
  ctrl = 6'b010_000; 
  #10
  $display("ALU Result: -2==-1: %d",result);//BEQ, effective equals 
  $display("branch: branch_op=1 and result: %b", branch);
  opB = 32'hffffffff;
  opA = 32'hfffffffe;
  ctrl = 6'b010_001; 
  #10
  $display("ALU Result: -2!=-1: %d",result);//BNE, effective not equals 
  $display("branch: branch_op=1 and result: %b", branch);
  opB = 32'hffffffff;
  opA = 32'hfffffffe;
  ctrl = 6'b010_001;
  #10
  $display("ALU Result -2<-1: %d",result); //BLT, effective signed less than
  $display("branch: branch_op=1 and result: %b", branch);
  opB = 32'hffffffff;
  opA = 32'hfffffffe;
  ctrl = 6'b010_101; 
  #10
  $display("ALU Result: -2>=-1 %d",result); //BGE, effective signed greater than or equal 
  $display("branch: branch_op=1 and result: %b", branch);
  opB = 32'hffffffff;
  opA = 32'hffffffff;
  ctrl = 6'b010_101;
  #10
  $display("ALU Result: -1>=-1 %d",result); //BGE, effective signed greater than or equal 
  $display("branch: branch_op=1 and result: %b", branch);
  opB = 32'hffffffff;
  opA = 32'h00000001;
  ctrl = 6'b010_110; 
  #10
  $display("ALU Result: 1 <UINT_MAX: %d",result); //BLTU effective unsigned less than
  $display("branch: branch_op=1 and result: %b", branch);
  opB = 32'hffffffff;
  opA = 32'h00000001;
  ctrl = 6'b010_111;
  #10
  $display("ALU Result: 1>UINT_MAX %d",result); //BGEU effective unsigned greater than or equal
  $display("branch: branch_op=1 and result: %b", branch);
  opB = 32'h00000001;
  opA = 32'h00000001;
  ctrl = 6'b010_111;
  #10
  $display("ALU Result: 1>=1: %d",result);
  $display("branch: branch_op=1 and result: %b", branch); //BGEU effective unsigned greater than or equal
  branch_op = 1'b0;
  opB = 32'h00000001;
  opA = 32'h00000001;
  ctrl = 6'b000_010; 
  #10
  $display("ALU Result: 1<1: %d",result); //SLTI effective signed less than
  opB = 32'hffffffff;
  opA = 32'h00000001;
  ctrl = 6'b000_011; 
  #10
  $display("ALU Result: 1<UINT_MAX: %d",result); //SLTIU effective unsigned less than
  opB = 32'h00000101;
  opA = 32'h00000001;
  ctrl = 6'b000_100; 
  #10
  $display("ALU Result: 0x00000001^0x00000101=0x00000100=256: %d",result); //XORI effective XOR
  opB = 32'h00000101;
  opA = 32'h00000001;
  ctrl = 6'b000_110; 
  #10
  $display("ALU Result: 0x00000001|0x00000101=0x00000101=257: %d",result); //ORI effective OR
  opB = 32'h00010101;
  opA = 32'h00000001;
  ctrl = 6'b000_111; 
  #10
  $display("ALU Result: 0x00000001&0x00010101=1: %d",result); //ANDI effective AND
  opB = 32'h00000001;
  opA = 32'h00000001;
  ctrl = 6'b000_001; 
  #10
  $display("ALU Result b01<<d1=b10=2: %d",result); //SLLI effective shift left
  opB = 32'h00000005;
  opA = 32'h00000011;
  ctrl = 6'b000_101; 
  #10
  $display("ALU Result: b10001>>d5=b00000=0: %d",result); //SLRI effective shift right
  opB = 32'h00000001;
  opA = 32'h00000011;
  ctrl = 6'b000_101; 
  #10
  $display("ALU Result: b010001>>d1=b1000=8: %d",result); //SLRI effective shift right
  opB = 32'h00000002;
  opA = 32'h00000011;
  ctrl = 6'b000_101; 
  #10
  $display("ALU Result: b10001>>d2=b00100=4: %d",result); //SLRI effective shift right
  opB = 32'h00000005;
  opA = 32'hfffffffc; // d-4 
  ctrl = 6'b001_101;
  #10
  $display("ALU Result:  d-4>>>d5=-1: (binary) %b",result); //SRAI effective shift right arithmetic
  opB = 32'h00000005;
  opA = 32'd4; // d4 
  ctrl = 6'b001_101;
  #10
  $display("ALU Result:  d4>>>d5=0: (binary) %b",result); //SRAI effective shift right arithmetic
  opB = 32'hfffff010; //16 bit shift
  opA = 32'b00000000000000010000000000000000; 
  ctrl = 6'b001_101;
  #10
  $display("ALU Result:  d2^16>>>d16=1: %d",result); //SRAI effective shift right arithmetic
  opB = 32'h00000002;
  opA = 32'h00000011;// d17
  ctrl = 6'b001_101; 
  #10
  $display("ALU Result: b10001>>>d2=b100=4: %d",result); //SRAI effective shift right arithmetic
  opB = 32'h00000100;
  opA = 32'h00000101;
  ctrl = 6'b001_000; 
  #10
  $display("ALU Result: 0x00000101-0x00000100=1: %d",result); //SUB effective subtract
  opB = 32'hffffffff;
  opA = 32'h00000001;
  ctrl = 6'b001_000; 
  #10
  $display("ALU Result: 1-(-1): %d",result); //SUB effective subtract
  #10
  $stop();
end

endmodule

