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
    
    parameter blockSize     = 4 * 32;
    parameter blockNum      = 8;

    parameter S_IDLE        = 2'd0;
    parameter S_COMP        = 2'd1;
    parameter S_ALLOCATE    = 2'd2;
    parameter S_WRITE       = 2'd3;

//==== wire/reg definition ================================
    
    reg [1:0] state_r, state_w;
    
    reg [blockSize - 1 : 0] store_r [0 : blockNum - 1];
    reg [blockSize - 1 : 0] store_w [0 : blockNum - 1];
    
    reg dirty_r [0 : blockNum - 1];
    reg dirty_w [0 : blockNum - 1];

    reg valid_r [0 : blockNum - 1];
    reg valid_w [0 : blockNum - 1];

    reg [24:0]  tag_r [0 : blockNum - 1];
    reg [24:0]  tag_w [0 : blockNum - 1];

    reg         mem_read_r, mem_read_w;
    reg         mem_write_r, mem_write_w;
    reg [27:0]  mem_addr_r, mem_addr_w;
    reg [127:0] mem_wdata_r, mem_wdata_w;
    
    reg [31:0]  proc_rdata_r, proc_rdata_w;
    reg         proc_stall_r, proc_stall_w; 

    reg [blockSize - 1 : 0] write_buffer_data;
    reg [27:0]              write_buffer_addr;
    
    integer i;

    // ===== wires =====
    reg [24:0]  tag_field;
    reg [2:0]   block_id;
    reg [1:0]   block_offset;
    reg         valid;
    reg         hit;
    reg         dirty;

    assign mem_read     = mem_read_w;
    assign mem_write    = mem_write_w;
    assign mem_addr     = mem_addr_w;
    assign mem_wdata    = mem_wdata_w;

    assign proc_stall   = proc_stall_w;
    assign proc_rdata   = proc_rdata_w;

//==== combinational circuit ==============================
always @(*) begin
    tag_field       = proc_addr[29:5];
    block_id        = proc_addr[4:2];
    block_offset    = proc_addr[1:0];
    hit             = valid_r[block_id] & (tag_r[block_id] == tag_field);
    valid           = valid_r[block_id];
    dirty           = dirty_r[block_id];
    
    proc_rdata_w    = proc_rdata_r;
    for(i = 0; i < blockNum; i = i + 1)
        store_w[i] = store_r[i];
    case (state_r)
        S_IDLE: begin
            if(proc_read) begin
                if(hit) begin // read hit !!
                    if(block_offset == 2'd0)
                        proc_rdata_w = store_r[block_id][31:0];
                    else if(block_offset == 2'd1)
                        proc_rdata_w = store_r[block_id][63:32];
                    else if(block_offset == 2'd2)
                        proc_rdata_w = store_r[block_id][95:64];
                    else
                        proc_rdata_w = store_r[block_id][127:96];
                end
            end
            else if(proc_write) begin
                if(hit) begin // write hit !!
                    if(block_offset == 2'd0)
                        store_w[block_id][31:0] = proc_wdata;
                    else if(block_offset == 2'd1)
                        store_w[block_id][63:32] = proc_wdata;
                    else if(block_offset == 2'd2)
                        store_w[block_id][95:64] = proc_wdata;
                    else
                        store_w[block_id][127:96] = proc_wdata;
                end
            end
        end
        S_ALLOCATE: begin
            if(mem_ready) begin
                if(proc_read) begin // read operation
                    store_w[block_id]   = mem_rdata;
                    if(block_offset == 2'd0)
                        proc_rdata_w        = mem_rdata[31:0];
                    else if(block_offset == 2'd1)
                        proc_rdata_w        = mem_rdata[63:32];
                    else if(block_offset == 2'd2)
                        proc_rdata_w        = mem_rdata[95:64];
                    else
                        proc_rdata_w        = mem_rdata[127:96];
                end
                else begin // write operation
                    if(block_offset == 2'd0) begin
                        store_w[block_id][31:0]     = proc_wdata;
                        store_w[block_id][127:32]   = mem_rdata[127:32];
                    end
                    else if(block_offset == 2'd1) begin
                        store_w[block_id][63:32]    = proc_wdata;
                        store_w[block_id][31:0]     = mem_rdata[31:0];
                        store_w[block_id][127:64]   = mem_rdata[127:64];
                    end
                    else if(block_offset == 2'd2) begin
                        store_w[block_id][95:64]    = proc_wdata;
                        store_w[block_id][63:0]     = mem_rdata[63:0];
                        store_w[block_id][127:96]   = mem_rdata[127:96];
                    end                        
                    else begin
                        store_w[block_id][127:96]   = proc_wdata;
                        store_w[block_id][95:0]     = mem_rdata[95:0];
                    end
                end
            end
        end
    endcase
end
// ========== valid bit ============ //
always @(*) begin
    for(i = 0; i < blockNum; i = i + 1) begin
        valid_w[i] = valid_r[i];
        dirty_w[i] = dirty_r[i];
        tag_w[i] = tag_r[i];
    end
    case (state_r)
        S_IDLE: begin
            if(proc_write && hit)
                dirty_w[block_id]   = 1'b1;
            if((proc_read || proc_write) && !hit) // read/write miss
                valid_w[block_id]   = 1'b0;  
        end
        S_ALLOCATE: begin
            if(mem_ready) begin
                valid_w[block_id]   = 1'b1;
                tag_w[block_id]     = tag_field;
                if(proc_read)
                    dirty_w[block_id]   = 1'b0;
                else
                    dirty_w[block_id]   = 1'b1;
            end
        end
    endcase
end
// ========== memory logic ============ //
always @(*) begin
    case (state_r)
        S_IDLE: begin
            if((proc_read || proc_write) && !hit) begin
                if(dirty) begin
                    mem_write_w         = 1'b1;
                    mem_wdata_w         = store_r[block_id];
                    mem_read_w          = 1'b0;
                    mem_addr_w          = {tag_r[block_id], block_id};
                end
                else begin
                    mem_write_w         = 1'b0;
                    mem_wdata_w         = mem_wdata_r;
                    mem_read_w          = 1'b1;
                    mem_addr_w          = proc_addr[29:2];    
                end
            end
            else begin
                mem_write_w         = 1'b0;
                mem_wdata_w         = mem_wdata_r;
                mem_read_w          = 1'b0;
                mem_addr_w          = mem_addr_r;
            end
        end
        S_WRITE: begin
            if(mem_ready) begin
                mem_write_w         = 1'b0;
                mem_wdata_w         = mem_wdata_r;
                mem_read_w          = 1'b1;
                mem_addr_w          = proc_addr[29:2];
            end
            else begin
                mem_write_w         = 1'b1;
                mem_wdata_w         = mem_wdata_r;
                mem_read_w          = 1'b0;
                mem_addr_w          = mem_addr_r;
            end
        end
        S_ALLOCATE: begin
            if(mem_ready) begin
                mem_write_w         = 1'b0;
                mem_wdata_w         = mem_wdata_r;
                mem_read_w          = 1'b0;
                mem_addr_w          = mem_addr_r;
            end
            else begin
                mem_write_w         = 1'b0;
                mem_wdata_w         = mem_wdata_r;
                mem_read_w          = 1'b1;
                mem_addr_w          = mem_addr_r;
            end
        end
    endcase
end
// =========== state logic ============= //
always @(*) begin
    case (state_r)
        S_IDLE: begin
            if(proc_read || proc_write) begin
                if(hit) //  read/write hit !!
                    state_w      = S_IDLE;
                else begin
                    if(dirty)  // block dirty -> write back
                        state_w             = S_WRITE;
                    else                   // block clean -> allocate memory
                        state_w             = S_ALLOCATE;
                end
            end
            else begin
                state_w     = S_IDLE;  
            end
        end
        S_WRITE: begin
            if(mem_ready)
                state_w     = S_ALLOCATE;
            else
                state_w     = S_WRITE;
        end
        S_ALLOCATE: begin
            if(mem_ready)
                state_w     = S_IDLE;
            else
                state_w     = S_ALLOCATE;
        end
    endcase
end
// ========= pcocessor stall logic ========= //
always @(*) begin
    case (state_r)
        S_IDLE: begin
            if(proc_read || proc_write) begin
                if(hit) //  read/write hit !!
                    proc_stall_w    = 1'b0;
                else 
                    proc_stall_w    = 1'b1;
            end
            else begin
                proc_stall_w    = 1'b0;
            end
        end
        S_WRITE: begin
            proc_stall_w    = 1'b1;
        end
        S_ALLOCATE: begin
            if(mem_ready)
                proc_stall_w    = 1'b0;
            else
                proc_stall_w    = 1'b1;
        end
    endcase
end

//==== sequential circuit =================================
always@( posedge clk ) begin
    if( proc_reset ) begin
        for(i = 0; i < blockNum; i = i + 1) begin
            store_r[i]  <= 128'd0;
            tag_r[i]    <= 25'd0;
            valid_r[i]  <= 1'b0;
            dirty_r[i]  <= 1'b0;
        end
        state_r         <= S_IDLE;
        mem_read_r      <= 1'b0;
        mem_write_r     <= 1'b0;
        mem_wdata_r     <= 128'd0;
        mem_addr_r      <= 28'd0;
        proc_rdata_r    <= 32'd0;
        proc_stall_r    <= 1'b0;
    end
    else begin
        for(i = 0; i < blockNum; i = i + 1) begin
            store_r[i]  <= store_w[i];
            tag_r[i]    <= tag_w[i];
            valid_r[i]  <= valid_w[i];
            dirty_r[i]  <= dirty_w[i];
        end
        state_r         <= state_w;
        mem_read_r      <= mem_read_w;
        mem_write_r     <= mem_write_w;
        mem_wdata_r     <= mem_wdata_w;
        mem_addr_r      <= mem_addr_w;
        proc_rdata_r    <= proc_rdata_w;
        proc_stall_r    <= proc_stall_w;
    end
end

endmodule
