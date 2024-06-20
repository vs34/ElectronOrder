# RV32I ISA

Hello friend, in this I would explain the RV32I ISA.
The instructions of RISC-V ISA are different; they contain 3 fields to define what each instruction is supposed to say:

- **OPCODE (7 bit)**: Tells about the type of instruction and which **Execution Units** it will go to (ALU, BRANCH, etc.) after instruction decode.
- **func3 (3 bit)**: The subcategory that tells exactly what the **Execution Units** do (add, sub, etc.).
- **func7 (7 bit)**: Further classifies the instruction. Some instructions have the same opcode and func3, like add and subtract, but they have different func7. The RISC-V community does this because addition and subtraction are closely related (2's complement can make it subtraction), reducing silicon use.

## There are 6 types of opcodes (commands) in the ISA:

- TYPE R
- TYPE I
- TYPE B
- TYPE J
- TYPE U
- TYPE S

### TYPE R

The type R instruction is used to set the value of any given register in the opcode.

#### R-Type Instruction Format

R-type instructions in the RV32I ISA use the following format:

```
| funct7 |  rs2   |  rs1   | funct3 |  rd    | opcode  |
| 7 bits | 5 bits | 5 bits | 3 bits | 5 bits | 7 bits  |
```

#### Common Opcode

The common primary opcode for these arithmetic and logical operations is `0110011`.

#### Differentiating with `funct3` and `funct7`

##### ADD and SUB

- **Opcode**: `0110011`
- **funct3**: `000`
- The difference between `ADD` and `SUB` is in the `funct7` field.

  - `ADD`:
    - `funct7`: `0000000`
    - Instruction Encoding: `0000000 rs2 rs1 000 rd 0110011`
  - `SUB`:
    - `funct7`: `0100000`
    - Instruction Encoding: `0100000 rs2 rs1 000 rd 0110011`

#### Instruction Set Encoding:

| Field  | Value   | Description                       |
| ------ | ------- | --------------------------------- |
| opcode | 0110011 | Specifies an R-type instruction   |
| rd     | [11:7]  | Destination register              |
| func3  | [14:12] | Specifies the operation (subtype) |
| rs1    | [19:15] | First source register             |
| rs2    | [24:20] | Second source register            |
| func7  | [31:25] | Further specifies the operation   |

### TYPE I

Immediate type. Immediate is a constant value that:

- We could load to a constant to register **LOAD UNIT**
- Add/subtract a constant from a given register **ALU UNIT**
- Increase program counter a constant value by any constant value **BRANCH UNIT**

Hence, type I contains 3 types of instructions if we classify according to **Execution Units** that an instruction belongs to. Therefore, type I instructions have 3 different opcodes:

- 0010011 **ALU UNIT**
- 0000011 **LOAD UNIT**
- 1100111 **BRANCH UNIT**

**NOTE**: We classify further these instructions using func3 and func7.

#### Instruction Set Encoding:

| Field  | Value   | Description                       |
| ------ | ------- | --------------------------------- |
| opcode | varies  | Specifies an I-type instruction   |
| rd     | [11:7]  | Destination register              |
| func3  | [14:12] | Specifies the operation (subtype) |
| rs1    | [19:15] | Source register                   |
| imm    | [31:20] | Immediate value                   |

### TYPE B

Branch instructions. Used for conditional branching based on comparisons between registers.

#### Instruction Set Encoding:

| Field     | Value   | Description                       |
| --------- | ------- | --------------------------------- |
| opcode    | 1100011 | Specifies a B-type instruction    |
| imm[12]   | [31]    | Immediate value (bit 12)          |
| imm[10:5] | [30:25] | Immediate value (bits 10 to 5)    |
| rs2       | [24:20] | Second source register            |
| rs1       | [19:15] | First source register             |
| func3     | [14:12] | Specifies the operation (subtype) |
| imm[4:1]  | [11:8]  | Immediate value (bits 4 to 1)     |
| imm[11]   | [7]     | Immediate value (bit 11)          |
| opcode    | [6:0]   | 1100011                           |

### TYPE J

Jump instructions. Used for unconditional jumps.

#### Instruction Set Encoding:

| Field      | Value   | Description                     |
| ---------- | ------- | ------------------------------- |
| opcode     | 1101111 | Specifies a J-type instruction  |
| rd         | [11:7]  | Destination register            |
| imm[20]    | [31]    | Immediate value (bit 20)        |
| imm[10:1]  | [30:21] | Immediate value (bits 10 to 1)  |
| imm[11]    | [20]    | Immediate value (bit 11)        |
| imm[19:12] | [19:12] | Immediate value (bits 19 to 12) |

### TYPE U

Used for instructions that require a large immediate value, such as loading an upper immediate.

#### Instruction Set Encoding:

| Field  | Value   | Description                    |
| ------ | ------- | ------------------------------ |
| opcode | varies  | Specifies a U-type instruction |
| rd     | [11:7]  | Destination register           |
| imm    | [31:12] | Immediate value                |

### TYPE S

Store instructions. Used to store register values into memory.

#### Instruction Set Encoding:

| Field     | Value   | Description                       |
| --------- | ------- | --------------------------------- |
| opcode    | 0100011 | Specifies an S-type instruction   |
| imm[11:5] | [31:25] | Immediate value (bits 11 to 5)    |
| rs2       | [24:20] | Second source register            |
| rs1       | [19:15] | First source register             |
| func3     | [14:12] | Specifies the operation (subtype) |
| imm[4:0]  | [11:7]  | Immediate value (bits 4 to 0)     |
