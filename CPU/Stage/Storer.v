module Storer (
    input wire clk,
    input wire reset,
    input wire we,                // Write enable
    input wire [4:0] wa,          // Write address
    input wire [31:0] wd,         // Write data
    output reg wr                 // Write ready
);
    // Instantiate the Registers module
    wire [31:0] rd1, rd2;
    wire rr; // Read ready (not used in storer)

    Registers registers_inst (
        .clk(clk),
        .reset(reset),
        .we(we),
        .re(1'b0), // No read enable for storer
        .ra1(5'd0), // No read address 1
        .ra2(5'd0), // No read address 2
        .wa(wa),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2),
        .wr(wr),
        .rr(rr)
    );

    // Sequential logic to update wr signal
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr <= 1'b1; // Set wr high when reset
        end else if (we) begin
            wr <= 1'b0; // Set wr low after write operation
        end else begin
            wr <= 1'b1; // Set wr high when not writing
        end
    end
endmodule

