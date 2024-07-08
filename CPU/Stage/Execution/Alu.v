module Alu (
    input wire [4:0] rd,            // Destination register
    input wire [2:0] funct3,        // funct3 field
    input wire [31:0] rs1,           // Source register 1
    input wire [31:0] rs2,           // Source register 2
    input wire [6:0] funct7,        // funct7 field
    input wire [31:0] imm,           // Immediate value
    output reg [31:0] result         // Result of the ALU operation
);
    always @(*) begin
        result = 32'd0; // Default result
        case (funct7)
            7'b0000000: begin // R-type instructions (funct7 == 0)
                case (funct3)
                    3'b000: result = rs1 + rs2;     // ADD
                    3'b001: result = rs1 << rs2[4:0]; // SLL (Shift Left Logical)
                    3'b010: result = ($signed(rs1) < $signed(rs2)) ? 32'b1 : 32'b0; // SLT (Set Less Than)
                    3'b011: result = (rs1 < rs2) ? 32'b1 : 32'b0; // SLTU (Set Less Than Unsigned)
                    3'b100: result = rs1 ^ rs2;     // XOR
                    3'b101: result = rs1 >> rs2[4:0]; // SRL (Shift Right Logical)
                    3'b110: result = rs1 | rs2;     // OR
                    3'b111: result = rs1 & rs2;     // AND
                endcase
            end
            7'b0100000: begin // R-type instructions (funct7 == 0x20)
                case (funct3)
                    3'b000: result = rs1 - rs2;     // SUB
                    3'b101: result = $signed(rs1) >>> rs2[4:0]; // SRA (Shift Right Arithmetic)
                endcase
            end
            7'b0000001: begin // R-type instructions for MUL/DIV
                case (funct3)
                    3'b000: result = rs1 * rs2;     // MUL
                    3'b100: result = $signed(rs1) / $signed(rs2); // DIV
                    3'b110: result = rs1 / rs2;     // DIVU (Unsigned)
                    3'b011: result = $signed(rs1) % $signed(rs2); // REM (Remainder)
                    3'b111: result = rs1 % rs2;     // REMU (Unsigned Remainder)
                endcase
            end
            default: begin
                case (funct3)
                    3'b000: result = rs1 + imm;     // ADDI
                    3'b001: result = rs1 << imm[4:0]; // SLLI (Shift Left Logical Immediate)
                    3'b010: result = ($signed(rs1) < $signed(imm)) ? 32'b1 : 32'b0; // SLTI (Set Less Than Immediate)
                    3'b011: result = (rs1 < imm) ? 32'b1 : 32'b0; // SLTIU (Set Less Than Immediate Unsigned)
                    3'b100: result = rs1 ^ imm;     // XORI
                    3'b101: result = imm[10] ? $signed(rs1) >>> imm[4:0] : rs1 >> imm[4:0]; // SRLI and SRAI
                    3'b110: result = rs1 | imm;     // ORI
                    3'b111: result = rs1 & imm;     // ANDI
                endcase
            end
        endcase
    end
endmodule

