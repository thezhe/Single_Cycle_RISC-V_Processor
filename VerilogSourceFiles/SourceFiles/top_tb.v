// Name: Nathan Ackermann, Zhe Deng
// BU ID: U10490015, U16716991
// EC413 Project: Top Level Module Test Bench

module top_tb();

reg clock;
reg reset;

wire [31:0] result;

integer x;

top dut (
  .clock(clock),
  .reset(reset),
  .wb_data(result)
);

always #5 clock = ~clock;

task print_state;
  begin
    $display("Time:\t%0d", $time);
    for( x=0; x<32; x=x+1) begin
      $display("Register %d: %h", x, dut.regFile_inst.reg_file[x]);
    end
    $display("--------------------------------------------------------------------------------");
    $display("\n\n");
  end
endtask

initial begin
  clock = 1'b1;
  reset = 1'b1;

  // Make sure the .vmh file is in the same directory that you launched the
  // simulation from.
  //$readmemh("/home/nca/Desktop/U10490015_U16716991_project_part2/fibonacci.vmh", dut.main_memory.ram); // Should put 0x00000015 in register x9
  $readmemh("/home/nca/Desktop/U10490015_U16716991_project_part2/gcd.vmh", dut.main_memory.ram); // Should put 0x00000010 in register x9

  for( x=0; x<32; x=x+1) begin
    dut.regFile_inst.reg_file[x] = 32'd0;
  end
  print_state();

  #1
  #20
  reset = 1'b0;
  
  
  #16000 // after running sim enter "run 999999999" into console to ensure program is completely run"
  print_state();
  $stop();

end

endmodule

