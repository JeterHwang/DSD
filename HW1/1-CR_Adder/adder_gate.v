module adder_gate(x, y, carry, out);
input [7:0] x, y;
output carry;
output [7:0] out;

/*Write your code here*/
wire [8:0] C;

assign C[0] = 1'b0;
assign carry = C[8];

generate
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

    xor XO1(aXb, a, b);
    xor XO2(S, Cin, aXb);
    and AN1(aAb, a, b);
    and AN2(w1, Cin, aXb);
    or  OR1(Cout, aAb, w1);


endmodule