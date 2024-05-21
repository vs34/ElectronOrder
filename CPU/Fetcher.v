// 129
module Fetcher (
    input wire clk,                 // Clock signal
    input wire reset,               // Reset signal
    input wire [31:0] branch_target, // Branch target address if next instruction is to branch
    input wire branch_taken,         // Branch taken signal
    output reg [31:0] pc,            // Program Counter
    output reg [31:0] instruction    // Current instruction
);
    // Instruction memory: 256 words of 32-bit instructions
    reg [31:0] instruction_memory [0:255];

    initial begin
        // Initialize instruction memory with some values for simulation
        // loaded from an external file or memory
        $readmemh("instructions.hex", instruction_memory);
    end

    // Program Counter Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'b0; // Initialize PC to zero on reset
        end else if (branch_taken) begin
            pc <= branch_target; // Update PC to branch target on branch
        end else begin
            pc <= pc + 4; // Increment PC by 4-byte (32 bit) to fetch the next instruction
        end
    end

    // Fetch Instruction
    always @(posedge clk) begin
        instruction <= instruction_memory[pc[9:2]]; // Fetch instruction
    end
endmodule

