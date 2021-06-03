module L2_cache(
    clk,
    reset,
    cache_read,
    cache_write,
    cache_addr,
    cache_rdata,
    cache_wdata,
    L2_ready,
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
    input          reset;
    input          cache_read, cache_write;
    input   [27:0] cache_addr;
    input  [127:0] cache_wdata;
    output         L2_ready;
    output [127:0] cache_rdata;
    // memory interface
    input  [127:0] mem_rdata;
    input          mem_ready;
    output         mem_read, mem_write;
    output  [27:0] mem_addr;
    output [127:0] mem_wdata;
    
//==== paramterers ================================
    parameter blockSize     = 4 * 32;
    parameter tagSize       = 25;
    parameter validSize     = 1;
    parameter set           = 8;
    parameter way           = 2;

    parameter S_IDLE        = 2'd0;
    parameter S_ALLOCATE    = 2'd1;
    parameter S_WRITE       = 2'd2;
//==== wire/reg definition ================================
    
    reg [1:0] state_r, state_w;
    
    reg [blockSize * way - 1 : 0] store_r [0 : set - 1];
    reg [blockSize * way - 1 : 0] store_w [0 : set - 1];
    
    reg [way - 1 : 0] dirty_r [0 : set - 1];
    reg [way - 1 : 0] dirty_w [0 : set - 1];

    reg [way - 1 : 0] valid_r [0 : set - 1];
    reg [way - 1 : 0] valid_w [0 : set - 1];

    reg [way - 1 : 0] used_r [0 : set - 1];
    reg [way - 1 : 0] used_w [0 : set - 1];

    reg [tagSize * way - 1 : 0]  tag_r [0 : set - 1];
    reg [tagSize * way - 1 : 0]  tag_w [0 : set - 1];

    reg         mem_read_r, mem_read_w;
    reg         mem_write_r, mem_write_w;
    reg [27:0]  mem_addr_r, mem_addr_w;
    reg [127:0] mem_wdata_r, mem_wdata_w;
    
    reg [127:0] cache_rdata_r, cache_rdata_w;
    reg         L2_ready_r, L2_ready_w; 

    integer i;

    //==== double clock ===========
    reg                 cnt;
    reg                 nxt_cnt;

    // ===== wires =====
    reg [tagSize-1:0]   tag_field;
    reg [27-tagSize:0]  block_id;
    reg                 hit_index;
    reg                 valid;
    reg                 hit0, hit1;
    reg                 hit;   
    reg                 dirty;

    // ===== input buffers ======
    reg mem_ready_buf;

    assign mem_read     = mem_read_w;
    assign mem_write    = mem_write_w;
    assign mem_addr     = mem_addr_w;
    assign mem_wdata    = mem_wdata_w;

    assign L2_ready     = L2_ready_w;
    assign cache_rdata   = cache_rdata_w;  

//==== counter ============================================
always @(*) begin
    nxt_cnt = ~cnt;
end

//==== combinational circuit ==============================
always @(*) begin
    tag_field       = cache_addr[27-:tagSize];
    block_id        = cache_addr[27-tagSize:0];
    hit0            = valid_r[block_id][0] & (tag_r[block_id][tagSize - 1 -: tagSize] == tag_field);
    hit1            = valid_r[block_id][1] & (tag_r[block_id][2 * tagSize - 1 -: tagSize] == tag_field);
    hit             = hit0 | hit1;
    hit_index       = hit0 ? 1'b0 : 1'b1;
    valid           = (used_r[block_id][0])?valid_r[block_id][1]:valid_r[block_id][0];
    dirty           = (used_r[block_id][0])?dirty_r[block_id][1]:dirty_r[block_id][0];
    
    cache_rdata_w    = cache_rdata_r;
    for(i = 0; i < set; i = i + 1) begin
        store_w[i] = store_r[i];
        used_w[i] = used_r[i];
    end
        
    case (state_r)
        S_IDLE: begin
            if(cache_read) begin
                if(hit) begin // read hit !!
                    if(hit_index == 1'b0) begin
                        used_w[block_id][0] = 1'b1;
                        used_w[block_id][1] = 1'b0;
                    end
                    else begin
                        used_w[block_id][0] = 1'b0;
                        used_w[block_id][1] = 1'b1;
                    end
                    cache_rdata_w = store_r[block_id][127 + blockSize * hit_index -: 128];
                end
            end
            else if(cache_write) begin
                if(hit) begin // write hit !!
                    if(hit_index == 1'b0) begin
                        used_w[block_id][0]     = 1'b1;
                        used_w[block_id][1]     = 1'b0;
                    end
                    else begin
                        used_w[block_id][0]     = 1'b0;
                        used_w[block_id][1]     = 1'b1;
                    end
                    store_w[block_id][127 + blockSize * hit_index -: 128] = cache_wdata;
                end
            end
        end
        S_ALLOCATE: begin
            if(mem_ready_buf) begin
                if(cache_read) begin // read operation
                    if(used_r[block_id][0]) begin
                        store_w[block_id][2 * blockSize - 1 -: 128]   = mem_rdata;
                        used_w[block_id][0] = 1'b0;
                        used_w[block_id][1] = 1'b1;
                    end
                    else begin
                        store_w[block_id][blockSize - 1 -: 128]   = mem_rdata;
                        used_w[block_id][0] = 1'b1;
                        used_w[block_id][1] = 1'b0;
                    end
                    cache_rdata_w        = mem_rdata;
                end
                else begin // write operation
                    if(used_r[block_id][0]) begin
                        used_w[block_id][0] = 1'b0;
                        used_w[block_id][1] = 1'b1;
                        store_w[block_id][2 * blockSize - 1 -: 128] = cache_wdata;
                    end
                    else begin
                        used_w[block_id][0] = 1'b1;
                        used_w[block_id][1] = 1'b0;
                        store_w[block_id][blockSize - 1 -: 128] = cache_wdata;
                    end
                end
            end
        end
    endcase
end
// ========== valid bit ============ //
always @(*) begin
    for(i = 0; i < set; i = i + 1) begin
        valid_w[i] = valid_r[i];
        dirty_w[i] = dirty_r[i];
        tag_w[i] = tag_r[i];
    end
    case (state_r)
        S_IDLE: begin
            if(cache_write && hit) begin
                dirty_w[block_id][hit_index] = 1'b1;
            end
        end
        S_ALLOCATE: begin
            if(mem_ready_buf) begin
                if(used_r[block_id][0]) begin
                    valid_w[block_id][1]   = 1'b1;
                    tag_w[block_id][2 * tagSize - 1 -: tagSize] = tag_field;
                    if(cache_read)
                        dirty_w[block_id][1]   = 1'b0;
                    else
                        dirty_w[block_id][1]   = 1'b1;    
                end
                else begin
                    valid_w[block_id][0]   = 1'b1;
                    tag_w[block_id][1 * tagSize - 1 -: tagSize] = tag_field;
                    if(cache_read)
                        dirty_w[block_id][0]   = 1'b0;
                    else
                        dirty_w[block_id][0]   = 1'b1;
                end
            end
        end
    endcase
end
// ========== memory logic ============ //
always @(*) begin
    mem_write_w         = mem_write_r;
    mem_wdata_w         = mem_wdata_r;
    mem_read_w          = mem_read_r;
    mem_addr_w          = mem_addr_r;    
    case (state_r)
        S_IDLE: begin
            if((cache_read || cache_write) && !hit) begin
                if(dirty) begin
                    mem_write_w         = 1'b1;
                    mem_read_w          = 1'b0;
                    
                    if(used_r[block_id][0]) begin
                        mem_wdata_w         = store_r[block_id][2 * blockSize - 1 -: 128];
                        mem_addr_w          = {tag_r[block_id][2 * tagSize - 1 -: tagSize], block_id};
                    end
                    else begin
                        mem_wdata_w         = store_r[block_id][blockSize - 1 -: 128];
                        mem_addr_w          = {tag_r[block_id][tagSize - 1 -: tagSize], block_id};
                    end
                end
                else begin
                    mem_write_w         = 1'b0;
                    mem_wdata_w         = mem_wdata_r;
                    mem_read_w          = 1'b1;
                    mem_addr_w          = cache_addr;    
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
            if(mem_ready_buf) begin
                mem_write_w         = 1'b0;
                mem_wdata_w         = mem_wdata_r;
                mem_read_w          = 1'b1;
                mem_addr_w          = cache_addr;
            end
            else begin
                mem_write_w         = 1'b1;
                mem_wdata_w         = mem_wdata_r;
                mem_read_w          = 1'b0;
                mem_addr_w          = mem_addr_r;
            end
        end
        S_ALLOCATE: begin
            if(mem_ready_buf) begin
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
    state_w = state_r;
    case (state_r)
        S_IDLE: begin
            if(cache_read || cache_write) begin
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
            if(mem_ready_buf)
                state_w     = S_ALLOCATE;
            else
                state_w     = S_WRITE;
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
    L2_ready_w = L2_ready_r;
    case (state_r)
        S_IDLE: begin
            if(cache_read || cache_write) begin
                if(hit) //  read/write hit !!
                    L2_ready_w    = 1'b1;
                else 
                    L2_ready_w    = 1'b0;
            end
            else begin
                L2_ready_w    = 1'b0;
            end
        end
        S_WRITE: begin
            L2_ready_w    = 1'b0;
        end
        S_ALLOCATE: begin
            if(mem_ready_buf)
                L2_ready_w    = 1'b1;
            else
                L2_ready_w    = 1'b0;
        end
    endcase
end

//==== sequential circuit =================================
always @( posedge clk) begin
    cnt                 <= nxt_cnt;
end
always@( posedge (clk & cnt) ) begin
    if( reset ) begin
        for(i = 0; i < set; i = i + 1) begin
            store_r[i]  <= {way{128'd0}};
            tag_r[i]    <= {way{25'd0}};
            valid_r[i]  <= {way{1'b0}};
            dirty_r[i]  <= {way{1'b0}};
            used_r[i]   <= {way{1'b0}};
        end
        state_r         <= S_IDLE;
        mem_read_r      <= 1'b0;
        mem_write_r     <= 1'b0;
        mem_wdata_r     <= 128'd0;
        mem_addr_r      <= 28'd0;
        cache_rdata_r   <= 128'd0;
        L2_ready_r      <= 1'b0;
        mem_ready_buf   <= 1'b0;
        cnt             <= 1'b0;
    end
    else begin
        for(i = 0; i < set; i = i + 1) begin
            store_r[i]  <= store_w[i];
            tag_r[i]    <= tag_w[i];
            valid_r[i]  <= valid_w[i];
            dirty_r[i]  <= dirty_w[i];
            used_r[i]   <= used_w[i];
        end
        state_r         <= state_w;
        mem_read_r      <= mem_read_w;
        mem_write_r     <= mem_write_w;
        mem_wdata_r     <= mem_wdata_w;
        mem_addr_r      <= mem_addr_w;
        cache_rdata_r   <= cache_rdata_w;
        L2_ready_r      <= L2_ready_w;
        mem_ready_buf   <= mem_ready;
    end
end

endmodule
