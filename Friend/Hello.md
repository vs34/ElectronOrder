## Hello Friend

This is a hard project for me with my current plans for this project,
that's way i am creating you to put my thoughts here

lets start

### BASICS

in riscv isa we have a same opcode for diffrent instruction for eg add and sub
infact the opcode difine the type of instruction like opcode for typeR is 0110011
so add and sub both have same opcode as they are of same type typeR
they are ditenguish by the funct7 funct3 bits of the instruction

frather clasification in ISA.md

### CPU/Fetcher

wrote **Instruction Fetch Unit (IFU)** ez read from a file

- _ASSUMPTION_ the fetch unit will fetch the instruction after every clock cycle
  irrsepect to the current state of pipeline memory.
  to solve this i could impliment a signal from pipeline which tell when to fetch next instruction

### CPU/Decoder

**Instruction Decode Unit (IDU)** moderate requare reading (RISCV ISA)

- _NO Clk signal_ not that complex decoder dosent need many clock cuycle to decode the instruction
  immedate risponce no clk when pipleined the decoder is connected to the reg
  which provide the clk signal would be sequential

### TIME

```
2024-05-22 01:01
2024-05-22 02:21
2024-05-24 01:15
2024-05-24 02:33
2024-06-02 00:44
```
