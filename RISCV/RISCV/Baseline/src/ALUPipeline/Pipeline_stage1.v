module instruction_fetch(
    input         clk,
    input         rst_n,
    
    input         flush, 
    input         taken,
    input  [31:0] branchPC,

    input         memory_stall,
    input  [29:0] IF_DWrite,     
    input         PC_write,             

    input  [31:0] instruction_in,
    output [29:0] I_addr,       
    output        I_ren,         
    
    output [7:0]  PC_1,
    output [29:0] instruction_1, 
    output [29:0] instruction_1_w, 
    
    output        prev_taken_1,
    output [31:0] instructionPC_1
);

// regs
reg [31:0] PC_r, PC_w;
reg [7:0]  PC_out_r, PC_out_w;
reg [29:0] instruction_out_r, instruction_out_w;
reg        taken_r, taken_w;

// wires
reg        I_ren_w;
reg [29:0] I_addr_w;
wire[31:0] instruction_little; //instruction input with little_end
wire[29:0] instruction; //real output instruction 

assign PC_1                 = PC_out_r;
assign instruction_1        = instruction_out_r;
assign instruction_1_w      = instruction_out_w;
assign I_addr               = I_addr_w;
assign I_ren                = I_ren_w;
assign instruction_little   = {instruction_in[7:0],instruction_in[15:8],instruction_in[23:16],instruction_in[31:24]}; //instruction with little_end
assign instruction          = instruction_little[31:2];
assign prev_taken_1         = taken_r;
assign instructionPC_1      = PC_r;


// ===== opt ===== //
wire opt1,opt2;
assign opt1 = PC_write&(~flush);
assign opt2 = opt1 | memory_stall;
// ===== PC & BTB ===== //
always @(*) begin
    if(opt2)begin
        PC_w    = PC_r;
        taken_w = taken_r;
    end 
    else begin
        PC_w    = branchPC;
        taken_w = taken&(~flush);
    end                                  
end

// ===== PC_out ===== //
always @(*) begin
    if(opt2) PC_out_w = PC_out_r;
    else     PC_out_w = PC_r[7:0];
end

// ===== instruction_out ===== //
always @(*) begin
    if(memory_stall) instruction_out_w = instruction_out_r;
    else if(flush)   instruction_out_w = {27'b0,1'b1,2'b0}; // NOP
    else             instruction_out_w = (PC_write)? IF_DWrite : instruction; 
end

// ===== I_cache ===== //
always @(*) begin
    I_addr_w            = PC_r[31:2];
    I_ren_w             = 1'b1;  // always reading I_cache
end

always @(posedge clk) begin
    if(!rst_n) begin
        PC_r                <= 32'd0;
        PC_out_r            <= 8'd0;
        instruction_out_r   <= 30'd0;
        taken_r             <= 1'b0;
    end
    else begin
        PC_r                <= PC_w;
        PC_out_r            <= PC_out_w;
        instruction_out_r   <= instruction_out_w;
        taken_r             <= taken_w;
    end
end  
endmodule
