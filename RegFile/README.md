# Project RegFile
## Authors
    Kaifeng Yu  (ky99)
    Fangting Ma (fm128)
## Design Implementation
We designed and inplement a RegFile which is a series of 32 individual 32-bits registers containing key information in a CPU. It allows two essential actions: reading register value & writing value to register. We have two read ports and one write port.
### Register
Our Regfile contains 32 indiviual 32-bits registers. We can read from all 32 registers, but can only write to register 1 - register 31, since register 0 always read as 0. We use DFFE as a single register.
### Read port
For the read port, we first let 32 32-bits tristate buffers connect to our 32 registers in RegFile, when select = 0 for the tristate buffer, the output is 32'b zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz; when select = 1, the output is the value in the correspongding register. Then, we use a 5 bits to 32 bits decoder to locate the specific register we would like to read from, we use the output of the decoder as the select inputs of the tristate buffers. Therfore, we can read value from a certain register.
### write port
For the write port, we first use a 5 bits to 32 bits decoder to locate the specific register we would like to write to. Then we use the output of the decoder as the input of and gates for a specific register. If output[i] for the decoder is 1 and the write_enable input signal is also i, then we can write data to register[i].
### decoder
### tristate buffer 
