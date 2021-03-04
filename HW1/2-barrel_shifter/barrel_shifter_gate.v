module barrel_shifter_gate(in, shift, out);
input  [7:0] in;
input  [2:0] shift;
output [7:0] out;

/*Write your code here*/
wire [7:0] w1;
wire [7:0] w2;

mux MU17(w1[7], in[7], in[6], shift[0]);
mux MU16(w1[6], in[6], in[5], shift[0]);
mux MU15(w1[5], in[5], in[4], shift[0]);
mux MU14(w1[4], in[4], in[3], shift[0]);
mux MU13(w1[3], in[3], in[2], shift[0]);
mux MU12(w1[2], in[2], in[1], shift[0]);
mux MU11(w1[1], in[1], in[0], shift[0]);
mux MU10(w1[0], in[0], 1'b0, shift[0]);

mux MU27(w2[7], w1[7], w1[5], shift[1]);
mux MU26(w2[6], w1[6], w1[4], shift[1]);
mux MU25(w2[5], w1[5], w1[3], shift[1]);
mux MU24(w2[4], w1[4], w1[2], shift[1]);
mux MU23(w2[3], w1[3], w1[1], shift[1]);
mux MU22(w2[2], w1[2], w1[0], shift[1]);
mux MU21(w2[1], w1[1], 1'b0, shift[1]);
mux MU20(w2[0], w1[0], 1'b0, shift[1]);

mux MU47(out[7], w2[7], w2[3], shift[2]);
mux MU46(out[6], w2[6], w2[2], shift[2]);
mux MU45(out[5], w2[5], w2[1], shift[2]);
mux MU44(out[4], w2[4], w2[0], shift[2]);
mux MU43(out[3], w2[3], 1'b0, shift[2]);
mux MU42(out[2], w2[2], 1'b0, shift[2]);
mux MU41(out[1], w2[1], 1'b0, shift[2]);
mux MU40(out[0], w2[0], 1'b0, shift[2]);

/*End of code*/
endmodule

module mux (x,a,b,sel);
input 	a,b,sel;
output 	x;
wire sel_i,w1,w2;

not #1 n0(sel_i,sel);
and #1 a1(w1,a,sel_i);
and #1 a2(w2,b,sel);
or  #1 o1(x,w1,w2);

	
endmodule
