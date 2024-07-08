module UART_TX (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire start,
    output reg tx,
    output reg busy
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
            tx <= 1'b1;
            busy <= 1'b0;
        end else begin
            case (state)
                0: begin  // Idle state
                    tx <= 1'b1;
                    busy <= 1'b0;
                    if (start) begin
                        shift_reg <= {1'b1, data_in, 1'b0};  // Start bit, data, stop bit
                        state <= 1;
                        busy <= 1'b1;
                    end
                end
                1: begin  // Transmitting bits
                    if (bit_timer == BIT_PERIOD - 1) begin
                        bit_timer <= 0;
                        tx <= shift_reg[0];
                        shift_reg <= shift_reg >> 1;
                        if (bit_count == 9) begin
                            state <= 0;
                            bit_count <= 0;
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

