module Registers (
    input wire clk,                // Clock signal
    input wire reset,              // Reset signal
    input wire we,                 // Write enable
    input wire [4:0] ra1,          // Read address 1
    input wire [4:0] ra2,          // Read address 2
    input wire [4:0] wa,           // Write address
    input wire [31:0] wd,          // Write data
    output wire [31:0] rd1,        // Read data 1
    output wire [31:0] rd2         // Read data 2
);
    // Declare the register file as an array of 32 32-bit registers
    reg [31:0] registers [31:0];

    // Read operation (combinational)
    assign rd1 = (ra1 == 5'd0) ? 32'd0 : registers[ra1]; // Read register x0 always returns 0
    assign rd2 = (ra2 == 5'd0) ? 32'd0 : registers[ra2]; // Read register x0 always returns 0

    // Write operation (sequential)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers to 0 (optional)
            integer i;
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'd0;
            end
        end else if (we && (wa != 5'd0)) begin
            // Write to the register (except x0)
            registers[wa] <= wd;
        end
    end
endmodule

