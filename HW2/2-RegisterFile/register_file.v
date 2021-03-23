module register_file(
    Clk  ,
    WEN  ,
    RW   ,
    busW ,
    RX   ,
    RY   ,
    busX ,
    busY
);
input        Clk, WEN;
input  [2:0] RW, RX, RY;
input  [7:0] busW;
output [7:0] busX, busY;
    
// write your design here, you can delcare your own wires and regs. 
// The code below is just an eaxmple template
reg [7:0] r0_w, r1_w, r2_w, r3_w, r4_w, r5_w, r6_w, r7_w;
reg [7:0] r0_r, r1_r, r2_r, r3_r, r4_r, r5_r, r6_r, r7_r;

reg [7:0] data_x_r, data_x_w;
reg [7:0] data_y_r, data_y_w;

assign busX = data_x_r;
assign busY = data_y_r;
    
always@(*) begin
    r0_w        = 8'd0;
    r1_w        = r1_r;
    r2_w        = r2_r;
    r3_w        = r3_r;
    r4_w        = r4_r;
    r5_w        = r5_r;
    r6_w        = r6_r;
    r7_w        = r7_r;
    data_x_w    = data_x_r;
    data_y_w    = data_y_r;
    if(WEN) begin
        case (RW)
            3'b001: r1_w = busW;
            3'b010: r2_w = busW;
            3'b011: r3_w = busW;
            3'b100: r4_w = busW;
            3'b101: r5_w = busW;
            3'b110: r6_w = busW;
            3'b111: r7_w = busW;
        endcase
    end
    else begin
        case (RX)
            3'b000: data_x_w = r0_r;
            3'b001: data_x_w = r1_r;
            3'b010: data_x_w = r2_r;
            3'b011: data_x_w = r3_r;
            3'b100: data_x_w = r4_r;
            3'b101: data_x_w = r5_r;
            3'b110: data_x_w = r6_r;
            3'b111: data_x_w = r7_r;
        endcase
        case (RY)
            3'b000: data_y_w = r0_r;
            3'b001: data_y_w = r1_r;
            3'b010: data_y_w = r2_r;
            3'b011: data_y_w = r3_r;
            3'b100: data_y_w = r4_r;
            3'b101: data_y_w = r5_r;
            3'b110: data_y_w = r6_r;
            3'b111: data_y_w = r7_r;
        endcase
    end
end

always@(posedge Clk) begin
    r0_r        <= r0_w;
    r1_r        <= r1_w;
    r2_r        <= r2_w;
    r3_r        <= r3_w;
    r4_r        <= r4_w;
    r5_r        <= r5_w;
    r6_r        <= r6_w;
    r7_r        <= r7_w;
    data_x_r    <= data_x_w;
    data_y_r    <= data_y_w;
end	

endmodule
