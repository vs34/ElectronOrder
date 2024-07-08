module Decoder (
    input wire [31:0] instruction,  // 32-bit instruction
    output reg [6:0] opcode,        // Opcode field
    output reg [4:0] rd,            // Destination register
    output reg [2:0] funct3,        // funct3 field
    output reg [31:0] rs1,           // Source register 1
    output reg [31:0] rs2,           // Source register 2
    output reg [6:0] funct7,        // funct7 field
    output reg [31:0] imm,          // Immediate value
    output reg is_branch,           // Branch flag
    output reg is_load,             // Load flag
    output reg is_store,            // Store flag
    output reg is_alu_op            // ALU operation flag
    // output reg type                 // is the given instruction is R or I for alu
);

    always @(*) begin
        // Extract common fields
        opcode  = instruction[6:0];
        rd      = instruction[11:7];
        funct3  = instruction[14:12];
        rs1_add = instruction[19:15];
        rs2_add = instruction[24:20];
        funct7  = instruction[31:25];
        // type    = instruction[7];

        Registers GetVelue_rs (    
            // .clk(1'b0),             // Clock signal
            // .reset(1'b0),           // Reset signal
            // .we(1'b0),              // Write enable
            // .ra1(rs1_add),          // Read address 1
            // .ra2(rs2_add),          // Read address 2
            // .wa,                    // Write address
            // .wd,                    // Write data
            .rd1(rs1),              // Read data 1
            .rd2(rs2)               // Read data 2
        );

        // Default values
        imm = 32'b0;
        is_branch = 0;
        is_load = 0;
        is_store = 0;
        is_alu_op = 0;

        // Decode based on opcode
        case (opcode)
            7'b0110011: begin // R-type
                is_alu_op = 1; // BACKBONE DONE
            end
            7'b0010011: begin // I-type (Immediate ALU operations)
                is_alu_op = 1; // BACKBONE DONE
                imm = {{20{instruction[31]}}, instruction[31:20]}; // Sign-extended immediate
            end
            7'b0000011: begin // I-type (Load)
                is_load = 1;
                imm = {{20{instruction[31]}}, instruction[31:20]}; // Sign-extended immediate
            end
            7'b0100011: begin // S-type (Store)
                is_store = 1;
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // Sign-extended immediate
            end
            7'b1100011: begin // B-type (Branch)
                is_branch = 1; // BACKBONE DONE
                imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // Sign-extended immediate
            end
            7'b0110111, // U-type (LUI)
            7'b0010111: begin // U-type (AUIPC)
                imm = {instruction[31:12], 12'b0}; // Upper immediate
            end
            7'b1101111: begin // J-type (JAL)
                imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // Sign-extended immediate
            end
            // Other opcodes can be added here
        endcase
    end

endmodule

