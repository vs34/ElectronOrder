Pipeline is the final part of the cpu connect every thing togather hence i will be using this as a todo tracker

In a typical RV32I (RISC-V 32-bit Integer) CPU, the pipeline stages can vary based on the complexity and design of the processor.
A basic RV32I CPU often has a 5-stage pipeline. These stages are:

1. **Fetch (IF)**: Instruction Fetch
2. **Decode (ID)**: Instruction Decode and Register Fetch
3. **Execute (EX)**: Execute or Address Calculation
4. **Memory (MEM)**: Memory Access
5. **Write Back (WB)**: Write Back to Register File

Here is a brief overview of each stage:

### 1. Fetch (IF) ✓

- **Purpose**: Fetch the next instruction from memory.
- **Tasks**:
  - ! Read the instruction from the instruction memory using the program counter (PC).
    - Instruction memory AKA RAM (random access memory) is to be codeded
  - ✓ Update the PC to point to the next instruction.

### 2. Decode (ID)

- **Purpose**: Decode the fetched instruction and read the source registers.
- **Tasks**:
  - ✓ Decode the opcode, funct3, funct7, and other fields of the instruction.
  - ! Read the source registers (`rs1` and `rs2`) from the register file.
    - whole 32 register should be there a way to read and write should be there
    - read - (combinational); write - (sequntial);
  - ✓ Sign-extend the immediate value if required.
  - ✓ Determine the control signals for the following stages.

### 3. Execute (EX)

- **Purpose**: Perform the arithmetic or logical operation or calculate the effective address.
- **Tasks**:
  - ! Perform ALU operations (addition, subtraction, AND, OR, etc.).
  - ✓ Calculate the target address for branch instructions.
  - Compute the effective address for memory access instructions.

### 4. Memory (MEM)

- **Purpose**: Access data memory if needed.
- **Tasks**:
  - Read from or write to data memory if the instruction is a load or store.
  - Pass through the result for other types of instructions.

### 5. Write Back (WB)

- **Purpose**: Write the result back to the register file.
- **Tasks**:
  - Write the result from the ALU or memory back to the destination register (`rd`).

### Example Pipeline Flow for a Load Instruction (LW)

1. **IF**: Fetch the `LW` instruction from memory.
2. **ID**: Decode the `LW` instruction, read the base address register (`rs1`), and sign-extend the immediate value.
3. **EX**: Calculate the effective address by adding the base address (`rs1`) and the immediate value.
4. **MEM**: Access the data memory at the calculated address to load the word.
5. **WB**: Write the loaded word back to the destination register (`rd`).

### Example Pipeline Flow for an ALU Instruction (ADD)

1. **IF**: Fetch the `ADD` instruction from memory.
2. **ID**: Decode the `ADD` instruction and read the source registers (`rs1` and `rs2`).
3. **EX**: Perform the addition of the values in `rs1` and `rs2`.
4. **MEM**: (No memory access needed for `ADD` instruction, this stage is bypassed).
5. **WB**: Write the result of the addition back to the destination register (`rd`).

### Summary

A basic RV32I CPU typically has a 5-stage pipeline: Fetch, Decode, Execute, Memory, and Write Back. This pipeline allows for efficient and orderly processing of instructions by breaking down the CPU operations into manageable stages.
