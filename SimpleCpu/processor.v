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
	 wire ALUinB, Rdst, Rwd;
	 
	 // generate PC
	 reg [11:0] PC;
	 wire [11:0] PC_new;
	 assign PC_new = PC + 12'b1;
	 always @ (posedge clock or posedge reset)
	 begin
		if (reset)
			PC <= 12'b0;
		else 
			PC <= PC_new;
	 end
	 
	 // get instruction
	 assign address_imem = PC;
 	 
	 // Decode
	 wire [4:0] opcode, rd, rs, rt, shamt, ALUop;
	 wire [16:0] immediate;
	 
	 assign opcode = q_imem[31:27];
	 assign rd = q_imem[26:22];
	 assign rs = q_imem[21:17];
	 assign rt = q_imem[16:12];
	 assign shamt = q_imem[11:7];
	 assign ALUop = (opcode == 5'b00000) ? q_imem[6:2] : 5'b00000;
	 assign immediate = q_imem[16:0];
	 
	 // Regfile
	 assign ctrl_readRegA = rs;
	 assign ctrl_readRegB = Rdst ? rd : rt;
	 assign ctrl_writeReg = rd;
	 
	 // Signextend
	 wire [31:0] immediate_extended;
	 wire [14:0] all_ones, all_zeros;
	 assign all_ones = 15'h7fff;
	 assign all_zeros = 15'h0000;
	 assign immediate_extended[31:17] = immediate[16] ? all_ones : all_zeros;
	 assign immediate_extended[16:0] = immediate;
	 
	 //ALU
	 wire [31:0] alu_data_result;
	 wire isNotEqual, isLessThan, overflow;
	 wire [31:0] data_operandB;
	 assign data_operandB = ALUinB ? immediate_extended : data_readRegB;
	 alu alu_1(data_readRegA, data_operandB, ALUop, shamt,
			     alu_data_result, isNotEqual, isLessThan, overflow);
	 // DMem
	 assign address_dmem = alu_data_result[11:0];
	 assign data = data_readRegB;
	 
	 // Write back
	 assign data_writeReg = Rwd ? q_dmem : alu_data_result;
	 
	 // generate control signal
	 control crl_sig(ALUinB, wren, ctrl_writeEnable, Rdst, Rwd, opcode);

endmodule