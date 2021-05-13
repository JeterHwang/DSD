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
    
    // wire
	reg    [31:0] real_instruction  ; // mem_rdata_I rearranged
	reg    [ 9:0] instruction_type  ;
	reg    [ 4:0] instruction_format;
	reg    [31:0] imm               ; // immediate field
	reg    [31:2] mem_addr;

	reg    mem_wen_D_r, mem_wen_D_w ;
	reg    [31:2] mem_addr_D_r, mem_addr_D_w;
	reg    [31:0] mem_wdata_D_r, mem_wdata_D_w;
	reg    [31:2] mem_addr_I_r, mem_addr_I_w; 
	
	// reg
	reg    [31:0] re_r [0:31]         ; // 32 registers 32 bits each
	reg    [31:0] re_w [0:31]         ;
    
    integer i;
    
    assign mem_wen_D        = mem_wen_D_w;
    assign mem_addr_D       = {mem_addr_D_w, 2'b00};
    assign mem_wdata_D      = mem_wdata_D_w;
    assign mem_addr_I       = {mem_addr_I_r, 2'b00};

always@(*) begin
    // rearrange instruction2
    real_instruction[31:24]     = mem_rdata_I[7:0];
    real_instruction[23:16]     = mem_rdata_I[15:8];
    real_instruction[15:8]      = mem_rdata_I[23:16];
    real_instruction[7:0]       = mem_rdata_I[31:24];

	if(real_instruction[4]) begin // R type
		instruction_format = 5'b10000;
		if(real_instruction[12]) begin // and
			instruction_type = 10'b0000000100;
		end
		else if(real_instruction[14]) begin // or
			instruction_type = 10'b0000001000;
		end
		else if(real_instruction[13]) begin // slt
			instruction_type = 10'b0000010000;
		end
		else if(real_instruction[30]) begin // sub
			instruction_type = 10'b0000000010;
		end
		else begin // add
			instruction_type = 10'b0000000001;
		end
	end
	else if(real_instruction[3]) begin // UJ type
		instruction_format = 5'b00001;
		instruction_type = 10'b0100000000;
	end
	else if(real_instruction[6]) begin
		if(real_instruction[2]) begin // jalr
			instruction_type = 10'b1000000000;
			instruction_format = 5'b01000;
		end
		else begin // beq
			instruction_format = 5'b00010;
			instruction_type = 10'b0010000000;
		end
	end
	else begin
		if(real_instruction[5]) begin // sw
			instruction_type = 10'b0001000000;
			instruction_format = 5'b00100;
		end
		else begin // lw
			instruction_type = 10'b0000100000;
			instruction_format = 5'b01000;
		end
	end
end

always@(*) begin  // deal with immediate
	if (instruction_format[0]) begin // UJ type
		imm[19:0] = {real_instruction[31], real_instruction[19:12], real_instruction[20], real_instruction[30:21],1'b0};
		if (imm[19]) begin
			imm[31:20] = 12'b111111111111;
		end
		else begin
			imm[31:20] = 12'b000000000000;
		end
	end
	else if (instruction_format[1]) begin // SB type
		imm[12:0] = {real_instruction[31], real_instruction[7], real_instruction[30:25], real_instruction[11:8], 1'b0};
		if (imm[12]) begin
			imm[31:13] = 19'b1111111111111111111;
		end
		else begin
			imm[31:13] = 19'b0000000000000000000;
		end
	end
	else if (instruction_format[2]) begin  // S type
		imm[11:0] = {real_instruction[31:25], real_instruction[11:7]};
		if (imm[11]) begin
			imm[31:12] = 20'b11111111111111111111;
		end
		else begin
			imm[31:12] = 20'b00000000000000000000;
		end
	end
	else if (instruction_format[3]) begin  // I type
		if (real_instruction[31]) begin
			imm = {20'b11111111111111111111, real_instruction[31:20]};
		end
		else begin
			imm = {20'b00000000000000000000, real_instruction[31:20]};
		end
	end
	else begin  // none of above
		imm = 32'b0;
	end
end

always@(*) begin
    if(instruction_format[2]) begin
		mem_wen_D_w           = 1'b1;
		mem_addr_D_w    	  = re_r[real_instruction[19:15]][31:2] + imm[31:2];
		mem_wdata_D_w[7:0]    = re_r[real_instruction[24:20]][31:24];
		mem_wdata_D_w[15:8]   = re_r[real_instruction[24:20]][23:16];
		mem_wdata_D_w[23:16]  = re_r[real_instruction[24:20]][15:8];
		mem_wdata_D_w[31:24]  = re_r[real_instruction[24:20]][7:0];
	end
	else if(instruction_format[3]) begin
		mem_wen_D_w     = 1'b0;
		mem_wdata_D_w   = 32'b0;
		mem_addr_D_w    = re_r[real_instruction[19:15]][31:2] + imm[31:2];
	end
	else begin
		mem_wen_D_w     = 1'b0;
		mem_wdata_D_w   = 32'b0;
		mem_addr_D_w    = 30'b0;
	end
end  

always @(*) begin
    for(i = 0; i < 32; i = i + 1) begin
        re_w[i] = re_r[i];
    end
	mem_addr = mem_addr_I_r + 1'b1;
	/////////////// instruction memory address /////////////
    if (instruction_format[0]) begin
		mem_addr_I_w                    = mem_addr_I_r + imm[31:2];
	end
	else if(instruction_format[1]) begin
		if(re_r[real_instruction[19:15]] == re_r[real_instruction[24:20]])
			mem_addr_I_w = mem_addr_I_r + imm[31:2];
		else
			mem_addr_I_w = mem_addr;
	end
	else if(instruction_format[3]) begin
		if(instruction_type[9])
			mem_addr_I_w = re_r[real_instruction[19:15]][31:2] + imm[31:2];
		else
			mem_addr_I_w = mem_addr;	
	end
	else begin
		mem_addr_I_w = mem_addr;
	end

	/////////////// register //////////////////
	if (instruction_format[0]) begin  // UJ type
		re_w[real_instruction[11:7]]    = {mem_addr, 2'b00};
	end
	else if (instruction_format[3]) begin  // I type
		if (instruction_type[9]) begin  // jalr
			re_w[real_instruction[11:7]] = {32'b0, mem_addr, 2'b0};
		end
		else begin  // lw
			re_w[real_instruction[11:7]][7:0] = mem_rdata_D[31:24];
			re_w[real_instruction[11:7]][15:8] = mem_rdata_D[23:16];
			re_w[real_instruction[11:7]][23:16] = mem_rdata_D[15:8];
			re_w[real_instruction[11:7]][31:24] = mem_rdata_D[7:0];
		end
	end
	else if (instruction_format[4]) begin  // R type
		if (instruction_type[0]) begin  // add
			re_w[real_instruction[11:7]] = re_r[real_instruction[19:15]] + re_r[real_instruction[24:20]];
		end
		else if (instruction_type[1]) begin  // sub
			re_w[real_instruction[11:7]] = re_r[real_instruction[19:15]] - re_r[real_instruction[24:20]];
		end
		else if (instruction_type[4]) begin  // slt
			re_w[real_instruction[11:7]] = (re_r[real_instruction[19:15]] < re_r[real_instruction[24:20]] ? 1 : 0);
		end
		else if (instruction_type[3]) begin  // or
			re_w[real_instruction[11:7]] = re_r[real_instruction[19:15]] | re_r[real_instruction[24:20]];
		end
		else begin  // and
			re_w[real_instruction[11:7]] = re_r[real_instruction[19:15]] & re_r[real_instruction[24:20]];
		end
	end
end

always @(posedge clk) begin
    re_r[0] <= 32'b0;
    if (!rst_n) begin 
		for(i = 1; i < 32; i = i + 1) begin
            re_r[i] <= 32'd0;
        end
        mem_addr_I_r    <= 30'd0;
	end
    else begin
        for(i = 1; i < 32; i = i + 1) begin
            re_r[i] <= re_w[i];
        end
        mem_addr_I_r    <= mem_addr_I_w;
    end
end

endmodule
