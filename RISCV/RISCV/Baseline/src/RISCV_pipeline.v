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
wire        IF_DWrite;
wire        PC_write;
wire [29:0] branch_address;
wire        PC_src;
// output
wire        PC_1;
wire [29:0] I_addr;
wire        I_ren;
wire [31:0] instruction_1;
// ====================//

// ==== L2 signals ==== //
// input


// ==================== //

intstruction_fetch stage1(
    .clk(clk),
    .rst_n(rst_n),
    .IF_DWrite(IF_DWrite),
    .PC_write(PC_write),
    .PC_src(PC_src),
    .instruction_in(ICACHE_rdata),
    .branch_address(branch_address),
    .I_addr(I_addr),
    .I_ren(I_ren),
    .PC_1(PC_1),
    .instruction_1(instruction_1)
);

assign ICACHE_wen   = 1'b0;
assign ICACHE_ren   = I_ren;
assign ICACHE_addr  = I_addr;
assign ICACHE_wdata = 32'd0;

endmodule


module intstruction_fetch(
    input         clk,
    input         rst_n,
    input [31:0]  IF_DWrite,
    input         IF_flush,
    input         PC_write,
    input         PC_src,
    input [31:0]  instruction_in,
    input [29:0]  branch_address,
    output [29:0] I_addr,
    output        I_ren,
    output        PC_1,
    output [31:0] instruction_1
);

always @(*) begin // instruction memory
    
end

always @(posedge clk) begin
    if(!rst_n) begin
        
    end
    else begin
        
    end
end  
endmodule

module instruction_decode(
    input         clk,
    input         rst_n,
    input [31:0]  write_data,
    input [4:0]   Rd_3,
    input [4:0]   write_address, // Rd_5
    input         MemRead_3,
    input         WriteBack_5,
    input         PC_1,
    output [4:0]  Rd_2,
    output [4:0]  Rs1_2,
    output [4:0]  Rs2_2,
    output [31:0] data1,
    output [31:0] data2,
    output [31:0] immediate,
    output        MemRead_2,
    output        WriteBack_2,
    output        Execution2,
    output [29:0] branch_address,
    output [31:0] IF_DWrite,
    output        IF_flush,
    output        PC_write,
    output        PC_src
);
    
reg [31:0] register [0:31];

always @(*) begin // registers
    
end

always @(*) begin // hazard detection
    
end

always @(*) begin // control
    
end

always @(posedge clk) begin
    if(!rst_n) begin
        
    end
    else begin
        
    end
end
endmodule

module Execution(
    input         clk,
    input         rst_n,
    input [31:0]  data1,
    input [31:0]  data2,
    input [31:0]  immediate,
    input         WriteBack_2,
    input         MemRead_2,
    input         Execution2,
    input         WriteBack_4,
    input [4:0]   Rd_4,
    input [31:0]  ALU_result_4,
    input [31:0]  writeback_data_5,
    input         WriteBack_5,
    input [4:0]   Rd_5,  
    output        WriteBack_3,
    output        MemRead_3,
    output [31:0] ALU_result_3,
    output [31:0] writedata_3,
    output [4:0]  Rd_3
);

always @(*) begin // forwarding unit
    
end  

always @(*) begin // ALU control
    
end

always @(posedge clk) begin
    if(!rst_n) begin
        
    end
    else begin
        
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
    input         MemRead_3,
    input [4:0]   Rd_3,
    output [31:0] memory_result_4,
    output [31:0] ALU_result_4,
    output [4:0]  Rd_4,
    output        WriteBack_4,
    output [29:0] D_addr,
    output        D_wen,
    output        D_ren,
    output [31:0] D_writeData
);
always @(*) begin // data memory
    
end  

always @(posedge clk) begin
    if(!rst_n) begin
        
    end
    else begin
        
    end
end
endmodule

module Writeback( // no sequential circuits
    input [31:0]  ALU_result_4,
    input [31:0]  memory_result_4,
    input         WriteBack_4,
    input [4:0]   Rd_4,
    output [4:0]  Rd_5,
    output [31:0] write_data,
    output        WriteBack_5
);
    
endmodule