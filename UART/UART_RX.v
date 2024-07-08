module UART_RX (
    input wire clk,
    input wire reset,
    input wire rx,
    output reg [7:0] data_out,
    output reg ready
);
    parameter CLK_FREQ = 50000000;  // 50 MHz
    parameter BAUD_RATE = 9600;
    localparam BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    reg [3:0] state;
    reg [13:0] bit_timer;
    reg [3:0] bit_count;
    reg [9:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            bit_timer <= 0;
            bit_count <= 0;
            shift_reg <= 10'b1111111111;
            ready <= 1'b0;
        end else begin
            case (state)
                0: begin  // Idle state
                    if (!rx) begin  // Start bit detected
                        state <= 1;
                        bit_timer <= 0;
                    end
                    ready <= 1'b0;
                end
                1: begin  // Start bit verification
                    if (bit_timer == (BIT_PERIOD / 2) - 1) begin
                        if (!rx) begin  // Start bit still valid
                            state <= 2;
                            bit_timer <= 0;
                            bit_count <= 0;
                        end else begin  // False start bit, go back to idle
                            state <= 0;
                        end
                    end else begin
                        bit_timer <= bit_timer + 1;
                    end
                end
                2: begin  // Receiving bits
                    if (bit_timer == BIT_PERIOD - 1) begin
                        bit_timer <= 0;
                        shift_reg <= {rx, shift_reg[9:1]};
                        if (bit_count == 9) begin
                            state <= 0;
                            bit_count <= 0;
                            data_out <= shift_reg[8:1];  // Extract data bits
                            ready <= 1'b1;
                        end else begin
                            bit_count <= bit_count + 1;
                        end
                    end else begin
                        bit_timer <= bit_timer + 1;
                    end
                end
            endcase
        end
    end
endmodule

