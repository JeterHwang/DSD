module instruction_decode(
    input         clk,
    input         rst_n,
    input         memory_stall,
    input         WriteBack_5,
    input [31:0]  write_data,
    input [4:0]   write_address, // Rd_5
    
    input [4:0]   Rd_3,
    input [31:0]  forward_result_4,
    //input [1:0]   Mem_3,

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
    output [4:0]  Execution_2, // Execution_2[3:1] : ALUOp / Execution_2[0] : ALUsrc
    
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

parameter ADD       = 4'd0;
parameter SUB       = 4'd1;
parameter AND       = 4'd2;
parameter OR        = 4'd3;
parameter XOR       = 4'd4;
parameter SLL       = 4'd5;
parameter SRL       = 4'd6;
parameter SRA       = 4'd7;
parameter SLT       = 4'd8;

integer i;

reg [31:0] register_r [0:31];
reg [31:0] register_w [0:31];

// regs 
reg [4:0]  Rd_r, Rd_w;
reg [4:0]  Rs1_o_r, Rs1_o_w;
reg [4:0]  Rs2_r, Rs2_w;
reg [31:0] data1_r, data1_w;
reg [31:0] data2_r, data2_w;
reg [31:0] output_immediate_r, output_immediate_w;
reg [1:0]  Mem_r, Mem_w;
reg        WriteBack_r, WriteBack_w;
reg [4:0]  Execution_r, Execution_w;

// wires
reg [31:0] branch_address_w;
reg [31:0] IF_DWrite_w;
reg [4:0]  Rs1_w;
reg        IF_flush_w;
reg        PC_write_w;
reg        PC_src_w;
reg [31:0] immediate_w;
reg [31:0] reg1, reg2;
reg [31:0] SB1, SB2;

// temporary wires
reg [2:0]  instruction_type;
reg [3:0]  ALUOp;
reg        ALUsrc;
reg [31:0] Rs1_Rs2;
reg        data_hazard;

assign Rd_2             = Rd_r;
assign Rs1_2            = Rs1_o_r;
assign Rs2_2            = Rs2_r;
assign data1            = data1_r;
assign data2            = data2_r;
assign immediate        = output_immediate_r;
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
    if(memory_stall) begin
        Rs1_o_w       = Rs1_o_r;
        Rs2_w       = Rs2_r;
        Rd_w        = Rd_r;
    end
    else begin
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
                immediate_w = {{11{instruction_1[31]}}, instruction_1[31], instruction_1[19:12], instruction_1[20], instruction_1[30:21], 1'b0};
            end
            UNDEFINE: begin
                Rs1_w       = 5'd0;
                Rs2_w       = 5'd0;
                Rd_w        = 5'd0;
                immediate_w = 5'd0;
            end
        endcase    
        Rs1_o_w = (instruction_1[3:2] == 2'b01) ? 5'd0 : Rs1_w;
    end
end

// ===== registers ===== //
always @(*) begin 
    if(memory_stall) begin
        output_immediate_w = output_immediate_r;    
    end
    else begin
        if(instruction_1[2]) //jalr, jal
            output_immediate_w = 32'd4;
        else
            output_immediate_w = immediate_w;
    end
    

    for(i = 0; i < 32; i = i + 1)
        register_w[i] = register_r[i];
    
    if(!memory_stall && write_address != 0 && WriteBack_5)
        register_w[write_address] = write_data;
    
    reg1 = register_w[Rs1_w];
    reg2 = register_w[Rs2_w];

    if(memory_stall) begin
        data1_w = data1_r;
    end
    else begin
        if(instruction_1[2]) //jalr, jal
            data1_w = PC_1;
        else
            data1_w = reg1;
    end
    
    data2_w = memory_stall ? data2_r : reg2;
end

// ===== branch hazard detection ===== //
always @(*) begin 
    if(instruction_1[3:2] == 2'b01) begin // jalr
        if(Rd_3 == Rs1_w) begin
            branch_address_w    = $signed(forward_result_4) + $signed(immediate_w); 
        end
        else begin
            branch_address_w    = $signed(reg1) + $signed(immediate_w);    
        end
    end
    else begin
        branch_address_w    = $signed(PC_1) + $signed(immediate_w);
    end

    if(Rs1_w == Rs2_w) begin
        SB1     = reg1;
        SB2     = reg2;
    end
    else begin
        if(Rd_3 != 0 && Rs1_w == Rd_3) begin
            SB1     = forward_result_4;
            SB2     = reg2;
        end 
        else if(Rd_3 != 0 && Rs2_w == Rd_3) begin
            SB1     = reg1;
            SB2     = forward_result_4;
        end
        else begin
            SB1     = reg1;
            SB2     = reg2;
        end
    end
        
    Rs1_Rs2     = $signed(SB1) - $signed(SB2);
    
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

    if(instruction_1[6] == 1'b1 && instruction_1[3] == 1'b0) begin // jalr, bne, beq data hazard
        if(instruction_1[2]) begin // jalr
            if(Rd_r != 0 && Rs1_w == Rd_r) begin
                data_hazard     = 1'b1;
                PC_write_w      = 1'b1;
            end    
            else begin
                data_hazard     = 1'b0;
                PC_write_w      = 1'b0;   
            end
        end
        else begin // bne, beq
            if(Rs1_w == Rs2_w) begin // no hazard detection needed !!
                data_hazard     = 1'b0;
                PC_write_w      = 1'b0;
            end
            else begin
                if(Rd_r != 0 && Rs1_w == Rd_r) begin
                    data_hazard     = 1'b1;
                    PC_write_w      = 1'b1;
                end
                else if(Rd_r != 0 && Rs2_w == Rd_r) begin
                    data_hazard     = 1'b1;
                    PC_write_w      = 1'b1;
                end
                else begin
                    data_hazard     = 1'b0;
                    PC_write_w      = 1'b0;
                end    
            end
        end
    end
    else if(Mem_r[1]) begin  // load-use hazard
        if(Rd_r == Rs1_w || Rd_r == Rs2_w) begin
            data_hazard     = 1'b1;
            PC_write_w      = 1'b1;    
        end
        else begin
            data_hazard     = 1'b0;
            PC_write_w      = 1'b0;    
        end
    end
    else begin
        data_hazard     = 1'b0;
        PC_write_w      = 1'b0;
    end
end

// ===== control ===== //
always @(*) begin
    Execution_w = memory_stall ? Execution_r : ({ALUOp, ALUsrc} & {5{~data_hazard}});
    
    if(memory_stall) begin
        Mem_w = Mem_r;
    end
    else begin
        if(instruction_1[6:4] == 3'b000) // lw
            Mem_w = 2'b10 & {2{~data_hazard}};
        else if(instruction_1[6:4] == 3'b010) // sw
            Mem_w = 2'b01 & {2{~data_hazard}};
        else
            Mem_w = 2'b00 & {2{~data_hazard}};    
    end
    
    
    if(memory_stall) begin
        WriteBack_w = WriteBack_r;
    end
    else begin
        if(instruction_type[1]) // SB_type, S_type
            WriteBack_w = 1'b0 & (~data_hazard);
        else
            WriteBack_w = 1'b1 & (~data_hazard);    
    end
    
end

// ===== ALUOp ===== //
always @(*) begin 
    if(instruction_1[3]) begin //jal (not have funct 3)
        ALUOp = ADD;   
    end
    else begin
        case (instruction_1[14:12]) // FUNCT3
            3'b000: begin
                if(instruction_1[6:5] == 2'b01) begin// R-type
                    if(instruction_1[30])
                        ALUOp = SUB;
                    else
                        ALUOp = ADD;
                    end
                else begin
                    ALUOp = ADD;
                end
            end    
            3'b001: begin
                ALUOp = SLL;
            end
            3'b010: begin
                if(instruction_1[4])
                    ALUOp = SLT;
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
        Rs1_o_r     <= 5'd0;
        Rs2_r       <= 5'd0;
        data1_r     <= 32'd0;
        data2_r     <= 32'd0;
        output_immediate_r <= 32'd0;
        Mem_r       <= 2'd0;
        WriteBack_r <= 1'b0;
        Execution_r <= 5'd0;
    end
    else begin
        for(i = 0; i < 32; i = i + 1)
            register_r[i] <= register_w[i];
        Rd_r        <= Rd_w;
        Rs1_o_r     <= Rs1_o_w;
        Rs2_r       <= Rs2_w;
        data1_r     <= data1_w;
        data2_r     <= data2_w;
        output_immediate_r <= output_immediate_w;
        Mem_r       <= Mem_w;
        WriteBack_r <= WriteBack_w;
        Execution_r <= Execution_w;
    end
end
endmodule
