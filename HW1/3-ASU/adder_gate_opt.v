module adder_gate(x, y, carry, out);
input [7:0] x, y;
output carry;
output [7:0] out;

/*Write your code here*/
wire [7:0] C;
wire [7:0] P;
wire [7:0] G;

wire C2, C4, C6;

FA2 ADDER1(.Cin(1'b0), .A(x[1:0]), .B(y[1:0]), .S(out[1:0]), .Cout(C2));
FA2 ADDER2(.Cin(C2), .A(x[3:2]), .B(y[3:2]), .S(out[3:2]), .Cout(C4));
FA2 ADDER3(.Cin(C4), .A(x[5:4]), .B(y[5:4]), .S(out[5:4]), .Cout(C6));
FA2 ADDER4(.Cin(C6), .A(x[7:6]), .B(y[7:6]), .S(out[7:6]), .Cout(carry));

/*End of code*/

endmodule

module FA2(Cin, A, B, S, Cout);
input Cin;
input [1:0] A;
input [1:0] B;
output [1:0] S;
output Cout;

wire [2:0] P;
wire [2:0] G;
wire [2:0] C;
wire w1, w2, w3, w4, w5, w6, w7, w8, w9;
wire G21, P21;

assign P[0] = 1'b0;
assign G[0] = Cin;

assign C[0] = G[0];

// PG logic
xor #1 XOR1(P[1], A[0], B[0]);
xor #1 XOR2(P[2], A[1], B[1]);

and #1 AN1(G[1], A[0], B[0]);
and #1 AN2(G[2], A[1], B[1]);

// Adder
and #1 AN5(w1, P[1], C[0]);
and #1 AN6(w2, P21, C[0]);

or #1 OR1(C[1], w1, G[1]);
//or #1 OR2(C[2], w2, G21);

xor #1 XOR5(S[0], C[0], P[1]);
xor #1 XOR6(S[1], C[1], P[2]);

// Carry propagate
or #1 OR7(G21, G[2], w7);
and #1 AN11(w7, P[2], G[1]);

and #1 AN12(P21, P[1], P[2]);

and #1 AN15(w8, P21, Cin);
or #1 OR8(Cout, w8, G21);

endmodule
