// Your SingleCycle RISC-V code

module CHIP(clk,
            rst_n,
            // for mem_D
            mem_wen_D,
            mem_addr_D,
            mem_wdata_D,
            mem_rdata_D,
            // for mem_I
            mem_addr_I,
            mem_rdata_I
    );

    input         clk, rst_n ;
    // for mem_D
    output        mem_wen_D  ;  // mem_wen_D is high, CHIP writes data to D-mem; else, CHIP reads data from D-mem
    output [31:0] mem_addr_D ;  // the specific address to fetch/store data 
    output [31:0] mem_wdata_D;  // data writing to D-mem 
    input  [31:0] mem_rdata_D;  // data reading from D-mem
    // for mem_I
    output [31:0] mem_addr_I ;  // the fetching address of next instruction
    input  [31:0] mem_rdata_I;  // instruction reading from I-mem
    
    // control input 
    wire jalr, jal, branch, memread, memtoreg, memwrite, alusrc, regwrite;
    wire [3:0] aluop;

    // register file
    


    always@(*) begin
        
    end

    
endmodule

module control();
    
endmodule

module register();
    
endmodule

module ALU();
    
endmodule

module ALU_control();
    
endmodule