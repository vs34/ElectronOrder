module Fetcher (
    input wire clk,                // Clock signal
    input wire reset,              // Reset signal
    input wire [31:0] branch_target, // Branch target address if next instruction is to branch
    input wire branch_taken,       // Branch taken signal
    output reg [31:0] pc,          // Program Counter
    output wire [31:0] instruction, // Current instruction
    output reg [31:0] address,     // Address to access RAM
    output reg read                // Read signal to access RAM
);
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

    // Address and read logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            address <= 32'b0; // Initialize address to zero on reset
            read <= 1'b0;     // Initialize read signal to low on reset
        end else begin
            address <= pc;    // Set address to current PC value
            read <= 1'b1;     // Set read signal high to read from RAM
        end
    end
endmodule

