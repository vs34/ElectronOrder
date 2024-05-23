module ALU (
    input [31:0] A, // First operand
    input [31:0] B, // Second operand
    input [3:0] ALUop, // Operation select
    input Cin, // Carry in
    output reg [31:0] Result, // Result
    output reg Z, // Zero flag
    output reg C, // Carry flag
    output reg V, // Overflow flag
    output reg N // Negative flag
);

always @(*) begin
    case (ALUop)
        4'b0000: Result = A + B; // ADD
        4'b0001: Result = A - B; // SUB
        4'b0010: Result = A & B; // AND
        4'b0011: Result = A | B; // OR
        4'b0100: Result = A ^ B; // XOR
        4'b0101: Result = ~A; // NOT
        4'b0110: Result = A << B; // SLL
        4'b0111: Result = A >> B; // SRL
        4'b1000: Result = $signed(A) >>> B; // SRA
        4'b1001: Result = (A < B) ? 32'b1 : 32'b0; // SLT
        4'b1010: Result = (A < B) ? 32'b1 : 32'b0; // SLTU
        default: Result = 32'b0; // Default case
    endcase
    
    // Update status flags
    Z = (Result == 32'b0);
    C = (ALUop == 4'b0000) && (A + B > 32'hFFFFFFFF);
    V = (ALUop == 4'b0000) && ((A[31] & B[31] & ~Result[31]) | (~A[31] & ~B[31] & Result[31]));
    N = Result[31];
end

endmodule

