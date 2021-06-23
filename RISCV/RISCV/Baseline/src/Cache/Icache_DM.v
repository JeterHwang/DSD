module Icache(
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
    
//==== paramterers ================================
    parameter blockSize     = 4 * 32;
    parameter tagSize       = 5;
    parameter validSize     = 1;
    parameter set           = 8;
    parameter way           = 1;

    parameter S_IDLE        = 1'b0;
    parameter S_ALLOCATE    = 1'b1;

//==== wire/reg definition ================================
    
    reg state_r, state_w;
    
    reg [blockSize * way - 1 : 0] store_r [0 : set - 1];
    reg [blockSize * way - 1 : 0] store_w [0 : set - 1];

    reg valid_r [0 : set - 1];
    reg valid_w [0 : set - 1];

    reg [tagSize * way - 1 : 0]  tag_r [0 : set - 1];
    reg [tagSize * way - 1 : 0]  tag_w [0 : set - 1];

    reg         mem_read_r, mem_read_w;
    reg [7:0]  mem_addr_r, mem_addr_w;
    
    reg [31:0]  proc_rdata_r, proc_rdata_w;
    reg         proc_stall_r, proc_stall_w; 

    integer i;

    // ===== wires =====
    reg [tagSize-1:0]  tag_field;
    reg [2:0]   block_id;
    reg [1:0]   block_offset;
    reg         hit;   

    // ===== input buffers ======
    reg mem_ready_buf;

    assign mem_read     = mem_read_w;
    assign mem_write    = 1'b0;
    assign mem_addr     = {20'd0, mem_addr_w};

    assign proc_stall   = proc_stall_w;
    assign proc_rdata   = proc_rdata_w;   


//==== combinational circuit ==============================
always @(*) begin
    tag_field       = proc_addr[9-:tagSize];
    block_id        = proc_addr[9-tagSize:2];
    block_offset    = proc_addr[1:0];
    hit             = valid_r[block_id] & (tag_r[block_id] == tag_field);
    
    proc_rdata_w    = proc_rdata_r;
    for(i = 0; i < set; i = i + 1) begin
        store_w[i] = store_r[i];
        used_w[i] = used_r[i];
    end
        
    case (state_r)
        S_IDLE: begin
            if(proc_read & hit) begin
                    case(block_offset)
                        2'd0 : proc_rdata_w = store_r[block_id][31 -: 32];
                        2'd1 : proc_rdata_w = store_r[block_id][63 -: 32];
                        2'd2 : proc_rdata_w = store_r[block_id][95 -: 32];
                        2'd3 : proc_rdata_w = store_r[block_id][127 -: 32];
                        default : proc_rdata_w    = proc_rdata_r;
                    endcase
            end
        end
        S_ALLOCATE: begin
            if(mem_ready_buf) begin
                    store_w[block_id]   = mem_rdata;
                    case(block_offset)
                        2'd0 : proc_rdata_w        = mem_rdata[31:0];
                        2'd1 : proc_rdata_w        = mem_rdata[63:32];
                        2'd2 : proc_rdata_w        = mem_rdata[95:64];
                        2'd3 : proc_rdata_w        = mem_rdata[127:96];
                    default : proc_rdata_w    = proc_rdata_r;
                    endcase
            end
        end
    endcase
end
// ========== valid bit ============ //
always @(*) begin
    for(i = 0; i < set; i = i + 1) begin
        valid_w[i] = valid_r[i];
        tag_w[i] = tag_r[i];
    end
    case (state_r)
        S_ALLOCATE: begin
            if(mem_ready_buf) begin
                    valid_w[block_id]   = 1'b1;
                    tag_w[block_id] = tag_field;  
            end
        end
    endcase
end
// ========== memory logic ============ //
always @(*) begin
    mem_read_w          = mem_read_r;
    mem_addr_w          = mem_addr_r;    
    case (state_r)
        S_IDLE: begin
            if((proc_read) && !hit) begin
                    mem_read_w          = 1'b1;
                    mem_addr_w          = proc_addr[9:2];    
            end
            else begin
                mem_read_w          = 1'b0;
                mem_addr_w          = mem_addr_r;
            end
        end
        S_ALLOCATE: begin
            if(mem_ready_buf) begin
                mem_read_w          = 1'b0;
                mem_addr_w          = mem_addr_r;
            end
            else begin
                mem_read_w          = 1'b1;
                mem_addr_w          = mem_addr_r;
            end
        end
    endcase
end
// =========== state logic ============= //
always @(*) begin
    state_w = state_r;
    case (state_r)
        S_IDLE: begin
            if(proc_read && (!hit)) begin               // block clean -> allocate memory
                state_w             = S_ALLOCATE;
            end
            else begin
                state_w     = S_IDLE;  
            end
        end
        S_ALLOCATE: begin
            if(mem_ready_buf)
                state_w     = S_IDLE;
            else
                state_w     = S_ALLOCATE;
        end
    endcase
end
// ========= pcocessor stall logic ========= //
always @(*) begin
    proc_stall_w = proc_stall_r;
    case (state_r)
        S_IDLE: begin
            if(proc_read&&(!hit)) begin
                proc_stall_w    = 1'b1;
            end
            else begin
                proc_stall_w    = 1'b0;
            end
        end
        S_ALLOCATE: begin
            if(mem_ready_buf)
                proc_stall_w    = 1'b0;
            else
                proc_stall_w    = 1'b1;
        end
    endcase
end

//==== sequential circuit =================================
always@( posedge clk ) begin
    if( proc_reset ) begin
        for(i = 0; i < set; i = i + 1) begin
            store_r[i]  <= {way{128'd0}};
            tag_r[i]    <= {way{5'd0}};
            valid_r[i]  <= {way{1'b0}};
            used_r[i]   <= {way{1'b0}};
        end
        state_r         <= S_IDLE;
        mem_read_r      <= 1'b0;
        mem_addr_r      <= 8'd0;
        proc_rdata_r    <= 32'd0;
        proc_stall_r    <= 1'b0;
        mem_ready_buf   <= 1'b0;
    end
    else begin
        for(i = 0; i < set; i = i + 1) begin
            store_r[i]  <= store_w[i];
            tag_r[i]    <= tag_w[i];
            valid_r[i]  <= valid_w[i];
            used_r[i]   <= used_w[i];
        end
        state_r         <= state_w;
        mem_read_r      <= mem_read_w;
        mem_addr_r      <= mem_addr_w;
        proc_rdata_r    <= proc_rdata_w;
        proc_stall_r    <= proc_stall_w;
        mem_ready_buf   <= mem_ready;
    end
end

endmodule
