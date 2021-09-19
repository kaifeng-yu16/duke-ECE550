# Project ALU
## Authors
    Kaifeng Yu  (ky99)
    Fangting Ma (fm128)
## Design Implementation
### Add & Substract
We implement a 32-bit Adder to conduct addition operation. Then, since A - B = A + (~B) +1, we just simply invert every bit in operand B and let the carry-in bit to be 1 to conduct substraction operation.

The 32-bit Adder is a CSA which take in operand A[31:0], operand B[31:0], the control signal c_in and return Sum[31:0] and Ovf. It is implemented as following:
* First, we build a 4-bit RCA.
* Then, we use 3 4-bit RCAs that we built before, and build a 8-bit CSA.
* After that, we use 3 8-bit CSAs to build a 16-bit CSA
* finally, we use 3 16-bit CSAs to build a 32-bit CSA

### bitwise-AND & bitwise-OR
To implement a 32-bit bitwise-and, we use a for loop to operate AND on every bit of operand A and operand B to get the results.

To implement a 32-bit bitwise-or, we use a for loop to operate OR on every bit of operand A and operand B to get the results.

### SLL & SRA
We build a SLL to operate logical left shift on operand A. To implement it, we build 4 layers of wires to store the results of 0/1, 0/2, 0/4, 0/8, 0/16 shift amount layer by layer. The digits of shift amount will determine layers. For example, if the least significant bit of shift amount is 0, then the first layer (layer0) will reserve the same result of original operand A. Otherwise, every bit of operand A will be substituted by their right bit, and the least significant bit will become 0. For layer 1, if shiftamt[1] is 0, then the second layer will reserve the same result of original operand A. Otherwise, every bit of operand A will be substituted by their the second right bit, and the right two bits will be filled with 0s.
For each layer, we use for loops to operate on each bit. And also use for loops to fill with 0s.

We build a SRA to operate arithmetic right shift on operand A. To implement it, we do similar steps as SLL but with different shift direction. We shift operand to right instead of left. Besides, for SRA, we build 8 layers in total, 4 for negative operand A and 4 for positive operand A separately. For positive numbers, we fill 0s at left side, but for negative numbers, we fill 1s at left side. After getting both results for negative operand and positive operand, we determine the final output by the most significant bit of operand A. If it is 1, we choose the negative result, otherwise, we choose the positive result as our final output.


### Overflow
To detect a overflow, we use the following equeation: Ovf = Cin xor Cout of the last bit addition. 

We compute the Cin of the last bit addition using Cin = (A[30] and B[30]) or ((A[30] xor B[30]) and (not Sum[30]))

### isLessThan & isNotEqual
To determine whether operand A is strictly less than operand B, we use following conditions: (a<0&&b>0) || (a>0 && b >0 && out < 0) || (a<0 && b<0 && out <0) 

To determine whether operand A and operand B are not equal, we judge it by whether the every bit of output of SUBSTRACT and overflow is equal to 0.


