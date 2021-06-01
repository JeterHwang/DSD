`include "./ALUPipeline/compression_16.v"

module instruction_fetch(
    input         clk,
    input         rst_n,
    
    input         flush, 
    input         taken,
    input  [31:0] branchPC,

    input         memory_stall,
    input  [31:0] IF_DWrite,     
    input         PC_write,             
    
    input  [31:0] instruction_in,
    output [29:0] I_addr,       
    output        I_ren,         
    
    output [31:0] PC_1,
    output [31:0] instruction_1,
    
    output        prev_taken_1,
    output [31:0] instructionPC_1,
    //for RVC
    output        jj_16,
    output        LW
);

// regs
reg [31:0] PC_r, PC_w;
reg [31:0] PC_out_r, PC_out_w;
reg [31:0] instruction_out_r, instruction_out_w;
reg        taken_r, taken_w;
reg        jj_r;
wire       jj_w;

// wires
wire[31:0] instruction_little; //instruction input with little_end
reg [31:0] instruction; //real output instruction 
reg [29:0] I_addr_w;
reg        I_ren_w;
wire       jj;
wire[29:0] PC_plus1;
wire       opt1;


assign PC_1                 = PC_out_r;
assign instruction_1        = instruction_out_r;
assign I_addr               = I_addr_w;
assign I_ren                = I_ren_w;
assign instruction_little   = (instruction_in == 32'b0)? 32'h00000013 :{instruction_in[7:0],instruction_in[15:8],instruction_in[23:16],instruction_in[31:24]}; //instruction with little_end
assign jj_16                = jj_r;
assign jj_w                 = (flush)?(jj_r):(jj);
assign PC_plus1             = PC_r[31:2]+30'd1;
assign prev_taken_1         = taken_r;
assign instructionPC_1      = PC_r;



// ===== RVC ===== //
// wires
wire [1:0]  sel_g;
wire [2:0]  PC_offset,PC_offset_b;
wire [15:0] inst_16;
wire [31:0] inst_32;

// regs
reg  [15:0] inst_buffer_r;
wire [15:0] inst_buffer_w;
reg         B_r,B_w; 
reg         L_r;    
wire        L_w;

//Fox_control_unit
//assign PC_offset   = (L_w) ? 4 : 2;
assign PC_offset_b = (L_r) ? 4 : 2;
assign opt1        = inst_buffer_r[1]&inst_buffer_r[0];
assign L_w   = (B_r)? (opt1) : (instruction_little[1]&instruction_little[0]); 
assign sel_g = {B_r,L_w};
assign inst_buffer_w = (B_r^L_w)?(inst_buffer_r):(instruction_little[31:16]);
assign LW            = L_w;
//Decompressor
assign inst_16 = (B_r)? (inst_buffer_r[15:0]):(instruction_little[15:0]);
Decompressor decompressor(.inst_16(inst_16),.inst_32(inst_32),.jj(jj));

//Main_Logic
always @(*) begin
    B_w = 1'b0;                       
    if (memory_stall) begin
        B_w = B_r;   
        instruction = 32'h00000013;  
    end
    else begin
        if(flush) begin // branch taken
            B_w = 1'b0;
            instruction = 32'h00000013;
        end
        else begin //PC+4or2
            case (sel_g)
                2'b01:begin                  //I_address conti
                    B_w = 1'b0;          
                    instruction   = instruction_little;
                end 
                2'b00:begin                  //I_address conti
                    B_w = 1'b1;          
                    instruction   = inst_32;
                end 
                2'b11:begin                  //I_address conti
                    B_w = 1'b1;                       
                    instruction   = {instruction_little[15:0],inst_buffer_r};
                end
                2'b10:begin                  //I_address stall
                    B_w = 1'b0;                       
                    instruction   = inst_32;
                end
            endcase
        end 
    end       
end

always @(posedge clk) begin
    if(!rst_n) begin
        inst_buffer_r <= 16'b0;
        L_r           <= 1'b1;
        B_r           <= 1'b0;
        jj_r          <= 1'b0;
    end
    else begin
        inst_buffer_r <= inst_buffer_w;
        L_r           <= L_w;
        B_r           <= B_w;
        jj_r          <= jj_w;
    end
end



// ===== PC ===== //
always @(*) begin
    if(memory_stall) begin
        PC_w        = PC_r;
        taken_w     = taken_r;
    end
    else begin 
        if(flush) begin
            PC_w        = branchPC;
            taken_w     = 1'b0;
        end
        else begin
            if(PC_write) begin
                PC_w        = PC_r;
                taken_w     = taken_r;
            end
            else begin
                PC_w        = branchPC;
                taken_w     = taken;
            end
        end
    end
end

// ===== PC_out ===== //
always @(*) begin
    if(memory_stall) begin
        PC_out_w = PC_out_r ;
    end
    else begin
        if(flush) begin // branch hazard(insert NOP)
            PC_out_w = 32'd0;  
        end
        else begin
            if(PC_write) begin // load-use hazard
                PC_out_w = PC_r - PC_offset_b;
            end
            else begin
                PC_out_w = PC_r;
            end
        end
    end
end

// ===== instruction_out ===== //
always @(*) begin
    if(memory_stall) begin
        instruction_out_w = instruction_out_r;
    end
    else begin
        if(flush) begin
            instruction_out_w = 32'h00000013; // NOP
        end
        else begin
            if(PC_write) begin
                instruction_out_w = IF_DWrite;
            end
            else begin
                instruction_out_w = instruction;
            end    
        end
    end
end

// ===== I_cache ===== //
always @(*) begin
    I_ren_w              = 1'b1;  // always reading I_cache
    if (flush) I_addr_w = PC_r[31:2];
    else I_addr_w = (B_r&opt1) ? (PC_plus1):PC_r[31:2];
end

always @(posedge clk) begin
    if(!rst_n) begin
        PC_r                <= 32'd0;
        PC_out_r            <= 32'd0;
        instruction_out_r   <= 32'd0;
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
