# Project ALU
## Authors
    Kaifeng Yu  (ky99)
    Fangting Ma (fm128)
## Design Implementation
### Add & Substract
We implement a 32-bit Adder to conduct addition operation. Then, since A - B = A + (~B) +1, we just simply invert every bit in operand B and let the carry-in bit to be 1 to conduct sustraction operation.

The 32-bit Adder is a CSA which take in operand A[31:0], operand B[31:0], the control signal c_in and return Sum[31:0] and Ovf. It is implemented as following:
* First, we build a 4-bit RCA.
* Then, we use 3 4-bit RCAs that we built before, and build a 8-bit CSA.
* After that, we use 3 8-bit CSAs to build a 16-bit CSA
* finally, we use 3 16-bit CSAs to build a 32-bit CSA

### Overflow
To detect a overflow, we use the following equeation: Ovf = Cin xor Cout of the last bit addition. 

We compute the Cin of the last bit addition using Cin = (A[30] and B[30]) or ((A[30] xor B[30]) and (not Sum[30]))
