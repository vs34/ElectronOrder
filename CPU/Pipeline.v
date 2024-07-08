module PipelineCPU (
    input wire clk,
    input wire reset
);
    // Define pipeline registers
    reg [31:0] IF_ID_pc, IF_ID_instruction;
    reg [31:0] ID_EX_pc, ID_EX_rs1_data, ID_EX_rs2_data, ID_EX_imm;
    reg [4:0] ID_EX_rs1, ID_EX_rs2, ID_EX_rd;
    reg [6:0] ID_EX_opcode;
    reg [2:0] ID_EX_funct3;
    reg [6:0] ID_EX_funct7;
    reg ID_EX_is_branch, ID_EX_is_load, ID_EX_is_store, ID_EX_is_alu_op;
    reg [31:0] EX_MEM_alu_result, EX_MEM_rs2_data;
    reg [4:0] EX_MEM_rd;
    reg EX_MEM_is_load, EX_MEM_is_store;
    reg [31:0] MEM_WB_mem_data, MEM_WB_alu_result;
    reg [4:0] MEM_WB_rd;
    reg MEM_WB_is_load;

    wire [31:0] pc, next_pc, instruction;
    wire [4:0] rs1, rs2, rd;
    wire [31:0] imm, rs1_data, rs2_data;
    wire [6:0] opcode, funct7;
    wire [2:0] funct3;
    wire [31:0] alu_result, mem_data, write_back_data;
    wire branch_taken;
    wire [31:0] branch_target;

    // IF stage
    Fetcher if_stage (
        .clk(clk),
        .reset(reset),
        .pc_tar(branch_target),
        .pc_tk(branch_taken),
        .pc_out(pc),
        .instruction(instruction)
    );

    // IF/ID pipeline register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_pc <= 32'b0;
            IF_ID_instruction <= 32'b0;
        end else begin
            IF_ID_pc <= pc;
            IF_ID_instruction <= instruction;
        end
    end

    // ID stage
    Decoder id_stage (
        .instruction(IF_ID_instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7),
        .imm(imm),
        .is_branch(is_branch),
        .is_load(is_load),
        .is_store(is_store),
        .is_alu_op(is_alu_op)
    );

    // ID/EX pipeline register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ID_EX_pc <= 32'b0;
            ID_EX_rs1 <= 5'b0;
            ID_EX_rs2 <= 5'b0;
            ID_EX_rd <= 5'b0;
            ID_EX_opcode <= 7'b0;
            ID_EX_funct3 <= 3'b0;
            ID_EX_funct7 <= 7'b0;
            ID_EX_imm <= 32'b0;
            ID_EX_is_branch <= 1'b0;
            ID_EX_is_load <= 1'b0;
            ID_EX_is_store <= 1'b0;
            ID_EX_is_alu_op <= 1'b0;
        end else begin
            ID_EX_pc <= IF_ID_pc;
            ID_EX_rs1 <= rs1;
            ID_EX_rs2 <= rs2;
            ID_EX_rd <= rd;
            ID_EX_opcode <= opcode;
            ID_EX_funct3 <= funct3;
            ID_EX_funct7 <= funct7;
            ID_EX_imm <= imm;
            ID_EX_is_branch <= is_branch;
            ID_EX_is_load <= is_load;
            ID_EX_is_store <= is_store;
            ID_EX_is_alu_op <= is_alu_op;
        end
    end

    // EX stage
    wire [31:0] ex_alu_result;
    wire branch_taken;
    wire [31:0] branch_target;
    if (ID_EX_is_alu_op) begin
        Alu ex_alu (
            .rs1_data(rs1_data),
            .rs2_data(rs2_data),
            .imm(imm),
            .funct3(ID_EX_funct3),
            .funct7(ID_EX_funct7),
            .alu_result(ex_alu_result)
        );
    end
    if (ID_EX_is_branch) begin
        Branch ex_branch (
            .pc(ID_EX_pc),
            .imm(ID_EX_imm),
            .rs1_data(rs1_data),
            .rs2_data(rs2_data),
            .funct3(ID_EX_funct3),
            .branch_taken(branch_taken),
            .branch_target(branch_target)
        );
    end
    if (ID_EX_is_load) begin
        Loader ex_load (
            .imm(ID_EX_imm),
            .rs1_data(rs1_data),
            .rd(ID_EX_rd),
            .funct3(ID_EX_funct3),
            .add(ex_alu_result),
            .data(mem_data)
        );
    end

    // EX/MEM pipeline register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            EX_MEM_alu_result <= 32'b0;
            EX_MEM_rs2_data <= 32'b0;
            EX_MEM_rd <= 5'b0;
            EX_MEM_is_load <= 1'b0;
            EX_MEM_is_store <= 1'b0;
        end else begin
            EX_MEM_alu_result <= ex_alu_result;
            EX_MEM_rs2_data <= rs2_data;
            EX_MEM_rd <= ID_EX_rd;
            EX_MEM_is_load <= ID_EX_is_load;
            EX_MEM_is_store <= ID_EX_is_store;
        end
    end

    // MEM stage
    wire [31:0] mem_data;
    if (EX_MEM_is_load) begin
        // Memory load operation
        mem_data = // Load data from memory using EX_MEM_alu_result as address
    end

    // MEM/WB pipeline register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MEM_WB_mem_data <= 32'b0;
            MEM_WB_alu_result <= 32'b0;
            MEM_WB_rd <= 5'b0;
            MEM_WB_is_load <= 1'b0;
        end else begin
            MEM_WB_mem_data <= mem_data;
            MEM_WB_alu_result <= EX_MEM_alu_result;
            MEM_WB_rd <= EX_MEM_rd;
            MEM_WB_is_load <= EX_MEM_is_load;
        end
    end

    // WB stage
    assign write_back_data = MEM_WB_is_load ? MEM_WB_mem_data : MEM_WB_alu_result;

    // Register file
    Registers reg_file (
        .clk(clk),
        .reset(reset),
        .we(1'b1),  // Write enable signal for now
        .ra1(rs1),
        .ra2(rs2),
        .wa(MEM_WB_rd),
        .wd(write_back_data),
        .rd1(rs1_data),
        .rd2(rs2_data)
    );

endmodule

