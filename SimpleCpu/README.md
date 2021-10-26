# Project RegFile
## Authors
    Kaifeng Yu  (ky99)
    Fangting Ma (fm128)
## Design Implementation
In this project, we build a simple ALU which implement R-type and I-type instructions.
### skeleton.v
This is the top-level module, it serves as a wrapper around the processor to provide certain control signals and interfaces to memory elements. In this module, we implement four clocks for imem, dmem, regfile and processor respectively. The processor clock, dmem clock and regfile clock are 12.5MHz while the imem_clock is 50MHz.
### processor.v
The processor module takes in several inputs from skeleton module regarding imem, dmem and regfile. In this module, we generate PC, decode instructions, do sign extention, integrate ALU and regfile module, and implement control signals.
### imem.v & dmem.v
These two modules are memory for instructions and memory for data respectively. These are gererated by properly generating Quartus syncram components.
### alu.v
This is the ALU module. It is integrated in the processor module.
### refile.v & reg_32bit.v & dffe_ref.b & decoder_5_32.v
These files implement the regfile module. It is integrated in the processor module.
### div_2.v & div_4.v
These two modules are used to devide a 50MHz clock into 25MHz and 12.5Mhz respectively.
