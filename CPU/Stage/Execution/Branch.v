module Branch (
    input wire [31:0] pc,          // Current program counter
    input wire [31:0] imm,         // Immediate value (offset for branch)
    input wire [31:0] rs1,         // Source register 1
    input wire [31:0] rs2,         // Source register 2
    input wire [2:0] funct3,       // Branch type (funct3 field)
    output reg branch_taken,  // Branch taken signal
    output reg [31:0] branch_target // Branch target address
);

// Branch operation codes (funct3)
localparam BEQ = 3'b000;
localparam BNE = 3'b001;
localparam BLT = 3'b100;
localparam BGE = 3'b101;
localparam BLTU = 3'b110;
localparam BGEU = 3'b111;

// Determine if the branch is taken
always @(*) begin
    case (funct3)
        BEQ: branch_taken = (rs1 == rs2);
        BNE: branch_taken = (rs1 != rs2);
        BLT: branch_taken = ($signed(rs1) < $signed(rs2));
        BGE: branch_taken = ($signed(rs1) >= $signed(rs2));
        BLTU: branch_taken = (rs1 < rs2);
        BGEU: branch_taken = (rs1 >= rs2);
        default: branch_taken = 1'b0;
    endcase
end

// Calculate branch target address
always @(*) begin
    if (branch_taken) begin
        branch_target = pc + imm;
    end else begin
        branch_target = pc;
    end
end

endmodule

