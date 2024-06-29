# Hello Friend

This is a hard project for me with my current plans for this project,
that's way i am creating you to put my thoughts here

lets start

## BASICS

in riscv isa we have a same opcode for diffrent instruction for eg add and sub
infact the opcode difine the type of instruction like opcode for typeR is 0110011
so add and sub both have same opcode as they are of same type typeR
they are ditenguish by the funct7 funct3 bits of the instruction

frather clasification in ISA.md

## CPU/Fetcher

wrote **Instruction Fetch Unit (IFU)** ez read from a file

- _ASSUMPTION_ the fetch unit will fetch the instruction after every clock cycle
  irrsepect to the current state of pipeline memory.
  to solve this i could impliment a signal from pipeline which tell when to fetch next instruction

## CPU/Decoder

**Instruction Decode Unit (IDU)** moderate requare reading (RISCV ISA)

- _NO Clk signal_ not that complex decoder dosent need many clock cuycle to decode the instruction
  immedate risponce no clk when pipleined the decoder is connected to the reg
  which provide the clk signal would be sequential

## CPU/ALU

**arithmetic logic unit (ALU)** do arithmetic oppreation

- _NO Clk signal_ as the rv32I is designed keeping cost of silicon in mind
  it doesn't have multiplication division ... etc, that needs complex combination logic hence, no use of clk

## LOAD/STORE Instruction they are complex to impliment that we need to impliment memory

i could just impliment one common stroage for internal and ram it would reduse complexcity
i want to simulate a little kernel on top of it so
according to gpt
Running a kernel, even a minimal one, typically requires more resources than running a basic application due to the kernel's need to manage hardware,
provide system services, and maintain various data structures. Let's look at what is minimally required to run a simple kernel on an RV32I CPU.

### Basic Requirements for Running a Kernel

1. **Instruction Storage**:

   - The kernel itself needs to be stored in RAM.
   - A minimal kernel that includes basic functionalities (such as task switching, simple file system support, basic device drivers) would require
     more memory than a simple bootloader.

2. **Data Storage**:

   - The kernel needs memory to store its data structures such as process control blocks, file system metadata, etc.

3. **Stack and Heap**:

   - The kernel needs a stack for kernel-mode operations.
   - Dynamic memory allocation in the kernel is typically handled via a heap.

4. **Kernel Code**:
   - Basic kernel functions, system calls, interrupt handlers, etc.

### Minimal Kernel Configuration

For a minimal kernel, let's estimate the amount of RAM required:

- **Instruction Storage**:

  - Kernel code size can vary widely, but a minimal kernel might fit within 32 KB to 64 KB.

- **Data Storage**:

  - Kernel data structures, device buffers, etc. might require an additional 32 KB to 64 KB.

- **Stack and Heap**:
  - Kernel stack and heap could require another 32 KB to 64 KB.

### Total Minimal RAM Estimation

Combining these estimates:

- **Kernel Code**: 32 KB to 64 KB
- **Kernel Data Structures**: 32 KB to 64 KB
- **Kernel Stack and Heap**: 32 KB to 64 KB

This gives us a total of around 96 KB to 192 KB of RAM as a practical minimum to run a very basic kernel.

### Real-World Considerations

For real-world systems, even minimal embedded operating systems (such as FreeRTOS) often recommend at least 256 KB of RAM to ensure they have enough space to run efficiently with user applications.

### Example Minimal Kernel

A very basic minimal kernel might be something like the following:

- Basic task scheduler (round-robin or priority-based).
- Simple memory manager.
- Basic I/O handling (serial, timer).
- Basic interrupt handling.
- Minimal filesystem (optional).

### Conclusion

For running a minimal kernel on an RV32I CPU:

- **Absolute Minimum RAM**: 96 KB to 192 KB.
- **More Practical Minimum RAM**: 256 KB (to handle real-world scenarios with some margin for additional services and user applications).

This ensures that the kernel has enough space to store its code, manage its data structures, and perform necessary operations without running into memory shortages.
**we will be using unifide memory same for program same for os**
+--------------------------+
| Region | Size |
+--------------+-----------+
| Bootloader | 8 KB |
| Kernel Code | 64 KB |
| User Code | 128 KB |
| Data Segment | 128 KB |
| Heap | 128 KB |
| Stack | 64 KB |
+--------------------------+
Total: 512 KB

1MB unifide memory because it sounds cool
good night reserch about os kernal/system

### TIME

```
2024-05-22 01:01
2024-05-22 02:21
2024-05-24 01:15
2024-05-24 02:33
2024-06-02 00:44
```
