module instruction_decode(
    input         clk,
    input         rst_n,
    input         memory_stall,
    input         WriteBack_5,
    input  [31:0] write_data,
    input  [4:0]  write_address, // Rd_5
    
    
    input         prev_taken_1,
    input         flush,

    input  [29:0] instruction_1,
    input  [7:0]  PC_1,
    
    output [4:0]  Rd_2,
    output [4:0]  Rs1_2,
    output [4:0]  Rs2_2,
    output [31:0] data1,
    output [31:0] data2,
    output [31:0] immediate,
    
    output        is_branchInst_2,
    output [1:0]  branch_type_2,
    output [7:0]  PC_2,
    output        prev_taken_2,

    output [1:0]  Mem_2,        // Mem_2[1] : MemRead / Mem_2[0] : MemWrite
    output        WriteBack_2,  // MemtoReg
    output [4:0]  Execution_2,  // Execution_2[3:1] : ALUOp / Execution_2[0] : ALUsrc
    
    output [29:0] IF_DWrite,
    output        PC_write

);

parameter R_type    = 3'd0;
parameter I_type    = 3'd1;
parameter S_type    = 3'd2;
parameter SB_type   = 3'd3;
parameter UJ_type   = 3'd4;
parameter UNDEFINE  = 3'd5;

parameter ADD       = 4'd0;
parameter SUB       = 4'd1;
parameter AND       = 4'd2;
parameter OR        = 4'd3;
parameter XOR       = 4'd4;
parameter SLL       = 4'd5;
parameter SRL       = 4'd6;
parameter SRA       = 4'd7;
parameter SLT       = 4'd8;

parameter JAL       = 2'd0;
parameter JALR      = 2'd1;
parameter BEQ       = 2'd2;
parameter BNE       = 2'd3;


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
reg [4:0]  Execution_r, Execution_w;
reg [7:0]  PC_r, PC_w;
reg        taken_r, taken_w;
reg        is_branchInst_r, is_branchInst_w;
reg [1:0]  branch_type_r, branch_type_w;

// wires
reg [29:0] IF_DWrite_w;
reg        PC_write_w;
reg [31:0] reg1, reg2;

// temporary wires
reg [2:0]  instruction_type;
reg [3:0]  ALUOp;
reg        ALUsrc;
reg        data_hazard;

assign Rd_2             = Rd_r;
assign Rs1_2            = Rs1_r;
assign Rs2_2            = Rs2_r;
assign data1            = data1_r;
assign data2            = data2_r;
assign immediate        = immediate_r;

assign is_branchInst_2  = is_branchInst_r;
assign PC_2             = PC_r;
assign prev_taken_2     = taken_r;
assign branch_type_2    = branch_type_r;

assign Mem_2            = Mem_r;
assign WriteBack_2      = WriteBack_r;
assign Execution_2      = Execution_r;

assign IF_DWrite        = IF_DWrite_w;
assign PC_write         = PC_write_w;


//  ===== opt ===== //
wire SB,SW,LW,R,I,UJ,JALr;
assign SB   = instruction_1[4]^instruction_1[0];
assign SW   = (~instruction_1[4]^instruction_1[2])&instruction_1[3];
assign LW   = ~(instruction_1[3]|instruction_1[2]);
assign R    = instruction_1[3]&instruction_1[2];
assign I    = (~instruction_1[3])&instruction_1[2];
assign UJ   = instruction_1[1];
assign JALr = instruction_1[1]^instruction_1[0];

//  ===== instruction type ===== //
always @(*) begin
    case(instruction_1[4:3])
        2'b00: begin
            instruction_type = I_type;
        end
        2'b01: begin
            if(instruction_1[2])
                instruction_type = R_type;
            else
                instruction_type = S_type;
        end
        2'b10: begin
            instruction_type = UNDEFINE;
        end
        2'b11: begin
            if(instruction_1[1:0] == 2'b00)
                instruction_type = SB_type;
            else if(instruction_1[1:0] == 2'b01)
                instruction_type = I_type;
            else
                instruction_type = UJ_type;
        end
    endcase 
end
// ===== decoding ===== //

always @(*) begin
    if(memory_stall) begin
        Rs1_w       = Rs1_r;
        Rs2_w       = Rs2_r;
        Rd_w        = Rd_r;
        immediate_w = immediate_r;
    end
    else begin
        Rs1_w = instruction_1[17:13];
        Rs2_w = instruction_1[22:18];
        Rd_w  = instruction_1[9:5];
        immediate_w = 32'd0;
        case (instruction_type)
            I_type: immediate_w = {{20{instruction_1[29]}}, instruction_1[29:18]}; // sign extended to 32-bit
            S_type: immediate_w = {{20{instruction_1[29]}}, instruction_1[29:23], instruction_1[9:5]}; // sign extended to 32-bit
            SB_type:immediate_w = {{20{instruction_1[29]}}, instruction_1[5], instruction_1[28:23], instruction_1[9:6], 1'b0}; // sign extended to 32-bit
            UJ_type:immediate_w = {{12{instruction_1[29]}}, instruction_1[17:10], instruction_1[18], instruction_1[28:19], 1'b0};
        endcase    
    end
end

// ===== registers ===== //
always @(*) begin 
    for(i = 0; i < 32; i = i + 1)
        register_w[i] = register_r[i];
    
    if(!memory_stall && write_address != 0 && WriteBack_5)
        register_w[write_address] = write_data;
    // -------------------------------------------------------   
    reg1 = register_w[Rs1_w];
    reg2 = register_w[Rs2_w];

    if(~memory_stall&(flush|data_hazard)) data1_w = 32'd0;
    else data1_w = reg1;
    // ---------------------------------------------------------
    if(~memory_stall&(flush|data_hazard)) data2_w = 32'd0;
    else data2_w = reg2;
end

// ===== Branch Information ===== //
always @(*) begin
    PC_w = (memory_stall) ? PC_r : PC_1;
    is_branchInst_w = (memory_stall) ? is_branchInst_r : instruction_1[4]&(~flush);
    //taken_w
    if(memory_stall) taken_w     = taken_r;
    else if(flush)   taken_w     = 1'b0;
    else             taken_w     = prev_taken_1;

    if(memory_stall | flush) begin
        branch_type_w = branch_type_r;    
    end
    else begin
        case (instruction_1[1:0])
            2'b00: begin
                if(instruction_1[10]) branch_type_w = BNE;
                else branch_type_w = BEQ;
            end
            2'b01:   branch_type_w = JALR;
            2'b11:   branch_type_w = JAL;
            default: branch_type_w = BNE; // meaningless !!
        endcase
    end 
end

// ===== data hazard detection ===== //

always @(*) begin 
    IF_DWrite_w     = instruction_1;
    data_hazard     = 1'b0;
    PC_write_w      = 1'b0;  
    if(Rd_r == Rs1_w || Rd_r == Rs2_w) begin
        data_hazard = Mem_r[1];
        PC_write_w  = Mem_r[1];    
    end
end

// ===== control ===== //
always @(*) begin
    if(memory_stall) Execution_w = Execution_r;    
    else Execution_w = {ALUOp, ALUsrc};

    if(memory_stall) Mem_w = Mem_r;
    else if(flush)   Mem_w = 2'b00;
    else             Mem_w = ({LW,SW})&{2{~data_hazard}};
    
    if(memory_stall) WriteBack_w = WriteBack_r;
    else WriteBack_w = (~flush)&(~SB)&(~SW)&(~data_hazard);    
end

// ===== ALUOp ===== //
always @(*) begin 
    if(instruction_1[1]) begin //jal (not have funct 3)
        ALUOp = ADD;   
    end
    else begin
        case (instruction_1[12:10]) // FUNCT3
            3'b000: begin
                if(instruction_1[4:3] == 2'b01) begin// R-type
                    if(instruction_1[28])   // SUB
                        ALUOp = SUB;
                    else                    // ADD
                        ALUOp = ADD;
                end
                else begin
                    if({instruction_1[4], instruction_1[0]} == 2'b10) //BEQ
                        ALUOp = SUB;
                    else                    // I type
                        ALUOp = ADD;
                end
            end    
            3'b001: begin
                if(instruction_1[4]) // BNE
                    ALUOp = SUB;
                else
                    ALUOp = SLL;
            end
            3'b010: begin
                if(instruction_1[2])
                    ALUOp = SLT;
                else
                    ALUOp = ADD;
            end
            3'b100: begin
                ALUOp = XOR;
            end
            3'b101: begin
                if(instruction_1[28])
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
end

// ===== ALUsrc ===== //
always @(*) begin
    ALUsrc = (~SB)&(~R);
end

always @(posedge clk) begin
    if(!rst_n) begin
        for(i = 0; i < 32; i = i + 1)
            register_r[i]   <= 32'd0;
        Rd_r                <= 5'd0;
        Rs1_r               <= 5'd0;
        Rs2_r               <= 5'd0;
        data1_r             <= 32'd0;
        data2_r             <= 32'd0;
        immediate_r         <= 32'd0;
        Mem_r               <= 2'd0;
        WriteBack_r         <= 1'b0;
        Execution_r         <= 5'd0;
        PC_r                <= 8'd0;
        is_branchInst_r     <= 1'b0;
        taken_r             <= 1'b0;
        branch_type_r       <= 2'b00;
    end
    else begin
        for(i = 0; i < 32; i = i + 1)
            register_r[i]   <= register_w[i];
        Rd_r                <= Rd_w;
        Rs1_r               <= Rs1_w;
        Rs2_r               <= Rs2_w;
        data1_r             <= data1_w;
        data2_r             <= data2_w;
        immediate_r         <= immediate_w;
        Mem_r               <= Mem_w;
        WriteBack_r         <= WriteBack_w;
        Execution_r         <= Execution_w;
        PC_r                <= PC_w;
        is_branchInst_r     <= is_branchInst_w;
        taken_r             <= taken_w;
        branch_type_r       <= branch_type_w;
    end
end
endmodule

/*
module instruction_decode(
    input         clk,
    input         rst_n,
    input         memory_stall,
    input         WriteBack_5,
    input  [31:0] write_data,
    input  [4:0]  write_address, // Rd_5
    
    
    input         prev_taken_1,
    input         flush,

    input  [29:0] instruction_1,
    input  [31:0] PC_1,
    
    output [4:0]  Rd_2,
    output [4:0]  Rs1_2,
    output [4:0]  Rs2_2,
    output [31:0] data1,
    output [31:0] data2,
    output [31:0] immediate,
    
    output        is_branchInst_2,
    output [1:0]  branch_type_2,
    output [31:0] PC_2,
    output        prev_taken_2,

    output [1:0]  Mem_2,        // Mem_2[1] : MemRead / Mem_2[0] : MemWrite
    output        WriteBack_2,  // MemtoReg
    output [4:0]  Execution_2,  // Execution_2[3:1] : ALUOp / Execution_2[0] : ALUsrc
    
    output [29:0] IF_DWrite,
    output        PC_write

);

parameter R_type    = 3'd0;
parameter I_type    = 3'd1;
parameter S_type    = 3'd2;
parameter SB_type   = 3'd3;
parameter UJ_type   = 3'd4;
parameter UNDEFINE  = 3'd5;

parameter ADD       = 4'd0;
parameter SUB       = 4'd1;
parameter AND       = 4'd2;
parameter OR        = 4'd3;
parameter XOR       = 4'd4;
parameter SLL       = 4'd5;
parameter SRL       = 4'd6;
parameter SRA       = 4'd7;
parameter SLT       = 4'd8;

parameter JAL       = 2'd0;
parameter JALR      = 2'd1;
parameter BEQ       = 2'd2;
parameter BNE       = 2'd3;


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
reg [4:0]  Execution_r, Execution_w;
reg [7:0]  PC_r, PC_w;
reg        taken_r, taken_w;
reg        is_branchInst_r, is_branchInst_w;
reg [1:0]  branch_type_r, branch_type_w;

// wires
reg [29:0] IF_DWrite_w;
reg        PC_write_w;
reg [31:0] reg1, reg2;

// temporary wires
reg [2:0]  instruction_type;
reg [3:0]  ALUOp;
reg        ALUsrc;
reg        data_hazard;

assign Rd_2             = Rd_r;
assign Rs1_2            = Rs1_r;
assign Rs2_2            = Rs2_r;
assign data1            = data1_r;
assign data2            = data2_r;
assign immediate        = immediate_r;

assign is_branchInst_2  = is_branchInst_r;
assign PC_2             = {24'b0,PC_r};
assign prev_taken_2     = taken_r;
assign branch_type_2    = branch_type_r;

assign Mem_2            = Mem_r;
assign WriteBack_2      = WriteBack_r;
assign Execution_2      = Execution_r;

assign IF_DWrite        = IF_DWrite_w;
assign PC_write         = PC_write_w;


//  ===== opt ===== //
wire SB,SW,LW,R,I,UJ,JALr;
assign SB   = instruction_1[4]^instruction_1[0];
assign SW   = (~instruction_1[4]^instruction_1[2])&instruction_1[3];
assign LW   = ~(instruction_1[3]|instruction_1[2]);
assign R    = instruction_1[3]&instruction_1[2];
assign I    = (~instruction_1[3])&instruction_1[2];
assign UJ   = instruction_1[1];
assign JALr = instruction_1[1]^instruction_1[0];

//  ===== instruction type ===== //
always @(*) begin
    case(instruction_1[4:3])
        2'b00: begin
            instruction_type = I_type;
        end
        2'b01: begin
            if(instruction_1[2])
                instruction_type = R_type;
            else
                instruction_type = S_type;
        end
        2'b10: begin
            instruction_type = UNDEFINE;
        end
        2'b11: begin
            if(instruction_1[1:0] == 2'b00)
                instruction_type = SB_type;
            else if(instruction_1[1:0] == 2'b01)
                instruction_type = I_type;
            else
                instruction_type = UJ_type;
        end
    endcase 
end

// ===== decoding ===== //
always @(*) begin
    if(memory_stall) begin
        Rs1_w       = Rs1_r;
        Rs2_w       = Rs2_r;
        Rd_w        = Rd_r;
        immediate_w = immediate_r;
    end
    else begin
        Rs1_w = instruction_1[17:13];
        Rs2_w = instruction_1[22:18];
        Rd_w  = instruction_1[9:5];
        immediate_w = 32'd0;
        case (instruction_type)
            I_type: immediate_w = {{20{instruction_1[29]}}, instruction_1[29:18]}; // sign extended to 32-bit
            S_type: immediate_w = {{20{instruction_1[29]}}, instruction_1[29:23], instruction_1[9:5]}; // sign extended to 32-bit
            SB_type:immediate_w = {{20{instruction_1[29]}}, instruction_1[5], instruction_1[28:23], instruction_1[9:6], 1'b0}; // sign extended to 32-bit
            UJ_type:immediate_w = {{12{instruction_1[29]}}, instruction_1[17:10], instruction_1[18], instruction_1[28:19], 1'b0};
        endcase    
    end
end

// ===== registers ===== //
always @(*) begin 
    for(i = 0; i < 32; i = i + 1)
        register_w[i] = register_r[i];
    
    if(!memory_stall && write_address != 0 && WriteBack_5)
        register_w[write_address] = write_data;
    // -------------------------------------------------------   
    reg1 = register_w[Rs1_w];
    reg2 = register_w[Rs2_w];

    if(~memory_stall&(flush|data_hazard)) data1_w = 32'd0;
    else data1_w = reg1;
    // ---------------------------------------------------------
    if(~memory_stall&(flush|data_hazard)) data2_w = 32'd0;
    else data2_w = reg2;
end

// ===== Branch Information ===== //
always @(*) begin
    PC_w = (memory_stall) ? PC_r : PC_1[7:0];
    is_branchInst_w = (memory_stall) ? is_branchInst_r : instruction_1[4]&(~flush);
    //taken_w
    if(memory_stall) taken_w     = taken_r;
    else if(flush)   taken_w     = 1'b0;
    else             taken_w     = prev_taken_1;

    if(memory_stall | flush) begin
        branch_type_w = branch_type_r;    
    end
    else begin
        case (instruction_1[1:0])
            2'b00: begin
                if(instruction_1[10]) branch_type_w = BNE;
                else branch_type_w = BEQ;
            end
            2'b01:   branch_type_w = JALR;
            2'b11:   branch_type_w = JAL;
            default: branch_type_w = BNE; // meaningless !!
        endcase
    end 
end

// ===== data hazard detection ===== //

always @(*) begin 
    IF_DWrite_w     = instruction_1;
    data_hazard     = 1'b0;
    PC_write_w      = 1'b0;  
    if(Rd_r == Rs1_w || Rd_r == Rs2_w) begin
        data_hazard = Mem_r[1];
        PC_write_w  = Mem_r[1];    
    end
end

// ===== control ===== //
always @(*) begin
    if(memory_stall) Execution_w = Execution_r;    
    else Execution_w = {ALUOp, ALUsrc};

    if(memory_stall) Mem_w = Mem_r;
    else if(flush)   Mem_w = 2'b00;
    else             Mem_w = ({LW,SW})&{2{~data_hazard}};
    
    if(memory_stall) WriteBack_w = WriteBack_r;
    else WriteBack_w = (~flush)&(~SB)&(~SW)&(~data_hazard);    
end

// ===== ALUOp ===== //
always @(*) begin 
    if(instruction_1[1]) begin //jal (not have funct 3)
        ALUOp = ADD;   
    end
    else begin
        case (instruction_1[12:10]) // FUNCT3
            3'b000: begin
                if(instruction_1[4:3] == 2'b01) begin// R-type
                    if(instruction_1[28])   // SUB
                        ALUOp = SUB;
                    else                    // ADD
                        ALUOp = ADD;
                end
                else begin
                    if({instruction_1[4], instruction_1[0]} == 2'b10) //BEQ
                        ALUOp = SUB;
                    else                    // I type
                        ALUOp = ADD;
                end
            end    
            3'b001: begin
                if(instruction_1[4]) // BNE
                    ALUOp = SUB;
                else
                    ALUOp = SLL;
            end
            3'b010: begin
                if(instruction_1[2])
                    ALUOp = SLT;
                else
                    ALUOp = ADD;
            end
            3'b100: begin
                ALUOp = XOR;
            end
            3'b101: begin
                if(instruction_1[28])
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
end

// ===== ALUsrc ===== //
always @(*) begin
    ALUsrc = (~SB)&(~R);
end

always @(posedge clk) begin
    if(!rst_n) begin
        for(i = 0; i < 32; i = i + 1)
            register_r[i]   <= 32'd0;
        Rd_r                <= 5'd0;
        Rs1_r               <= 5'd0;
        Rs2_r               <= 5'd0;
        data1_r             <= 32'd0;
        data2_r             <= 32'd0;
        immediate_r         <= 32'd0;
        Mem_r               <= 2'd0;
        WriteBack_r         <= 1'b0;
        Execution_r         <= 5'd0;
        PC_r                <= 8'd0;
        is_branchInst_r     <= 1'b0;
        taken_r             <= 1'b0;
        branch_type_r       <= 2'b00;
    end
    else begin
        for(i = 0; i < 32; i = i + 1)
            register_r[i]   <= register_w[i];
        Rd_r                <= Rd_w;
        Rs1_r               <= Rs1_w;
        Rs2_r               <= Rs2_w;
        data1_r             <= data1_w;
        data2_r             <= data2_w;
        immediate_r         <= immediate_w;
        Mem_r               <= Mem_w;
        WriteBack_r         <= WriteBack_w;
        Execution_r         <= Execution_w;
        PC_r                <= PC_w;
        is_branchInst_r     <= is_branchInst_w;
        taken_r             <= taken_w;
        branch_type_r       <= branch_type_w;
    end
end
endmodule
*/