module Execution(
    input         clk,
    input         rst_n,
    input         memory_stall,
    input [31:0]  data1,
    input [31:0]  data2,
    input [31:0]  immediate,   
    input [4:0]   Rs1_2,
    input [4:0]   Rs2_2,
    input [4:0]   Rd_2,
    
    input         is_branchInst_2,
    input [1:0]   branch_type_2,
    input [7:0]   PC_2,
    input         prev_taken_2,
    
    input         WriteBack_2,
    input [1:0]   Mem_2,
    input [4:0]   Execution_2,  // {ALUOp, ALUsrc}
    
    input [31:0]  writeback_data_5,
    input         WriteBack_5,
    input [4:0]   Rd_5,  
    
    output        WriteBack_3,
    output [1:0]  Mem_3,
    output [31:0] ALU_result_3,
    output [31:0] writedata_3, // memory write data
    output [4:0]  Rd_3,

    output [7:0]  target_3,
    output [7:0]  instructionPC_3,
    output        is_branchInst_3,
    output        taken_3,
    output        prev_taken_3
);

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

// regs
reg [1:0]  Mem_r, Mem_w;
reg        WriteBack_r, WriteBack_w;
reg [4:0]  Rd_r, Rd_w;
reg [31:0] ALU_result_r, ALU_result_w;
reg [31:0] writedata_r, writedata_w;

// wires
reg [31:0] ALU_in1;
reg [31:0] ALU_in2;
reg [31:0] temp;
reg [1:0]  forwardA;
reg [1:0]  forwardB;
wire       branch_taken;
wire[7:0]  branch_target;

assign WriteBack_3      = WriteBack_r;
assign Mem_3            = Mem_r;
assign ALU_result_3     = ALU_result_r;
assign writedata_3      = writedata_r;
assign Rd_3             = Rd_r;

assign target_3         = branch_target;
assign instructionPC_3  = PC_2;
assign is_branchInst_3  = is_branchInst_2;
assign taken_3          = branch_taken;
assign prev_taken_3     = prev_taken_2;

always @(*) begin // forwarding unit
    
    if(WriteBack_r && Rd_r != 0 && Rd_r == Rs1_2) begin
        forwardA = 2'b10;
    end
    else if(WriteBack_5 && Rd_5 != 0 && Rd_5 == Rs1_2) begin
        forwardA = 2'b01;
    end
    else begin
        forwardA = 2'b00;
    end

    if(WriteBack_r && Rd_r != 0 && Rd_r == Rs2_2) begin
        forwardB = 2'b10;
    end
    else if(WriteBack_5 && Rd_5 != 0 && Rd_5 == Rs2_2) begin
        forwardB = 2'b01;
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
            ALU_in1 = writeback_data_5;
        end
        2'b10: begin
            ALU_in1 = ALU_result_r;
        end
        default: begin
            ALU_in1 = data1;
        end
    endcase
end

// ===== ALU input 2 ===== //
always @(*) begin
    case (forwardB)
        2'b00: begin
            temp = data2;
        end
        2'b01: begin
            temp = writeback_data_5;
        end
        2'b10: begin
            temp = ALU_result_r;
        end
        default: begin
            temp = data2;
        end
    endcase
    ALU_in2 = Execution_2[0] ? immediate : temp;
end

// ===== Branch Information ===== //
wire ALU_zero;
wire opt1;
wire [7:0] src1,src2;
assign ALU_zero         = ~(|ALU_result_w[5:0]);
assign opt1             = branch_type_2[1]&(~ALU_zero^branch_type_2[0]);
assign src1             = (branch_type_2==JALR)? ALU_in1[7:0] : PC_2[7:0];
assign src2             = (opt1)? 8'd4 : immediate[7:0] ;
assign branch_target    = src1 + src2;
assign branch_taken     = ~opt1;

// ===== ALU control ===== //
wire jj;
wire [10:0] srcc1,srcc2;
wire [10:0] sub;
wire [10:0] add;
assign jj = ~branch_type_2[1];
assign srcc1 = (jj)?{3'b0,PC_2}:ALU_in1[10:0];
assign srcc2 = (jj)?11'd4:ALU_in2[10:0];
assign add   = srcc1 + srcc2;
assign sub   = ALU_in1[10:0] - ALU_in2[10:0];

//opt
wire optXOR;
wire [2:0]  optOR;
assign optXOR = ALU_in1[0] ^ ALU_in2[0];
assign optOR = ALU_in1[2:0] | ALU_in2[2:0];
always @(*) begin 
    if(memory_stall) begin
        ALU_result_w = ALU_result_r;        
    end
    else begin
        case(Execution_2[4:1])
            ADD: begin
                ALU_result_w = {{21{add[10]}},add};//add;//{{19{add[12]}},add};
            end
            SUB: begin
                ALU_result_w = {{21{sub[10]}},sub};
            end
            AND: begin
                ALU_result_w = ALU_in1[1:0] & ALU_in2[1:0];//{30'b0,optand};
            end
            OR: begin
                ALU_result_w = {{29{ALU_in2[31]}},optOR};//ALU_in1 | ALU_in2 ;//ALU_in1 | ALU_in2;
            end
            XOR: begin
                ALU_result_w = {{31{ALU_in2[31]}},optXOR};//ALU_in1 ^ ALU_in2;
            end
            SLL: begin
                ALU_result_w = ALU_in1 << 1'b1;
            end
            SRL: begin
                ALU_result_w = ALU_in1 >> 5'd31;
            end
            SRA: begin
                ALU_result_w = $signed(ALU_in1) >>> 5'd31;
            end
            SLT: begin
                ALU_result_w = sub[10];
            end
            default: begin
                ALU_result_w = 32'd0;
            end
        endcase    
    end
end

// ===== passing signals ===== //
always @(*) begin
    Mem_w           = memory_stall ? Mem_r          : Mem_2;
    WriteBack_w     = memory_stall ? WriteBack_r    : WriteBack_2;
    Rd_w            = memory_stall ? Rd_r           : Rd_2;
    writedata_w     = memory_stall ? writedata_r    : temp;
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

