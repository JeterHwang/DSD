module adder_gate(x, y, carry, out);
input [7:0] x, y;
output carry;
output [7:0] out;

/*Write your code here*/
wire [7:0] C;
wire [7:0] P;
wire [7:0] G;

wire C4;

FA4 ADDER1(.Cin(1'b0), .A(x[3:0]), .B(y[3:0]), .S(out[3:0]), .Cout(C4));
FA4 ADDER2(.Cin(C4), .A(x[7:4]), .B(y[7:4]), .S(out[7:4]), .Cout(carry));

/*End of code*/

endmodule

module FA4(Cin, A, B, S, Cout);
input Cin;
input [3:0] A;
input [3:0] B;
output [3:0] S;
output Cout;

wire [4:0] P;
wire [4:0] G;
wire [4:0] C;
wire w1, w2, w3, w4, w5, w6, w7, w8, w9;
wire G21, G31, G41, P21, P31, P41;

assign P[0] = 1'b0;
assign G[0] = Cin;

assign C[0] = G[0];

// PG logic
xor #1 XOR1(P[1], A[0], B[0]);
xor #1 XOR2(P[2], A[1], B[1]);
xor #1 XOR3(P[3], A[2], B[2]);
xor #1 XOR4(P[4], A[3], B[3]);

and #1 AN1(G[1], A[0], B[0]);
and #1 AN2(G[2], A[1], B[1]);
and #1 AN3(G[3], A[2], B[2]);
and #1 AN4(G[4], A[3], B[3]);

// Adder
and #1 AN5(w1, P[1], C[0]);
and #1 AN6(w2, P21, C[0]);
and #1 AN7(w3, P31, C[0]);
and #1 AN8(w4, P41, C[0]);

or #1 OR1(C[1], w1, G[1]);
or #1 OR2(C[2], w2, G21);
or #1 OR3(C[3], w3, G31);
// or #1 OR4(C[4], w4, G41);

xor #1 XOR5(S[0], C[0], P[1]);
xor #1 XOR6(S[1], C[1], P[2]);
xor #1 XOR7(S[2], C[2], P[3]);
xor #1 XOR8(S[3], C[3], P[4]);

// Carry propagate
or #1 OR5(G41, G[4], w5);
and #1 AN9(w5, P[4], G31);
or #1 OR6(G31, G[3], w6);
and #1 AN10(w6, P[3], G21);
or #1 OR7(G21, G[2], w7);
and #1 AN11(w7, P[2], G[1]);

and #1 AN12(P21, P[1], P[2]);
and #1 AN13(P31, P21, P[3]);
and #1 AN14(P41, P31, P[4]);

and #1 AN15(w8, P41, Cin);
or #1 OR8(Cout, w8, G41);

endmodule
