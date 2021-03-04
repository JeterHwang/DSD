module adder_gate(x, y, carry, out);
input [7:0] x, y;
output carry;
output [7:0] out;

/*Write your code here*/
wire [8:0] C;

assign C[0] = 1'b0;
assign carry = C[8];

generate;
    genvar i;
    for(i = 0; i < 8; i = i + 1) begin
        FA full_adder(.Cin(C[i]), .a(x[i]), .b(y[i]), .Cout(C[i + 1]), .S(out[i]));
    end
endgenerate

/*End of code*/

endmodule

module FA(Cin, a, b, Cout, S);
    input Cin;
    input a;
    input b;
    output Cout;
    output S;
    
    wire aXb, aAb, w1;

    xor2 XO1(.in1(a), .in2(b), .out(aXb));
    xor2 XO2(.in1(aXb), .in2(Cin), .out(S));
    and2 AN1(.in1(a), .in2(b), .out(aAb));
    and2 AN2(.in1(aXb), .in2(Cin), .out(w1));
    or2  OR1(.in1(w1), .in2(aAb), .out(Cout));


endmodule