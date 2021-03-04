module adder(x, y, carry, out);
input [7:0] x, y;
output carry;
output [7:0] out;

/*Write your code here*/
wire [8:0] subresult;

assign subresult    = {1'b0, x} + {1'b0, y};
assign out          = subresult[7:0];
assign carry        = subresult[8];
/*End of code*/

endmodule