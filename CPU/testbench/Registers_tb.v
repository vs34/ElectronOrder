module Registers_tb;
    // Inputs
    reg clk;
    reg reset;
    reg we;
    reg [4:0] ra1;
    reg [4:0] ra2;
    reg [4:0] wa;
    reg [31:0] wd;

    // Outputs
    wire [31:0] rd1;
    wire [31:0] rd2;

    // Instantiate the Registers module
    Registers uut (
        .clk(clk),
        .reset(reset),
        .we(we),
        .ra1(ra1),
        .ra2(ra2),
        .wa(wa),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generation
    always #11 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        we = 0;
        ra1 = 0;
        ra2 = 0;
        wa = 0;
        wd = 0;

        // Open VCD file for GTKWave
        $dumpfile("Registers_tb.vcd");
        $dumpvars(0, Registers_tb);

        // Wait 10 ns for global reset to finish
        #10;
        reset = 0;

        // Write to register 1
        we = 1;
        wa = 5'd1;
        wd = 32'hAAAA_BBBB;
        #10;

        // Write to register 2
        wa = 5'd2;
        wd = 32'hCCCC_DDDD;
        #10;

        // Disable write enable
        we = 0;

        // Read from register 1
        ra1 = 5'd1;
        #10;
        if (rd1 !== 32'hAAAA_BBBB) $display("Test Failed: Read from register 1");
        #5;
        // Read from register 2
        ra2 = 5'd2;
        #10;
        if (rd2 !== 32'hCCCC_DDDD) $display("Test Failed: Read from register 2");

        // Ensure register x0 always returns 0
        ra1 = 5'd0;
        ra2 = 5'd0;
        #10;
        if (rd1 !== 32'h0000_0000 || rd2 !== 32'h0000_0000) $display("Test Failed: Read from register x0");

        // Write to register x0 (should have no effect)
        we = 1;
        wa = 5'd0;
        wd = 32'hFFFF_FFFF;
        #10;
        we = 0;
        ra1 = 5'd0;
        #10;
        if (rd1 !== 32'h0000_0000) $display("Test Failed: Write to register x0");
        
        $display("All tests passed");
        $stop;
    end
endmodule

