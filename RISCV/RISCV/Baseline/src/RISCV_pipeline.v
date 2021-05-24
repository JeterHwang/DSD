module RISCV_Pipeline(
    input clk,
    input rst_n,
    // === I cache interface === //
    output ICACHE_ren,
    output ICACHE_wen,
    output [29:0] ICACHE_addr,
    output [31:0] ICACHE_wdata,
    input  ICACHE_stall,
    input  [31:0] ICACHE_rdata,
    // === D cache interface === //
    output DCACHE_ren,
    output DCACHE_wen,
    output [29:0] DCACHE_addr,
    output [31:0] DCACHE_wdata,
    input  DCACHE_stall,
    input  [31:0] DCACHE_rdata
);

// ==== L1 signals ==== //
// input
wire [31:0] instruction_in;
wire        memory_stall; 
// output
wire [31:0] PC_1;
wire [31:0] instruction_1;
// ====================//

// ==== L2 signals ==== //
// output
wire [4:0]  Rd_2;
wire [4:0]  Rs1_2;
wire [4:0]  Rs2_2;
wire [31:0] data1;
wire [31:0] data2;
wire [31:0] immediate;
wire [1:0]  Mem_2;
wire        WriteBack_2;
wire [3:0]  Execution_2;
wire [31:0] branch_address;
wire [31:0] IF_DWrite;
wire        IF_flush;
wire        PC_write;
wire        PC_src;
// ==================== //

// ==== L3 signals ==== //
wire        WriteBack_3;
wire [1:0]  Mem_3;
wire [31:0] ALU_result_3;
wire [31:0] writedata_3;
wire [4:0]  Rd_3;
// ==================== //

// ==== L4 signals ==== //
// output 
wire [31:0] memory_result_4;
wire [31:0] ALU_result_4;
wire [4:0]  Rd_4;
wire        WriteBack_4;
wire        Mem2Reg;
// ==================== //

// ==== L5 signals ==== //
wire [4:0]  Rd_5;
wire [31:0] Wd_5;
wire        Wb_5;
// ==================== //

assign ICACHE_wen   = 1'b0;
assign ICACHE_wdata = 32'd0;

instruction_fetch stage1(
    .clk(clk),
    .rst_n(rst_n),
    .memory_stall(memory_stall),
    .IF_DWrite(IF_DWrite),
    .PC_write(PC_write),
    .PC_src(PC_src),
    .instruction_in(ICACHE_rdata),
    .branch_address(branch_address),
    .I_addr(ICACHE_addr),
    .I_ren(ICACHE_ren),
    .PC_1(PC_1),
    .instruction_1(instruction_1)
);

instruction_decode stage2(
    .clk(clk),
    .rst_n(rst_n),
    .WriteBack_5(Wb_5),
    .write_data(Wd_5),
    .write_address(Rd_5),
    .instruction_1(instruction_1),
    .PC_1(PC_1),
    .Rd_2(Rd_2),
    .Rs1_2(Rs1_2),
    .Rs2_2(Rs2_2),
    .data1(data1),
    .data2(data2),
    .immediate(immediate), 
    .Mem_2(Mem_2),
    .WriteBack_2(WriteBack_2),
    .Execution_2(Execution_2), 
    .branch_address(branch_address),
    .IF_DWrite(IF_DWrite),
    .IF_flush(IF_flush),
    .PC_write(PC_write),
    .PC_src(PC_src)
);

Execution stage3(
    .clk(clk),
    .rst_n(rst_n),
    .data1(data1),
    .data2(data2),
    .immediate(immediate),   
    .Rs1_2(Rs1_2),
    .Rs2_2(Rs2_2),
    .Rd_2(Rd_2),
    .WriteBack_2(WriteBack_2),
    .Mem_2(Mem_2),
    .Execution_2(Execution_2),  
    .writeback_data_5(Wd_5),
    .WriteBack_5(Wb_5),
    .Rd_5(Rd_5),  
    .WriteBack_3(WriteBack_3),
    .Mem_3(Mem_3),
    .ALU_result_3(ALU_result_3),
    .writedata_3(writedata_3),
    .Rd_3(Rd_3)
);

Memory stage4(
    .clk(clk),
    .rst_n(rst_n),
    .ALU_result_3(ALU_result_3),
    .writedata_3(writedata_3),
    .D_readData(DCACHE_rdata),
    .WriteBack_3(WriteBack_3),
    .Mem_3(Mem_3),
    .Rd_3(Rd_3),
    .memory_result_4(memory_result_4),
    .ALU_result_4(ALU_result_4),
    .Rd_4(Rd_4),
    .WriteBack_4(WriteBack_4),
    .Mem2Reg(Mem2Reg),
    .D_addr(DCACHE_addr),
    .D_wen(DCACHE_wen),
    .D_ren(DCACHE_ren),
    .D_writeData(DCACHE_wdata)
);

Writeback stage5(
    .ALU_result_4(ALU_result_4),
    .memory_result_4(memory_result_4),
    .WriteBack_4(WriteBack_4),
    .Mem2Reg(Mem2Reg),
    .Rd_4(Rd_4),
    .Rd_5(Rd_5),
    .writeback_data_5(Wd_5),
    .WriteBack_5(Wb_5)
);

endmodule


module instruction_fetch(
    input         clk,
    input         rst_n,
    input         memory_stall,
    input [31:0]  IF_DWrite,
    input         IF_flush,
    input         PC_write,
    input         PC_src,
    input [31:0]  instruction_in,
    input [31:0]  branch_address,
    output [29:0] I_addr,
    output        I_ren,
    output [31:0] PC_1,
    output [31:0] instruction_1
);

// regs
reg [31:0] PC_r, PC_w;
reg [31:0] PC_out_r, PC_out_w;
reg [31:0] instruction_out_r, instruction_out_w;

// wires
reg [29:0] I_addr_w;
reg I_ren_w;

assign PC_1             = PC_out_r;
assign instruction_1    = instruction_out_r;
assign I_addr           = I_addr_w;
assign I_ren            = I_ren_w;

// ===== PC ===== //
always @(*) begin
    if(PC_write || memory_stall) begin
        PC_w = PC_r;
    end
    else begin
        if(PC_src) // branch taken
            PC_w = branch_address;
        else
            PC_w = PC_r + 4;
    end
end

// ===== PC_out ===== //
always @(*) begin
    if(PC_write) begin // load-use hazard
        PC_out_w = PC_r - 4;
    end
    else if(IF_flush) begin // branch hazard(insert NOP)
        PC_out_w = 32'd0;  
    end
    else begin
        PC_out_w = PC_r;
    end
end

// ===== instruction_out ===== //
always @(*) begin
    if(PC_write) begin
        instruction_out_w = IF_DWrite;
    end
    else if(IF_flush) begin
        instruction_out_w = 32'h00000013; // NOP
    end
    else begin
        instruction_out_w = instruction_in;
    end
end

// ===== I_cache ===== //
always @(*) begin
    I_addr_w            = PC_r[31:2];
    I_ren_w             = 1'b1;  // always reading I_cache
end

always @(posedge clk) begin
    if(!rst_n) begin
        PC_r                <=32'd0;
        PC_out_r            <= 32'd0;
        instruction_out_r   <= 32'd0;
    end
    else begin
        PC_r                <= PC_w;
        PC_out_r            <= PC_out_w;
        instruction_out_r   <= instruction_out_w;
    end
end  
endmodule

module instruction_decode(
    input         clk,
    input         rst_n,
    
    //input [4:0]   Rd_3,
    //input         MemRead_3,
    
    input         WriteBack_5,
    input [31:0]  write_data,
    input [4:0]   write_address, // Rd_5
    
    input [31:0]  instruction_1,
    input [31:0]  PC_1,
    
    output [4:0]  Rd_2,
    output [4:0]  Rs1_2,
    output [4:0]  Rs2_2,
    output [31:0] data1,
    output [31:0] data2,
    output [31:0] immediate,
    
    output [1:0]  Mem_2, // Mem_2[1] : MemRead / Mem_2[0] : MemWrite
    output        WriteBack_2, // MemtoReg
    output [3:0]  Execution_2, // Execution_2[3:1] : ALUOp / Execution_2[0] : ALUsrc
    
    output [31:0] branch_address,
    output [31:0] IF_DWrite,
    output        IF_flush,
    output        PC_write,
    output        PC_src
);

parameter R_type    = 3'd0;
parameter I_type    = 3'd1;
parameter S_type    = 3'd2;
parameter SB_type   = 3'd3;
parameter UJ_type   = 3'd4;
parameter UNDEFINE  = 3'd5;

parameter ADD       = 3'd0;
parameter SUB       = 3'd1;
parameter AND       = 3'd2;
parameter OR        = 3'd3;
parameter XOR       = 3'd4;
parameter SLL       = 3'd5;
parameter SRL       = 3'd6;
parameter SRA       = 3'd7;

integer i;

reg [31:0] register_r [0:31];
reg [31:0] register_w [0:31];

// regs 
reg [4:0]  Rd_r, Rd_w;
reg [4:0]  Rs1_r, Rs1_w;
reg [4:0]  Rs2_r, Rs2_w;
reg [31:0] data1_r, data1_w;
reg [31:0] data2_r, data2_w;
reg [31:0] immediate_r, immediate_w;
reg [1:0]  Mem_r, Mem_w;
reg        WriteBack_r, WriteBack_w;
reg [3:0]  Execution_r, Execution_w;

// wires
reg [31:0] branch_address_w;
reg [31:0] IF_DWrite_w;
reg        IF_flush_w;
reg        PC_write_w;
reg        PC_src_w;

// temporary wires
reg [2:0]  instruction_type;
reg [2:0]  ALUOp;
reg        ALUsrc;
reg [31:0] Rs1_Rs2;
reg        data_hazard;

assign Rd_2             = Rd_r;
assign Rs1_2            = Rs1_r;
assign Rs2_2            = Rs2_r;
assign data1            = data1_r;
assign data2            = data2_r;
assign immediate        = immediate_r;
assign Mem_2            = Mem_r;
assign WriteBack_2      = WriteBack_r;
assign Execution_2      = Execution_r;

assign branch_address   = branch_address_w;
assign IF_DWrite        = IF_DWrite_w;
assign IF_flush         = IF_flush_w;
assign PC_write         = PC_write_w;
assign PC_src           = PC_src_w;


//  ===== instruction type ===== //
always @(*) begin
    case(instruction_1[6:5])
        2'b00: begin
            instruction_type = I_type;
        end
        2'b01: begin
            if(instruction_1[4])
                instruction_type = R_type;
            else
                instruction_type = S_type;
        end
        2'b10: begin
            instruction_type = UNDEFINE;
        end
        2'b11: begin
            if(instruction_1[3:2] == 2'b00)
                instruction_type = SB_type;
            else if(instruction_1[3:2] == 2'b01)
                instruction_type = I_type;
            else
                instruction_type = UJ_type;
        end
    endcase 
end
// ===== decoding ===== //
always @(*) begin
    case (instruction_type)
        R_type: begin
            Rs1_w       = instruction_1[19:15];
            Rs2_w       = instruction_1[24:20];
            Rd_w        = instruction_1[11:7];
            immediate_w = 32'd0;
        end
        I_type: begin
            Rs1_w       = instruction_1[19:15];
            Rs2_w       = 5'd0;
            Rd_w        = instruction_1[11:7];
            immediate_w = {{20{instruction_1[31]}}, instruction_1[31:20]}; // sign extended to 32-bit
        end
        S_type: begin
            Rs1_w       = instruction_1[19:15];
            Rs2_w       = instruction_1[24:20];
            Rd_w        = 5'd0;
            immediate_w = {{20{instruction_1[31]}}, instruction_1[31:25], instruction_1[11:7]}; // sign extended to 32-bit
        end
        SB_type: begin
            Rs1_w       = instruction_1[19:15];
            Rs2_w       = instruction_1[24:20];
            Rd_w        = 5'd0;
            immediate_w = {{19{instruction_1[31]}}, instruction_1[31], instruction_1[7], instruction_1[30:25], instruction_1[11:8], 1'b0}; // sign extended to 32-bit
        end
        UJ_type: begin
            Rs1_w       = 5'd0;
            Rs2_w       = 5'd0;
            Rd_w        = instruction_1[11:7];
            immediate_w = {instruction_1[31:12], 12'd0};
        end
        UNDEFINE: begin
            Rs1_w       = 5'd0;
            Rs2_w       = 5'd0;
            Rd_w        = 5'd0;
            immediate_w = 5'd0;
        end
    endcase
end

// ===== registers ===== //
always @(*) begin 
    data1_w = register_w[Rs1_w];
    data2_w = register_w[Rs2_w];
    
    for(i = 0; i < 32; i = i + 1)
        register_w[i] = register_r[i];
    
    if(WriteBack_5)
        register_w[write_address] = write_data;
end

// ===== branch hazard detection ===== //
always @(*) begin 
    branch_address_w    = $signed(PC_1) + $signed({immediate_w[30:0], 1'b0});
    Rs1_Rs2             = $signed(Rs1_w) - $signed(Rs2_w);
    
    if(instruction_1[6]) begin // branching instructions
        if(instruction_1[2]) begin // JALR, JAL
            IF_flush_w          = 1'b1;
            PC_src_w            = 1'b1;
        end
        else begin
            if(Rs1_Rs2 == 0 && instruction_1[12] == 1'b0) begin // beq branch taken
                IF_flush_w          = 1'b1;
                PC_src_w            = 1'b1;
            end
            else if(Rs1_Rs2 != 0 && instruction_1[12] == 1'b1) begin // bne branch taken
                IF_flush_w          = 1'b1;
                PC_src_w            = 1'b1;
            end
            else begin // branch not taken
                IF_flush_w          = 1'b0;
                PC_src_w            = 1'b0;        
            end    
        end
    end
    else begin // not branching instructions
        IF_flush_w          = 1'b0;
        PC_src_w            = 1'b0;
    end
end

// ===== data hazard detection ===== //
always @(*) begin 
    IF_DWrite_w         = instruction_1;

    if(Mem_r[1] && (Rd_r == Rs1_w || Rd_r == Rs2_w)) begin
        data_hazard     = 1'b1;
        PC_write_w      = 1'b1;
    end
    else begin
        data_hazard     = 1'b0;
        PC_write_w      = 1'b0;
    end
end

// ===== control ===== //
always @(*) begin
    Execution_w = {ALUOp, ALUsrc} & {4{~data_hazard}};
    
    if(instruction_1[6:4] == 3'b000) // lw
        Mem_w = 2'b10 & {2{~data_hazard}};
    else if(instruction_1[6:4] == 3'b010) // sw
        Mem_w = 2'b01 & {2{~data_hazard}};
    else
        Mem_w = 2'b00 & {2{~data_hazard}};
    
    if(instruction_type[2:1]) // SB_type, S_type
        WriteBack_w = 1'b0 & (~data_hazard);
    else
        WriteBack_w = 1'b1 & (~data_hazard);
end

// ===== ALUOp ===== //
always @(*) begin 
    case (instruction_1[13:12]) // FUNCT3
        3'b000: begin
            if(instruction_1[30])
                ALUOp = SUB;
            else
                ALUOp = ADD;
        end    
        3'b001: begin
            ALUOp = SLL;
        end
        3'b010: begin
            if(instruction_1[4])
                ALUOp = SUB;
            else
                ALUOp = ADD;
        end
        3'b100: begin
            ALUOp = XOR;
        end
        3'b101: begin
            if(instruction_1[30])
                ALUOp = SRA;
            else
                ALUOp = SRL;
        end
        3'b110: begin
            ALUOp = OR;
        end
        3'b111: begin
            ALUOp = AND;
        end
        default: begin
            ALUOp = ADD;
        end
    endcase
end

// ===== ALUsrc ===== //
always @(*) begin
    if(instruction_type == R_type) begin
        ALUsrc = 1'b0;
    end
    else begin
        ALUsrc = 1'b1;
    end
end

always @(posedge clk) begin
    if(!rst_n) begin
        for(i = 0; i < 32; i = i + 1)
            register_r[i] <= 32'd0;
        Rd_r        <= 5'd0;
        Rs1_r       <= 5'd0;
        Rs2_r       <= 5'd0;
        data1_r     <= 32'd0;
        data2_r     <= 32'd0;
        immediate_r <= 32'd0;
        Mem_r       <= 2'd0;
        WriteBack_r <= 1'b0;
        Execution_r <= 4'd0;
    end
    else begin
        for(i = 0; i < 32; i = i + 1)
            register_r[i] <= register_w[i];
        Rd_r        <= Rd_w;
        Rs1_r       <= Rs1_w;
        Rs2_r       <= Rs2_w;
        data1_r     <= data1_w;
        data2_r     <= data2_w;
        immediate_r <= immediate_w;
        Mem_r       <= Mem_w;
        WriteBack_r <= WriteBack_w;
        Execution_r <= Execution_w;
    end
end
endmodule

module Execution(
    input         clk,
    input         rst_n,
    
    input [31:0]  data1,
    input [31:0]  data2,
    input [31:0]  immediate,   
    input [4:0]   Rs1_2,
    input [4:0]   Rs2_2,
    input [4:0]   Rd_2,
    
    input         WriteBack_2,
    input [1:0]   Mem_2,
    input [3:0]   Execution_2,  // {ALUOp, ALUsrc}
    
    // input         WriteBack_4,
    // input [4:0]   Rd_4,
    // input [31:0]  ALU_result_4,
    
    input [31:0]  writeback_data_5,
    input         WriteBack_5,
    input [4:0]   Rd_5,  
    
    output        WriteBack_3,
    output [1:0]  Mem_3,
    output [31:0] ALU_result_3,
    output [31:0] writedata_3, // memory write data
    output [4:0]  Rd_3
);

parameter ADD       = 3'd0;
parameter SUB       = 3'd1;
parameter AND       = 3'd2;
parameter OR        = 3'd3;
parameter XOR       = 3'd4;
parameter SLL       = 3'd5;
parameter SRL       = 3'd6;
parameter SRA       = 3'd7;

reg [1:0]  Mem_r, Mem_w;
reg        WriteBack_r, WriteBack_w;
reg [4:0]  Rd_r, Rd_w;
reg [31:0] ALU_result_r, ALU_result_w;
reg [31:0] writedata_r, writedata_w;

reg [31:0] ALU_in1;
reg [31:0] ALU_in2;
reg [1:0] forwardA;
reg [1:0] forwardB;

assign WriteBack_3  = WriteBack_r;
assign Mem_3        = Mem_r;
assign ALU_result_3 = ALU_result_r;
assign writedata_3  = writedata_r;
assign Rd_3         = Rd_r;

always @(*) begin // forwarding unit
    if(WriteBack_r && Rd_r != 0 && Rd_5 == Rs1_2) begin
        if(!(WriteBack_5 && Rd_5 != 0 && Rd_5 == Rs1_2)) begin
            forwardA = 2'b01;
        end
        else begin
            forwardA = 2'b10;
        end
    end
    else begin
        forwardA = 2'b00;
    end

    if(WriteBack_r && Rd_r != 0 && Rd_5 == Rs2_2) begin
        if(!(WriteBack_5 && Rd_5 != 0 && Rd_5 == Rs2_2)) begin
            forwardB = 2'b01;
        end
        else begin
            forwardB = 2'b10;
        end
    end
    else begin
        forwardB = 2'b00;
    end
end

// ===== ALU input 1 ===== //
always @(*) begin
    case (forwardA)
        2'b00: begin
            ALU_in1 = data1;
        end
        2'b01: begin
            ALU_in1 = ALU_result_r;
        end
        2'b10: begin
            ALU_in1 = writeback_data_5;
        end
        default: begin
            ALU_in1 = data1;
        end
    endcase
end

// ===== ALU input 2 ===== //
always @(*) begin
    if(Execution_2[0]) begin // (ALUsrc == 1) => immediate
        case (forwardB)
            2'b00: begin
                ALU_in2 = immediate;
            end
            2'b01: begin
                ALU_in2 = ALU_result_r;
            end
            2'b10: begin
                ALU_in2 = writeback_data_5;
            end
            default: begin
                ALU_in2 = immediate;
            end
        endcase
    end
    else begin
        case (forwardB)
            2'b00: begin
                ALU_in2 = data2;
            end
            2'b01: begin
                ALU_in2 = ALU_result_r;
            end
            2'b10: begin
                ALU_in2 = writeback_data_5;
            end
            default: begin
                ALU_in2 = data2;
            end
        endcase
    end
end

// ===== ALU control ===== //
always @(*) begin 
    case(Execution_2[3:1])
        ADD: begin
            ALU_result_w = $signed(ALU_in1) + $signed(ALU_in2);
        end
        SUB: begin
            ALU_result_w = $signed(ALU_in1) - $signed(ALU_in2);
        end
        AND: begin
            ALU_result_w = ALU_in1 & ALU_in2;
        end
        OR: begin
            ALU_result_w = ALU_in1 | ALU_in2;
        end
        XOR: begin
            ALU_result_w = ALU_in1 ^ ALU_in2;
        end
        SLL: begin
            ALU_result_w = ALU_in1 << ALU_in2;
        end
        SRL: begin
            ALU_result_w = ALU_in1 >> ALU_in2;
        end
        SRA: begin
            ALU_result_w = $signed(ALU_in1) >>> ALU_in2;
        end
    endcase
end

// ===== passing signals ===== //
always @(*) begin
    Mem_w           = Mem_2;
    WriteBack_w     = WriteBack_2;
    Rd_w            = Rd_2;
    
    writedata_w     = ALU_in2;
end

always @(posedge clk) begin
    if(!rst_n) begin
        Mem_r           <= 2'd0;
        WriteBack_r     <= 1'b0;
        Rd_r            <= 5'd0;
        ALU_result_r    <= 32'd0;
        writedata_r     <= 32'd0;
    end
    else begin
        Mem_r           <= Mem_w;
        WriteBack_r     <= WriteBack_w;
        Rd_r            <= Rd_w;
        ALU_result_r    <= ALU_result_w;
        writedata_r     <= writedata_w;
    end
end
endmodule

module Memory(
    input         clk,
    input         rst_n,
    
    input [31:0]  ALU_result_3,
    input [31:0]  writedata_3,
    
    input [31:0]  D_readData,
    
    input         WriteBack_3,
    input [1:0]   Mem_3,
    input [4:0]   Rd_3,
    
    output [31:0] memory_result_4,
    output [31:0] ALU_result_4,
    
    output [4:0]  Rd_4,
    output        WriteBack_4,
    output        Mem2Reg,
    
    output [29:0] D_addr,
    output        D_wen,
    output        D_ren,
    output [31:0] D_writeData
);

reg [31:0] memory_result_r, memory_result_w;
reg [31:0] ALU_result_r, ALU_result_w;
reg [4:0]  Rd_r, Rd_w;
reg        WriteBack_r, WriteBack_w;

assign memory_result_4  = memory_result_r;
assign ALU_result_4     = ALU_result_r;
assign Rd_4             = Rd_r;
assign WriteBack_4      = WriteBack_r;
assign Mem2Reg          = Mem_3[1]; // lw 

assign D_addr           = ALU_result_3[31:2];
assign D_wen            = Mem_3[0];
assign D_ren            = Mem_3[1];
assign D_writeData      = writedata_3;


always @(*) begin // data memory
    memory_result_w = D_readData;
    ALU_result_w    = ALU_result_3;
    Rd_w            = Rd_3;
    WriteBack_w     = WriteBack_3;    
end  

always @(posedge clk) begin
    if(!rst_n) begin
        memory_result_r <= 32'd0;
        ALU_result_r    <= 32'd0;
        Rd_r            <= 5'd0;
        WriteBack_r     <= 1'b0;
    end
    else begin
        memory_result_r <= memory_result_w;
        ALU_result_r    <= ALU_result_w;
        Rd_r            <= Rd_w;
        WriteBack_r     <= WriteBack_w;
    end
end
endmodule

module Writeback( // no sequential circuits
    input [31:0]  ALU_result_4,
    input [31:0]  memory_result_4,
    input         WriteBack_4,
    input         Mem2Reg,
    input [4:0]   Rd_4,
    
    output [4:0]  Rd_5,
    output [31:0] writeback_data_5,
    output        WriteBack_5
);
    assign Rd_5             = Rd_4;
    assign writeback_data_5 = Mem2Reg ? memory_result_4 : ALU_result_4;
    assign WriteBack_5      = WriteBack_4;

endmodule