module Registers (
    input wire clk,                // Clock signal
    input wire reset,              // Reset signal
    input reg we,                 // Write enable
    input reg re,                  // Read enable
    input wire [4:0] ra1,          // Read address 1
    input wire [4:0] ra2,          // Read address 2
    input reg [4:0] wa,           // Write address
    input reg [31:0] wd,          // Write data
    output wire [31:0] rd1,        // Read data 1
    output wire [31:0] rd2,         // Read data 2
    output wire wr,                 // write ready
    output wire rr                  // read ready
);
    // Declare the register file as an array of 32 32-bit registers
    reg [31:0] registers [31:0];
    integer i;
    // Read operation (combinational)
    assign rd1 = (ra1 == 5'd0) ? 32'd0 : registers[ra1]; // Read register x0 always returns 0
    assign rd2 = (ra2 == 5'd0) ? 32'd0 : registers[ra2]; // Read register x0 always returns 0
    // assign wr = ~re | ~we;
    always @(*) begin 
        if (wa == ra1 | wa == ra2) begin
            assign rr = 0;
        end else begin
            assign rr = 1;
        end
    end
    // Write operation (sequential)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers to 0 (optional)
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'd0;
            end
        end else if (we && (wa != 5'd0)) begin
            // Write to the register (except x0)
            registers[wa] <= wd;
            wr <= 1'b0; // Set wr low after write operation
        end else begin
            wr <= 1'b1; // Set wr high when not writing
        end
    end
endmodule

