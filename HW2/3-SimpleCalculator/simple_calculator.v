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
// submodule instantiation
register_file REG(
    .Clk(Clk),
    .WEN(WEN),
    .RW(RW),
    .busW(out),
    .RX(RX),
    .RY(RY),
    .busX(),
    .busY()
);

alu_assign ALU(
    .ctrl(Ctrl),
    .x(),
    .y(),
    .carry(),
    .out(out)
);

always @(*) begin
    
end

always @(posedge Clk) begin
    
end
endmodule
