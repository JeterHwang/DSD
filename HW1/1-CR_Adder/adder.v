module adder(x, y, carry, out);
input [7:0] x, y;
output carry;
output [7:0] out;

/*Write your code here*/
assign out      = ({1'b0, x} + {1'b0, y})[7:0];
assign carry    = ({1'b0, x} + {1'b0, y})[8];
/*End of code*/

endmodule