module Memory(
    input         clk,
    input         rst_n,
    input         memory_stall,
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
    memory_result_w = memory_stall ? memory_result_r : D_readData;
    ALU_result_w    = memory_stall ? ALU_result_r : ALU_result_3;
    Rd_w            = memory_stall ? Rd_r : Rd_3;
    WriteBack_w     = memory_stall ? WriteBack_r : WriteBack_3;    
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