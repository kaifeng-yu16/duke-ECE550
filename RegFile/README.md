# Project RegFile
## Authors
    Kaifeng Yu  (ky99)
    Fangting Ma (fm128)
## Design Implementation
We designed and inplement a RegFile which is a series of 32 individual 32-bits registers containing key information in a CPU. It allows two essential actions: reading register value & writing value to register. We have two read ports and one write port.
###Register
Our Regfile contains 32 indiviual 32-bits registers. We can read from all 32 registers, but can only write to register 1 - register 31, since register 0 always read as 0.
###Read port
For the read port, we first let 32 32-bits tristate buffer connect to our 32 registers in RegFile, when the select = 0 for the tristate buffer, the output is 32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz; when the select = 0, the output is the value in the correspongding register. Then, we use a 5 bits to 32 bits decoder to locate the specific register we would like to read from.  
###write port
###decoder
###tristate buffer 
