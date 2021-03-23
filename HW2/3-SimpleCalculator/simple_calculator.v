module simple_calculator(
    Clk,
    WEN,
    RW,
    RX,
    RY,
    DataIn,
    Sel,
    Ctrl,
    busY,
    Carry
);

    input        Clk;
    input        WEN;
    input  [2:0] RW, RX, RY;
    input  [7:0] DataIn;
    input        Sel;
    input  [3:0] Ctrl;
    output [7:0] busY;
    output       Carry;

// declaration of wire/reg
    wire [7:0] out;
    wire [7:0] MUX_out;
    wire [7:0] Xout;
    wire [7:0] Yout;

    assign MUX_out = Sel ? Xout : DataIn;
    assign busY = Yout;
// submodule instantiation
register_file REG(
    .Clk(Clk),
    .WEN(WEN),
    .RW(RW),
    .busW(out),
    .RX(RX),
    .RY(RY),
    .busX(Xout),
    .busY(Yout)
);

alu_assign ALU(
    .ctrl(Ctrl),
    .x(MUX_out),
    .y(Yout),
    .carry(Carry),
    .out(out)
);

endmodule

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



assign busX = RX == 3'b000 ? r0_r
            : RX == 3'b001 ? r1_r
            : RX == 3'b010 ? r2_r
            : RX == 3'b011 ? r3_r
            : RX == 3'b100 ? r4_r
            : RX == 3'b101 ? r5_r
            : RX == 3'b110 ? r6_r
            : r7_r;
assign busY = RY == 3'b000 ? r0_r
            : RY == 3'b001 ? r1_r
            : RY == 3'b010 ? r2_r
            : RY == 3'b011 ? r3_r
            : RY == 3'b100 ? r4_r
            : RY == 3'b101 ? r5_r
            : RY == 3'b110 ? r6_r
            : r7_r;
    
always@(*) begin
    r0_w        = r0_r;
    r1_w        = r1_r;
    r2_w        = r2_r;
    r3_w        = r3_r;
    r4_w        = r4_r;
    r5_w        = r5_r;
    r6_w        = r6_r;
    r7_w        = r7_r;
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
end

always@(posedge Clk) begin
    r0_r        <= 8'd0;
    r1_r        <= r1_w;
    r2_r        <= r2_w;
    r3_r        <= r3_w;
    r4_r        <= r4_w;
    r5_r        <= r5_w;
    r6_r        <= r6_w;
    r7_r        <= r7_w;
end	

endmodule


//RTL (use continuous assignment)
module alu_assign(
    ctrl,
    x,
    y,
    carry,
    out  
);
    
    input  [3:0] ctrl;
    input  [7:0] x;
    input  [7:0] y;
    output       carry;
    output [7:0] out;
    
    wire signed [7:0] add;
    wire signed [7:0] sub;

    assign add = $signed(x) + $signed(y);
    assign sub = $signed(x) - $signed(y);

    assign out = (ctrl == 4'b0000) ? add
                 : (ctrl == 4'b0001) ? sub
                 : (ctrl == 4'b0010) ? x & y
                 : (ctrl == 4'b0011) ? x | y
                 : (ctrl == 4'b0100) ? ~x
                 : (ctrl == 4'b0101) ? x ^ y
                 : (ctrl == 4'b0110) ? ~(x | y)
                 : (ctrl == 4'b0111) ? y << x[2:0]
                 : (ctrl == 4'b1000) ? y >> x[2:0]
                 : (ctrl == 4'b1001) ? {x[7], x[7:1]}
                 : (ctrl == 4'b1010) ? {x[6:0], x[7]}
                 : (ctrl == 4'b1011) ? {x[0], x[7:1]}
                 : (ctrl == 4'b1100) ? ((x == y) ? 1 : 0)
                 : 8'd0;
    assign carry = (ctrl == 4'b0000) ? add[7]
                   : (ctrl == 4'b0001) ? sub[7]
                   : 1'b0;
endmodule

