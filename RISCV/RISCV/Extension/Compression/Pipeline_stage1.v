`include "./ALUPipeline/compression_16.v"

module instruction_fetch(
    input         clk,
    input         rst_n,
    input         memory_stall, 
    input  [31:0] IF_DWrite,     
    input         IF_flush,     
    input         PC_write,      
    input         PC_src,        
    input  [31:0] instruction_in,
    input  [31:0] branch_address,
    output [29:0] I_addr,       
    output        I_ren,         
    output [31:0] PC_1,
    output        jj_16,
    output [31:0] instruction_1
);

// regs
reg [31:0] PC_r, PC_w;
reg [31:0] PC_out_r, PC_out_w;
reg [31:0] instruction_out_r, instruction_out_w;

// wires
wire[31:0] instruction_little; //instruction input with little_end
reg [31:0] instruction; //real output instruction 
reg [29:0] I_addr_w;   
reg        I_ren_w;
wire       PC_stall;
reg        jj_r;
wire       jj_w;
wire       jal,jalr;


assign PC_1              = PC_out_r;
assign instruction_1     = instruction_out_r;
assign I_addr            = I_addr_w;
assign I_ren             = I_ren_w;
assign instruction_little= (instruction_in == 32'b0)? 32'h00000013 :{instruction_in[7:0],instruction_in[15:8],instruction_in[23:16],instruction_in[31:24]}; //instruction with little_end
assign PC_stall          = (PC_write || memory_stall) ;
assign jj_16             = jj_r;
assign jj_w              = (PC_src)?(jj_r):(jal || jalr);


// ===== RVC ===== //
// wires
wire [1:0]  sel_g;
wire [2:0]  PC_offset,PC_offset_b;
wire [15:0] inst_16;
wire [31:0] inst_32;

// regs
reg  [15:0] inst_buffer_r,inst_buffer_w;
reg         B_r,B_w; 
reg         L_r;    
wire        L_w;


//Fox_control_unit
assign PC_offset   = (L_w) ? 4 : 2;
assign PC_offset_b = (L_r) ? 4 : 2;
assign L_w   = (B_r)? (inst_buffer_r[1]&inst_buffer_r[0]) : (instruction_little[1]&instruction_little[0]); 
assign sel_g = {B_r,L_w};

//Decompressor
assign inst_16 = (B_r)? (inst_buffer_r[15:0]):(instruction_little[15:0]);
Decompressor decompressor(.inst_16(inst_16),.inst_32(inst_32),.jal(jal),.jalr(jalr));

//Main_Logic
always @(*) begin
    B_w = 1'b0;                       
    inst_buffer_w = 16'b0; 
    if (PC_stall) begin           
        case (sel_g) 
            2'b01:begin   
                B_w = B_r;                  //I_address conti
                instruction   = instruction_little;
                inst_buffer_w = inst_buffer_r;
            end 
            2'b00:begin  
                B_w = B_r;                   //I_address conti
                instruction   = inst_32;
                inst_buffer_w = instruction_little[31:16];
            end 
            2'b11:begin 
                B_w = B_r;                   //I_address conti
                instruction   = 32'h00000013;
                inst_buffer_w = inst_buffer_r;
            end
            2'b10:begin 
                B_w = B_r;                   //I_address stall
                instruction   = inst_32;
                inst_buffer_w = inst_buffer_r;
            end
        endcase
    end
    else begin
        if(PC_src) begin // branch taken
            if (PC_w[1:0]==2'b10) begin
                B_w = 1'b1;
                inst_buffer_w = instruction_little[31:16];
                instruction   = 32'h00000013;   
            end 
            else begin
                B_w = 1'b0;
                inst_buffer_w = 16'b0;
                instruction   = 32'h00000013;  
            end
        /*
            case (sel_g)
                2'b01:begin                 
                    B_w = 1'b0;             
                    inst_buffer_w = 16'b0; 
                    instruction   = instruction_little;
                end 
                2'b00:begin               
                    B_w = 1'b0;             
                    inst_buffer_w = 16'b0;
                    instruction   = inst_32;
                end 
                2'b11:begin              
                    B_w = 1'b0;                       
                    inst_buffer_w = 16'b0;
                    instruction   = {instruction_little[15:0],inst_buffer_r};
                end
                2'b10:begin    
                    B_w = 1'b0;                       
                    inst_buffer_w = 16'b0;
                    instruction   = inst_32;
                end
            endcase
        */ 
        end
        else begin //PC+4/2
            case (sel_g)
                2'b01:begin                  //I_address conti
                    B_w = 1'b0;              //I will not use buffer
                    inst_buffer_w = 16'b0;   //I will not use buffer
                    instruction   = instruction_little;
                end 
                2'b00:begin                  //I_address conti
                    B_w = 1'b1;              //Use buffer next cycle
                    inst_buffer_w = instruction_little[31:16];
                    instruction   = inst_32;
                end 
                2'b11:begin                  //I_address conti
                    B_w = 1'b1;                       
                    inst_buffer_w = instruction_little[31:16];
                    instruction   = {instruction_little[15:0],inst_buffer_r};
                end
                2'b10:begin                  //I_address stall
                    B_w = 1'b0;                       
                    inst_buffer_w = 16'b0;
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
    if(PC_stall) begin
        PC_w = PC_r;
    end
    else begin
        if(PC_src) PC_w = branch_address;// branch taken
        else PC_w = PC_r + PC_offset;
    end
end

// ===== PC_out ===== //
always @(*) begin
    if(memory_stall) begin
        PC_out_w = PC_out_r ;
    end
    else begin
        if(PC_write) begin // load-use hazard
            PC_out_w = PC_r - PC_offset_b;  //may cause problem
        end
        else begin
            if(IF_flush) begin // branch hazard(insert NOP)
                PC_out_w = 32'd0;  
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
        if(PC_write) begin
            instruction_out_w = IF_DWrite;
        end
        else begin
            if(IF_flush) begin
                instruction_out_w = 32'h00000013; // NOP
            end
            else begin
                instruction_out_w = instruction;
            end    
        end
    end
end

// ===== I_cache ===== //
always @(*) begin
    I_ren_w = 1'b1;  // always reading I_cache
    if(PC_stall) begin
        I_addr_w = (sel_g == 2'd3) ? (PC_r[31:2]+30'd1):PC_r[31:2];//problem
    end
    else begin
        if(PC_src) // branch taken
            I_addr_w = PC_r[31:2];
        else
            I_addr_w = (B_r&&(inst_buffer_r[1:0]==2'b11)) ? (PC_r[31:2]+30'd1):PC_r[31:2];//problem
    end
end

always @(posedge clk) begin
    if(!rst_n) begin
        PC_r                <= 32'd0;
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