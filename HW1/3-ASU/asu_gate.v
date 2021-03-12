module asu_gate (x, y, mode, carry, out);
input [7:0] x, y;
input mode;
output carry;
output [7:0] out;

/*Write your code here*/
wire [8:0] adder_result, shifter_result;

assign shifter_result[8] = 1'b0;
assign #2.5 {carry, out} = mode ? adder_result : shifter_result;

barrel_shifter_gate BS(.in(x), .shift(y[2:0]), .out(shifter_result[7:0]));
adder_gate AD(.x(x), .y(y), .carry(adder_result[8]), .out(adder_result[7:0]));

/*End of code*/


endmodule
