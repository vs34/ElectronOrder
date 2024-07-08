module Loader (
  input wire [31:0] imm,       // Immediate value from the instruction
  input wire [31:0] rs1,        // Source register 1
  input wire [4:0] rd,         // Destination register
  input wire [2:0] func3,      // funct3 field to determine the type of load
  output reg [4:0] add,        // Address to read/write
  output reg [31:0] data       // Data to be loaded
);

  // Load operation codes (funct3)
  localparam LB  = 3'b000;
  localparam LH  = 3'b001;
  localparam LW  = 3'b010;
  localparam LBU = 3'b100;
  localparam LHU = 3'b101;

  always @(*) begin
    // Default values
    add = 0;
    data = 0;
    
    case (func3)
      LB, LH, LW, LBU, LHU: begin
        // Compute the address based on rs1 and immediate value
        add = rs1 + imm[4:0];  // Assuming imm[4:0] is the offset part of immediate
        data = imm;            // Set data to the immediate value
      end
      default: begin
        // Handle unsupported funct3 values if needed
        add = 0;
        data = 0;
      end
    endcase
  end
endmodule

