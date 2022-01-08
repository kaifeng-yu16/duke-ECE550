/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine) // Q:and registers should all be 1?
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable; 
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 // control signal
	 // Rdst: if true, oprandB read from rd; if false, oprandB read from rt
	 // only when sw, Rdst = true
	 wire Jp, ALUinB, Rdst, Rwd, blt, bne, jal, jr, bex, setx, is_add, is_addi, is_sub, A, B, C;
	 // define PC variable
	 wire [11:0] PC, PC_plus_one;
	 
	 // get instruction
	 assign address_imem = PC;
 	 
	 // Decode
	 wire [4:0] opcode, rd, rs, rt, shamt, ALUop_in, reg_30, reg_31;
	 wire [16:0] immediate;
	 wire [26:0] target;
	 
	 assign opcode = q_imem[31:27];
	 assign rd = q_imem[26:22];
	 assign rs = q_imem[21:17];
	 assign rt = q_imem[16:12];
	 assign shamt = q_imem[11:7];
	 assign ALUop_in = q_imem[6:2];
	 assign immediate = q_imem[16:0];
	 assign target = q_imem[26:0];
	 assign reg_30 = 5'b11110;
	 assign reg_31 = 5'b11111;
	 
	 // Regfile
	 assign ctrl_readRegA = rs;
	 assign ctrl_readRegB = !Rdst ? rt : (A ? reg_30 : rd);
	 assign ctrl_writeReg = jal ? reg_31 : (A ? reg_30 : rd);
	 
	 // Signextend
	 wire [31:0] immediate_extended;
	 wire [14:0] all_ones, all_zeros;
	 assign all_ones = 15'h7fff;
	 assign all_zeros = 15'h0000;
	 assign immediate_extended[31:17] = immediate[16] ? all_ones : all_zeros;
	 assign immediate_extended[16:0] = immediate;
	 
	 //ALU
	 wire [4:0] ALUop;
	 wire [31:0] alu_data_result;
	 wire isNotEqual, isLessThan, overflow;
	 wire [31:0] data_operandA, data_operandB;
	 assign data_operandA = bex ? 32'b0 : data_readRegA;
	 assign data_operandB = ALUinB ? immediate_extended : data_readRegB;
	 
	 alu alu_1(data_operandA, data_operandB, ALUop, shamt,
			     alu_data_result, isNotEqual, isLessThan, overflow);
	 // DMem
	 assign address_dmem = alu_data_result[11:0];
	 assign data = data_readRegB;
	 
	 // Write back
	 wire [31:0] write_add, write_addi, write_sub, write_target, rstatus_out;
	 assign write_add = 32'b1;
	 assign write_addi = 32'b10;
	 assign write_sub = 32'b11;
	 assign write_target[26:0] = target;
	 assign write_target[31:27] = 5'b0;
	 assign rstatus_out = (opcode == 5'b00000) ? ((ALUop == 5'b00000) ? write_add : write_sub) : 
			((opcode == 5'b00101) ? write_addi : write_target);
	 
	 wire [31:0] Rwd_out;
	 assign Rwd_out = Rwd ? q_dmem : alu_data_result;
	 assign data_writeReg = C ? rstatus_out : (jal ? PC_plus_one : Rwd_out);
	 
	 // generate PC
	 PC_module my_pc(data_readRegB, target, immediate, isLessThan, isNotEqual, 
		bne, blt, bex, Jp, jr, clock, reset, PC, PC_plus_one);
	 
	 // generate control signal
	 control crl_sig(Jp, ALUinB, ALUop, wren, ctrl_writeEnable, Rdst, Rwd, blt, 
			bne, jal, jr, bex, setx, A, B, C, is_add, is_addi, is_sub,
			opcode, ALUop_in, overflow);

endmodule