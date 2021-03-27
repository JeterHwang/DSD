//RT �Vlevel (event-driven) 
module alu_always(
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
    
    reg signed [7:0] out_o;
    reg carry_o;

    assign out      = out_o;
    assign carry    = carry_o;

    always @(*) begin
        out_o     = 8'd0;
        carry_o   = 1'b0;
        case (ctrl)
            4'b0000: begin
                out_o     = $signed(x) + $signed(y);
                carry_o   = out_o[7];
            end
            4'b0001: begin
                out_o     = $signed(x) - $signed(y);
                carry_o   = out_o[7];
            end
            4'b0010: begin
                out_o     = x & y;
            end
            4'b0011: begin
                out_o     = x | y;
            end
            4'b0100: begin
                out_o     = ~x;
            end
            4'b0101: begin
                out_o     = x ^ y;
            end
            4'b0110: begin
                out_o     = ~(x | y);
            end
            4'b0111: begin
                out_o     = y << x[2:0];
            end
            4'b1000: begin
                out_o     = y >> x[2:0];
            end
            4'b1001: begin
                out_o     = {x[7], x[7:1]};
            end
            4'b1010: begin
                out_o     = {x[6:0], x[7]};
            end
            4'b1011: begin
                out_o     = {x[0], x[7:1]};
            end
            4'b1100: begin
                if(x == y) out_o = 1;
                else out_o = 0;
            end
        endcase
    end
endmodule
