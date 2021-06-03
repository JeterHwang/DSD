`include "./Cache/L2.v"
`include "./Cache/L1.v"
module cache(
    clk,
    proc_reset,
    proc_read,
    proc_write,
    proc_addr,
    proc_rdata,
    proc_wdata,
    proc_stall,
    mem_read,
    mem_write,
    mem_addr,
    mem_rdata,
    mem_wdata,
    mem_ready
);
//==== input/output definition ============================
    input          clk;
    // processor interface
    input          proc_reset;
    input          proc_read, proc_write;
    input   [29:0] proc_addr;
    input   [31:0] proc_wdata;
    output         proc_stall;
    output  [31:0] proc_rdata;
    // memory interface
    input  [127:0] mem_rdata;
    input          mem_ready;
    output         mem_read, mem_write;
    output  [27:0] mem_addr;
    output [127:0] mem_wdata;

//==== wire/reg definition ================================
    wire           L1_read, L1_write;
    wire    [27:0] L1_addr;
    wire   [127:0] L1_wdata;
    wire           L1_ready;
    wire   [127:0] L1_rdata;
    wire           L2_read, L2_write;
    wire    [27:0] L2_addr;
    wire   [127:0] L2_wdata;
    wire           L2_ready;
    wire   [127:0] L2_rdata;

//==== combinational circuit ==============================
    L1_cache L1 (   .clk            (clk)           ,
                    .proc_reset     (proc_reset)    ,
                    .proc_read      (proc_read)     ,
                    .proc_write     (proc_write)    ,
                    .proc_addr      (proc_addr)     ,
                    .proc_rdata     (proc_rdata)    ,
                    .proc_wdata     (proc_wdata)    ,
                    .proc_stall     (proc_stall)    ,
                    .mem_read       (L2_read)       ,
                    .mem_write      (L2_write)      ,
                    .mem_addr       (L2_addr)       ,
                    .mem_rdata      (L2_rdata)      ,
                    .mem_wdata      (L2_wdata)      ,
                    .mem_ready      (L2_ready)
                );
    L2_cache L2 (   .clk            (clk)           ,
                    .reset          (proc_reset)    ,
                    .cache_read     (L1_read)     ,
                    .cache_write    (L1_write)    ,
                    .cache_addr     (L1_addr)     ,
                    .cache_rdata    (L1_rdata)    ,
                    .cache_wdata    (L1_wdata)    ,
                    .L2_ready       (L1_ready)    ,
                    .mem_read       (mem_read)       ,
                    .mem_write      (mem_write)      ,
                    .mem_addr       (mem_addr)       ,
                    .mem_rdata      (mem_rdata)      ,
                    .mem_wdata      (mem_wdata)      ,
                    .mem_ready      (mem_ready)
                );
    assign  L1_read     = L2_read;
    assign  L1_write    = L2_write;
    assign  L1_addr     = L2_addr;
    assign  L2_rdata    = L1_rdata;
    assign  L1_wdata    = L2_wdata;
    assign  L2_ready    = L1_ready;

endmodule



