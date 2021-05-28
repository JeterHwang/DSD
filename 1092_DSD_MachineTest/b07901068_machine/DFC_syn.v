/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : N-2017.09-SP2
// Date      : Thu May 27 16:05:20 2021
/////////////////////////////////////////////////////////////


module ALU_0_DW01_add_0 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   n1;
  wire   [8:1] carry;

  XOR3X1 U1_8 ( .A(A[8]), .B(B[8]), .C(carry[8]), .Y(SUM[8]) );
  ADDFXL U1_1 ( .A(A[1]), .B(B[1]), .CI(n1), .CO(carry[2]), .S(SUM[1]) );
  ADDFXL U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2])
         );
  ADDFXL U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3])
         );
  ADDFXL U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFXL U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  ADDFXL U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  ADDFXL U1_7 ( .A(A[7]), .B(B[7]), .CI(carry[7]), .CO(carry[8]), .S(SUM[7])
         );
  AND2X2 U1 ( .A(B[0]), .B(A[0]), .Y(n1) );
  XOR2X1 U2 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
endmodule


module ALU_0 ( out, mode, in_a, in_b );
  output [8:0] out;
  input [7:0] in_a;
  input [7:0] in_b;
  input mode;


  ALU_0_DW01_add_0 r293 ( .A({in_a[7], in_a}), .B({in_b[7], in_b}), .CI(1'b0), 
        .SUM(out) );
endmodule


module ALU_3_DW01_add_0 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   n1;
  wire   [8:1] carry;

  XOR3X1 U1_8 ( .A(A[8]), .B(B[8]), .C(carry[8]), .Y(SUM[8]) );
  ADDFXL U1_1 ( .A(A[1]), .B(B[1]), .CI(n1), .CO(carry[2]), .S(SUM[1]) );
  ADDFXL U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2])
         );
  ADDFXL U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3])
         );
  ADDFXL U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFXL U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  ADDFXL U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  ADDFXL U1_7 ( .A(A[7]), .B(B[7]), .CI(carry[7]), .CO(carry[8]), .S(SUM[7])
         );
  AND2X2 U1 ( .A(B[0]), .B(A[0]), .Y(n1) );
  XOR2X1 U2 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
endmodule


module ALU_3 ( out, mode, in_a, in_b );
  output [8:0] out;
  input [7:0] in_a;
  input [7:0] in_b;
  input mode;


  ALU_3_DW01_add_0 r293 ( .A({in_a[7], in_a}), .B({in_b[7], in_b}), .CI(1'b0), 
        .SUM(out) );
endmodule


module ALU_2_DW01_add_0 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   n1;
  wire   [8:1] carry;

  XOR3X1 U1_8 ( .A(A[8]), .B(B[8]), .C(carry[8]), .Y(SUM[8]) );
  ADDFXL U1_1 ( .A(A[1]), .B(B[1]), .CI(n1), .CO(carry[2]), .S(SUM[1]) );
  ADDFXL U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2])
         );
  ADDFXL U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3])
         );
  ADDFXL U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFXL U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  ADDFXL U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  ADDFXL U1_7 ( .A(A[7]), .B(B[7]), .CI(carry[7]), .CO(carry[8]), .S(SUM[7])
         );
  AND2X2 U1 ( .A(B[0]), .B(A[0]), .Y(n1) );
  XOR2X1 U2 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
endmodule


module ALU_2 ( out, mode, in_a, in_b );
  output [8:0] out;
  input [7:0] in_a;
  input [7:0] in_b;
  input mode;


  ALU_2_DW01_add_0 r293 ( .A({in_a[7], in_a}), .B({in_b[7], in_b}), .CI(1'b0), 
        .SUM(out) );
endmodule


module ALU_1_DW01_add_0 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   n1;
  wire   [8:1] carry;

  XOR3X1 U1_8 ( .A(A[8]), .B(B[8]), .C(carry[8]), .Y(SUM[8]) );
  ADDFXL U1_1 ( .A(A[1]), .B(B[1]), .CI(n1), .CO(carry[2]), .S(SUM[1]) );
  ADDFXL U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2])
         );
  ADDFXL U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3])
         );
  ADDFXL U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFXL U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  ADDFXL U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  ADDFXL U1_7 ( .A(A[7]), .B(B[7]), .CI(carry[7]), .CO(carry[8]), .S(SUM[7])
         );
  AND2X2 U1 ( .A(B[0]), .B(A[0]), .Y(n1) );
  XOR2X1 U2 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
endmodule


module ALU_1 ( out, mode, in_a, in_b );
  output [8:0] out;
  input [7:0] in_a;
  input [7:0] in_b;
  input mode;


  ALU_1_DW01_add_0 r293 ( .A({in_a[7], in_a}), .B({in_b[7], in_b}), .CI(1'b0), 
        .SUM(out) );
endmodule


module DFC ( clk, reset, datain, cmd, cmd_valid, dataout, output_valid, busy
 );
  input [7:0] datain;
  input [1:0] cmd;
  output [8:0] dataout;
  input clk, reset, cmd_valid;
  output output_valid, busy;
  wire   N17, N18, n295, n296, n297, n298, n299, n300, n301, n302, n303, n304,
         \dataout_w[0][8] , \dataout_w[0][7] , \dataout_w[0][6] ,
         \dataout_w[0][5] , \dataout_w[0][4] , \dataout_w[0][3] ,
         \dataout_w[0][2] , \dataout_w[0][1] , \dataout_w[0][0] ,
         \dataout_w[1][8] , \dataout_w[1][7] , \dataout_w[1][6] ,
         \dataout_w[1][5] , \dataout_w[1][4] , \dataout_w[1][3] ,
         \dataout_w[1][2] , \dataout_w[1][1] , \dataout_w[1][0] ,
         \dataout_w[2][8] , \dataout_w[2][7] , \dataout_w[2][6] ,
         \dataout_w[2][5] , \dataout_w[2][4] , \dataout_w[2][3] ,
         \dataout_w[2][2] , \dataout_w[2][1] , \dataout_w[2][0] ,
         \dataout_w[3][8] , \dataout_w[3][7] , \dataout_w[3][6] ,
         \dataout_w[3][5] , \dataout_w[3][4] , \dataout_w[3][3] ,
         \dataout_w[3][2] , \dataout_w[3][1] , \dataout_w[3][0] ,
         \data_buf[0][7] , \data_buf[0][6] , \data_buf[0][5] ,
         \data_buf[0][4] , \data_buf[0][3] , \data_buf[0][2] ,
         \data_buf[0][1] , \data_buf[0][0] , \data_buf[1][7] ,
         \data_buf[1][6] , \data_buf[1][5] , \data_buf[1][4] ,
         \data_buf[1][3] , \data_buf[1][2] , \data_buf[1][1] ,
         \data_buf[1][0] , \data_buf[2][7] , \data_buf[2][6] ,
         \data_buf[2][5] , \data_buf[2][4] , \data_buf[2][3] ,
         \data_buf[2][2] , \data_buf[2][1] , \data_buf[2][0] ,
         \data_buf[3][7] , \data_buf[3][6] , \data_buf[3][5] ,
         \data_buf[3][4] , \data_buf[3][3] , \data_buf[3][2] ,
         \data_buf[3][1] , \data_buf[3][0] , \data_buf[4][7] ,
         \data_buf[4][6] , \data_buf[4][5] , \data_buf[4][4] ,
         \data_buf[4][3] , \data_buf[4][2] , \data_buf[4][1] ,
         \data_buf[4][0] , \data_buf[5][7] , \data_buf[5][6] ,
         \data_buf[5][5] , \data_buf[5][4] , \data_buf[5][3] ,
         \data_buf[5][2] , \data_buf[5][1] , \data_buf[5][0] ,
         \data_buf[6][7] , \data_buf[6][6] , \data_buf[6][5] ,
         \data_buf[6][4] , \data_buf[6][3] , \data_buf[6][2] ,
         \data_buf[6][1] , \data_buf[6][0] , \data_buf[7][7] ,
         \data_buf[7][6] , \data_buf[7][5] , \data_buf[7][4] ,
         \data_buf[7][3] , \data_buf[7][2] , \data_buf[7][1] ,
         \data_buf[7][0] , \cmd_r[0] , cmd_valid_r, \dataout_r[0][8] ,
         \dataout_r[0][7] , \dataout_r[0][6] , \dataout_r[0][5] ,
         \dataout_r[0][4] , \dataout_r[0][3] , \dataout_r[0][2] ,
         \dataout_r[0][1] , \dataout_r[0][0] , \dataout_r[1][8] ,
         \dataout_r[1][7] , \dataout_r[1][6] , \dataout_r[1][5] ,
         \dataout_r[1][4] , \dataout_r[1][3] , \dataout_r[1][2] ,
         \dataout_r[1][1] , \dataout_r[1][0] , \dataout_r[2][8] ,
         \dataout_r[2][7] , \dataout_r[2][6] , \dataout_r[2][5] ,
         \dataout_r[2][4] , \dataout_r[2][3] , \dataout_r[2][2] ,
         \dataout_r[2][1] , \dataout_r[2][0] , \dataout_r[3][8] ,
         \dataout_r[3][7] , \dataout_r[3][6] , \dataout_r[3][5] ,
         \dataout_r[3][4] , \dataout_r[3][3] , \dataout_r[3][2] ,
         \dataout_r[3][1] , \dataout_r[3][0] , N19, N20, N21, N22, N23, N24,
         N25, N26, busy_r, output_valid_w, N48, N49, N51, N53, N54, N55, N56,
         N57, N58, N63, N64, N65, N66, N67, N68, N69, N70, N71, N72, N73, N74,
         N114, n3, n5, n6, n9, n14, n15, n16, n17, n18, n19, n20, n21, n22,
         n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36,
         n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50,
         n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64,
         n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78,
         n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92,
         n93, n94, n95, n96, n97, n186, n188, n189, n190, n191, n192, n193,
         n194, n195, n196, n197, n198, n199, n200, n201, n202, n203, n204,
         n205, n206, n207, n208, n209, n210, n211, n212, n213, n214, n215,
         n216, n217, n218, n219, n220, n221, n222, n223, n224, n225, n226,
         n227, n228, n229, n230, n231, n232, n233, n234, n235, n236, n237,
         n238, n239, n240, n241, n242, n243, n244, n245, n246, n257, n258,
         n259, n260, n261, n262, n263, n264, n265, n266, n267, n268, n269,
         n270, n271, n272, n273, n274, n275, n276, n277, n278, n279, n280,
         n281, n282, n283, n284, n285, n286, n287, n288, n289, n290, n291,
         n292, n293, n294;
  wire   [3:0] idx_r;
  wire   [2:0] state;
  wire   [3:0] idx_w;
  wire   [2:0] nxt_state;
  wire   [7:0] datain_r;

  ALU_0 A1 ( .out({\dataout_w[0][8] , \dataout_w[0][7] , \dataout_w[0][6] , 
        \dataout_w[0][5] , \dataout_w[0][4] , \dataout_w[0][3] , 
        \dataout_w[0][2] , \dataout_w[0][1] , \dataout_w[0][0] }), .mode(1'b1), 
        .in_a({\data_buf[7][7] , \data_buf[7][6] , \data_buf[7][5] , 
        \data_buf[7][4] , \data_buf[7][3] , \data_buf[7][2] , \data_buf[7][1] , 
        \data_buf[7][0] }), .in_b({\data_buf[3][7] , \data_buf[3][6] , 
        \data_buf[3][5] , \data_buf[3][4] , \data_buf[3][3] , \data_buf[3][2] , 
        \data_buf[3][1] , \data_buf[3][0] }) );
  ALU_3 A2 ( .out({\dataout_w[1][8] , \dataout_w[1][7] , \dataout_w[1][6] , 
        \dataout_w[1][5] , \dataout_w[1][4] , \dataout_w[1][3] , 
        \dataout_w[1][2] , \dataout_w[1][1] , \dataout_w[1][0] }), .mode(1'b1), 
        .in_a({\data_buf[6][7] , \data_buf[6][6] , \data_buf[6][5] , 
        \data_buf[6][4] , \data_buf[6][3] , \data_buf[6][2] , \data_buf[6][1] , 
        \data_buf[6][0] }), .in_b({\data_buf[2][7] , \data_buf[2][6] , 
        \data_buf[2][5] , \data_buf[2][4] , \data_buf[2][3] , \data_buf[2][2] , 
        \data_buf[2][1] , \data_buf[2][0] }) );
  ALU_2 A3 ( .out({\dataout_w[2][8] , \dataout_w[2][7] , \dataout_w[2][6] , 
        \dataout_w[2][5] , \dataout_w[2][4] , \dataout_w[2][3] , 
        \dataout_w[2][2] , \dataout_w[2][1] , \dataout_w[2][0] }), .mode(1'b1), 
        .in_a({\data_buf[5][7] , \data_buf[5][6] , \data_buf[5][5] , 
        \data_buf[5][4] , \data_buf[5][3] , \data_buf[5][2] , \data_buf[5][1] , 
        \data_buf[5][0] }), .in_b({\data_buf[1][7] , \data_buf[1][6] , 
        \data_buf[1][5] , \data_buf[1][4] , \data_buf[1][3] , \data_buf[1][2] , 
        \data_buf[1][1] , \data_buf[1][0] }) );
  ALU_1 A4 ( .out({\dataout_w[3][8] , \dataout_w[3][7] , \dataout_w[3][6] , 
        \dataout_w[3][5] , \dataout_w[3][4] , \dataout_w[3][3] , 
        \dataout_w[3][2] , \dataout_w[3][1] , \dataout_w[3][0] }), .mode(1'b1), 
        .in_a({\data_buf[4][7] , \data_buf[4][6] , \data_buf[4][5] , 
        \data_buf[4][4] , \data_buf[4][3] , \data_buf[4][2] , \data_buf[4][1] , 
        \data_buf[4][0] }), .in_b({\data_buf[0][7] , \data_buf[0][6] , 
        \data_buf[0][5] , \data_buf[0][4] , \data_buf[0][3] , \data_buf[0][2] , 
        \data_buf[0][1] , \data_buf[0][0] }) );
  DFFRX1 \datain_r_reg[7]  ( .D(datain[7]), .CK(clk), .RN(n265), .Q(
        datain_r[7]) );
  DFFRX1 \datain_r_reg[6]  ( .D(datain[6]), .CK(clk), .RN(n265), .Q(
        datain_r[6]) );
  DFFRX1 \datain_r_reg[5]  ( .D(datain[5]), .CK(clk), .RN(n264), .Q(
        datain_r[5]) );
  DFFRX1 \datain_r_reg[4]  ( .D(datain[4]), .CK(clk), .RN(n263), .Q(
        datain_r[4]) );
  DFFRX1 \datain_r_reg[3]  ( .D(datain[3]), .CK(clk), .RN(n262), .Q(
        datain_r[3]) );
  DFFRX1 \datain_r_reg[2]  ( .D(datain[2]), .CK(clk), .RN(n262), .Q(
        datain_r[2]) );
  DFFRX1 \datain_r_reg[1]  ( .D(datain[1]), .CK(clk), .RN(n261), .Q(
        datain_r[1]) );
  DFFRX1 \datain_r_reg[0]  ( .D(datain[0]), .CK(clk), .RN(n260), .Q(
        datain_r[0]) );
  DFFRX1 \data_buf_reg[7][6]  ( .D(n83), .CK(clk), .RN(n264), .Q(
        \data_buf[7][6] ) );
  DFFRX1 \data_buf_reg[7][7]  ( .D(n82), .CK(clk), .RN(n265), .Q(
        \data_buf[7][7] ) );
  DFFRX1 \data_buf_reg[0][6]  ( .D(n27), .CK(clk), .RN(n265), .Q(
        \data_buf[0][6] ) );
  DFFRX1 \data_buf_reg[1][6]  ( .D(n35), .CK(clk), .RN(n265), .Q(
        \data_buf[1][6] ) );
  DFFRX1 \data_buf_reg[2][6]  ( .D(n43), .CK(clk), .RN(n264), .Q(
        \data_buf[2][6] ) );
  DFFRX1 \data_buf_reg[3][6]  ( .D(n51), .CK(clk), .RN(n264), .Q(
        \data_buf[3][6] ) );
  DFFRX1 \data_buf_reg[5][7]  ( .D(n66), .CK(clk), .RN(n265), .Q(
        \data_buf[5][7] ) );
  DFFRX1 \data_buf_reg[6][7]  ( .D(n74), .CK(clk), .RN(n265), .Q(
        \data_buf[6][7] ) );
  DFFRX1 \data_buf_reg[4][7]  ( .D(n58), .CK(clk), .RN(n265), .Q(
        \data_buf[4][7] ) );
  DFFRX1 \cmd_r_reg[1]  ( .D(cmd[1]), .CK(clk), .RN(n266), .QN(n292) );
  DFFRX1 \data_buf_reg[7][5]  ( .D(n84), .CK(clk), .RN(n263), .Q(
        \data_buf[7][5] ) );
  DFFRX1 \data_buf_reg[7][4]  ( .D(n85), .CK(clk), .RN(n263), .Q(
        \data_buf[7][4] ) );
  DFFRX1 \data_buf_reg[7][3]  ( .D(n86), .CK(clk), .RN(n262), .Q(
        \data_buf[7][3] ) );
  DFFRX1 \data_buf_reg[7][2]  ( .D(n87), .CK(clk), .RN(n261), .Q(
        \data_buf[7][2] ) );
  DFFRX1 \data_buf_reg[7][1]  ( .D(n88), .CK(clk), .RN(n260), .Q(
        \data_buf[7][1] ) );
  DFFRX1 \cmd_r_reg[0]  ( .D(cmd[0]), .CK(clk), .RN(n266), .Q(\cmd_r[0] ) );
  DFFRX1 \data_buf_reg[5][6]  ( .D(n67), .CK(clk), .RN(n264), .Q(
        \data_buf[5][6] ) );
  DFFRX1 \data_buf_reg[6][6]  ( .D(n75), .CK(clk), .RN(n264), .Q(
        \data_buf[6][6] ) );
  DFFRX1 \data_buf_reg[5][5]  ( .D(n68), .CK(clk), .RN(n263), .Q(
        \data_buf[5][5] ) );
  DFFRX1 \data_buf_reg[6][5]  ( .D(n76), .CK(clk), .RN(n263), .Q(
        \data_buf[6][5] ) );
  DFFRX1 \data_buf_reg[5][4]  ( .D(n69), .CK(clk), .RN(n263), .Q(
        \data_buf[5][4] ) );
  DFFRX1 \data_buf_reg[6][4]  ( .D(n77), .CK(clk), .RN(n263), .Q(
        \data_buf[6][4] ) );
  DFFRX1 \data_buf_reg[5][3]  ( .D(n70), .CK(clk), .RN(n262), .Q(
        \data_buf[5][3] ) );
  DFFRX1 \data_buf_reg[6][3]  ( .D(n78), .CK(clk), .RN(n262), .Q(
        \data_buf[6][3] ) );
  DFFRX1 \data_buf_reg[5][2]  ( .D(n71), .CK(clk), .RN(n261), .Q(
        \data_buf[5][2] ) );
  DFFRX1 \data_buf_reg[6][2]  ( .D(n79), .CK(clk), .RN(n261), .Q(
        \data_buf[6][2] ) );
  DFFRX1 \data_buf_reg[5][1]  ( .D(n72), .CK(clk), .RN(n260), .Q(
        \data_buf[5][1] ) );
  DFFRX1 \data_buf_reg[6][1]  ( .D(n80), .CK(clk), .RN(n260), .Q(
        \data_buf[6][1] ) );
  DFFRX1 \data_buf_reg[4][6]  ( .D(n59), .CK(clk), .RN(n264), .Q(
        \data_buf[4][6] ) );
  DFFRX1 \data_buf_reg[4][5]  ( .D(n60), .CK(clk), .RN(n264), .Q(
        \data_buf[4][5] ) );
  DFFRX1 \data_buf_reg[4][4]  ( .D(n61), .CK(clk), .RN(n263), .Q(
        \data_buf[4][4] ) );
  DFFRX1 \data_buf_reg[4][3]  ( .D(n62), .CK(clk), .RN(n262), .Q(
        \data_buf[4][3] ) );
  DFFRX1 \data_buf_reg[4][2]  ( .D(n63), .CK(clk), .RN(n261), .Q(
        \data_buf[4][2] ) );
  DFFRX1 \data_buf_reg[4][1]  ( .D(n64), .CK(clk), .RN(n261), .Q(
        \data_buf[4][1] ) );
  DFFRX1 \data_buf_reg[7][0]  ( .D(n89), .CK(clk), .RN(n257), .Q(
        \data_buf[7][0] ) );
  DFFRX1 \data_buf_reg[0][0]  ( .D(n33), .CK(clk), .RN(n260), .Q(
        \data_buf[0][0] ) );
  DFFRX1 \data_buf_reg[1][0]  ( .D(n41), .CK(clk), .RN(n260), .Q(
        \data_buf[1][0] ) );
  DFFRX1 \data_buf_reg[2][0]  ( .D(n49), .CK(clk), .RN(n260), .Q(
        \data_buf[2][0] ) );
  DFFRX1 \data_buf_reg[3][0]  ( .D(n57), .CK(clk), .RN(n260), .Q(
        \data_buf[3][0] ) );
  DFFRX1 \data_buf_reg[0][5]  ( .D(n28), .CK(clk), .RN(n264), .Q(
        \data_buf[0][5] ) );
  DFFRX1 \data_buf_reg[1][5]  ( .D(n36), .CK(clk), .RN(n264), .Q(
        \data_buf[1][5] ) );
  DFFRX1 \data_buf_reg[2][5]  ( .D(n44), .CK(clk), .RN(n264), .Q(
        \data_buf[2][5] ) );
  DFFRX1 \data_buf_reg[3][5]  ( .D(n52), .CK(clk), .RN(n264), .Q(
        \data_buf[3][5] ) );
  DFFRX1 \data_buf_reg[0][4]  ( .D(n29), .CK(clk), .RN(n263), .Q(
        \data_buf[0][4] ) );
  DFFRX1 \data_buf_reg[1][4]  ( .D(n37), .CK(clk), .RN(n263), .Q(
        \data_buf[1][4] ) );
  DFFRX1 \data_buf_reg[2][4]  ( .D(n45), .CK(clk), .RN(n263), .Q(
        \data_buf[2][4] ) );
  DFFRX1 \data_buf_reg[3][4]  ( .D(n53), .CK(clk), .RN(n263), .Q(
        \data_buf[3][4] ) );
  DFFRX1 \data_buf_reg[0][3]  ( .D(n30), .CK(clk), .RN(n262), .Q(
        \data_buf[0][3] ) );
  DFFRX1 \data_buf_reg[1][3]  ( .D(n38), .CK(clk), .RN(n262), .Q(
        \data_buf[1][3] ) );
  DFFRX1 \data_buf_reg[2][3]  ( .D(n46), .CK(clk), .RN(n262), .Q(
        \data_buf[2][3] ) );
  DFFRX1 \data_buf_reg[3][3]  ( .D(n54), .CK(clk), .RN(n262), .Q(
        \data_buf[3][3] ) );
  DFFRX1 \data_buf_reg[0][2]  ( .D(n31), .CK(clk), .RN(n262), .Q(
        \data_buf[0][2] ) );
  DFFRX1 \data_buf_reg[1][2]  ( .D(n39), .CK(clk), .RN(n262), .Q(
        \data_buf[1][2] ) );
  DFFRX1 \data_buf_reg[2][2]  ( .D(n47), .CK(clk), .RN(n261), .Q(
        \data_buf[2][2] ) );
  DFFRX1 \data_buf_reg[3][2]  ( .D(n55), .CK(clk), .RN(n261), .Q(
        \data_buf[3][2] ) );
  DFFRX1 \data_buf_reg[0][1]  ( .D(n32), .CK(clk), .RN(n261), .Q(
        \data_buf[0][1] ) );
  DFFRX1 \data_buf_reg[1][1]  ( .D(n40), .CK(clk), .RN(n261), .Q(
        \data_buf[1][1] ) );
  DFFRX1 \data_buf_reg[2][1]  ( .D(n48), .CK(clk), .RN(n261), .Q(
        \data_buf[2][1] ) );
  DFFRX1 \data_buf_reg[3][1]  ( .D(n56), .CK(clk), .RN(n261), .Q(
        \data_buf[3][1] ) );
  DFFRX1 \data_buf_reg[5][0]  ( .D(n73), .CK(clk), .RN(n259), .Q(
        \data_buf[5][0] ) );
  DFFRX1 \data_buf_reg[6][0]  ( .D(n81), .CK(clk), .RN(n258), .Q(
        \data_buf[6][0] ) );
  DFFRX1 \data_buf_reg[4][0]  ( .D(n65), .CK(clk), .RN(n260), .Q(
        \data_buf[4][0] ) );
  DFFRX1 busy_r_reg ( .D(busy), .CK(clk), .RN(n266), .Q(busy_r) );
  DFFRX1 cmd_valid_r_reg ( .D(cmd_valid), .CK(clk), .RN(n266), .Q(cmd_valid_r), 
        .QN(n14) );
  DFFRX1 \dataout_r_reg[3][0]  ( .D(\dataout_w[3][0] ), .CK(clk), .RN(n260), 
        .Q(\dataout_r[3][0] ) );
  DFFRX1 \dataout_r_reg[3][1]  ( .D(\dataout_w[3][1] ), .CK(clk), .RN(n260), 
        .Q(\dataout_r[3][1] ) );
  DFFRX1 \dataout_r_reg[3][2]  ( .D(\dataout_w[3][2] ), .CK(clk), .RN(n260), 
        .Q(\dataout_r[3][2] ) );
  DFFRX1 \dataout_r_reg[3][3]  ( .D(\dataout_w[3][3] ), .CK(clk), .RN(n259), 
        .Q(\dataout_r[3][3] ) );
  DFFRX1 \dataout_r_reg[3][4]  ( .D(\dataout_w[3][4] ), .CK(clk), .RN(n259), 
        .Q(\dataout_r[3][4] ) );
  DFFRX1 \dataout_r_reg[3][5]  ( .D(\dataout_w[3][5] ), .CK(clk), .RN(n259), 
        .Q(\dataout_r[3][5] ) );
  DFFRX1 \dataout_r_reg[3][6]  ( .D(\dataout_w[3][6] ), .CK(clk), .RN(n259), 
        .Q(\dataout_r[3][6] ) );
  DFFRX1 \dataout_r_reg[3][7]  ( .D(\dataout_w[3][7] ), .CK(clk), .RN(n259), 
        .Q(\dataout_r[3][7] ) );
  DFFRX1 \dataout_r_reg[3][8]  ( .D(\dataout_w[3][8] ), .CK(clk), .RN(n259), 
        .Q(\dataout_r[3][8] ) );
  DFFRX1 \dataout_r_reg[1][0]  ( .D(\dataout_w[1][0] ), .CK(clk), .RN(n258), 
        .Q(\dataout_r[1][0] ) );
  DFFRX1 \dataout_r_reg[1][1]  ( .D(\dataout_w[1][1] ), .CK(clk), .RN(n258), 
        .Q(\dataout_r[1][1] ) );
  DFFRX1 \dataout_r_reg[1][2]  ( .D(\dataout_w[1][2] ), .CK(clk), .RN(n258), 
        .Q(\dataout_r[1][2] ) );
  DFFRX1 \dataout_r_reg[1][3]  ( .D(\dataout_w[1][3] ), .CK(clk), .RN(n258), 
        .Q(\dataout_r[1][3] ) );
  DFFRX1 \dataout_r_reg[1][4]  ( .D(\dataout_w[1][4] ), .CK(clk), .RN(n258), 
        .Q(\dataout_r[1][4] ) );
  DFFRX1 \dataout_r_reg[1][5]  ( .D(\dataout_w[1][5] ), .CK(clk), .RN(n258), 
        .Q(\dataout_r[1][5] ) );
  DFFRX1 \dataout_r_reg[1][6]  ( .D(\dataout_w[1][6] ), .CK(clk), .RN(n258), 
        .Q(\dataout_r[1][6] ) );
  DFFRX1 \dataout_r_reg[1][7]  ( .D(\dataout_w[1][7] ), .CK(clk), .RN(n257), 
        .Q(\dataout_r[1][7] ) );
  DFFRX1 \dataout_r_reg[1][8]  ( .D(\dataout_w[1][8] ), .CK(clk), .RN(n257), 
        .Q(\dataout_r[1][8] ) );
  DFFRX1 \dataout_r_reg[2][0]  ( .D(\dataout_w[2][0] ), .CK(clk), .RN(n259), 
        .Q(\dataout_r[2][0] ) );
  DFFRX1 \dataout_r_reg[2][1]  ( .D(\dataout_w[2][1] ), .CK(clk), .RN(n259), 
        .Q(\dataout_r[2][1] ) );
  DFFRX1 \dataout_r_reg[2][2]  ( .D(\dataout_w[2][2] ), .CK(clk), .RN(n259), 
        .Q(\dataout_r[2][2] ) );
  DFFRX1 \dataout_r_reg[2][3]  ( .D(\dataout_w[2][3] ), .CK(clk), .RN(n259), 
        .Q(\dataout_r[2][3] ) );
  DFFRX1 \dataout_r_reg[2][4]  ( .D(\dataout_w[2][4] ), .CK(clk), .RN(n259), 
        .Q(\dataout_r[2][4] ) );
  DFFRX1 \dataout_r_reg[2][5]  ( .D(\dataout_w[2][5] ), .CK(clk), .RN(n258), 
        .Q(\dataout_r[2][5] ) );
  DFFRX1 \dataout_r_reg[2][6]  ( .D(\dataout_w[2][6] ), .CK(clk), .RN(n258), 
        .Q(\dataout_r[2][6] ) );
  DFFRX1 \dataout_r_reg[2][7]  ( .D(\dataout_w[2][7] ), .CK(clk), .RN(n258), 
        .Q(\dataout_r[2][7] ) );
  DFFRX1 \dataout_r_reg[2][8]  ( .D(\dataout_w[2][8] ), .CK(clk), .RN(n258), 
        .Q(\dataout_r[2][8] ) );
  DFFRX1 \dataout_r_reg[0][0]  ( .D(\dataout_w[0][0] ), .CK(clk), .RN(n257), 
        .Q(\dataout_r[0][0] ) );
  DFFRX1 \dataout_r_reg[0][1]  ( .D(\dataout_w[0][1] ), .CK(clk), .RN(n257), 
        .Q(\dataout_r[0][1] ) );
  DFFRX1 \dataout_r_reg[0][2]  ( .D(\dataout_w[0][2] ), .CK(clk), .RN(n257), 
        .Q(\dataout_r[0][2] ) );
  DFFRX1 \dataout_r_reg[0][3]  ( .D(\dataout_w[0][3] ), .CK(clk), .RN(n257), 
        .Q(\dataout_r[0][3] ) );
  DFFRX1 \dataout_r_reg[0][4]  ( .D(\dataout_w[0][4] ), .CK(clk), .RN(n257), 
        .Q(\dataout_r[0][4] ) );
  DFFRX1 \dataout_r_reg[0][5]  ( .D(\dataout_w[0][5] ), .CK(clk), .RN(n257), 
        .Q(\dataout_r[0][5] ) );
  DFFRX1 \dataout_r_reg[0][6]  ( .D(\dataout_w[0][6] ), .CK(clk), .RN(n257), 
        .Q(\dataout_r[0][6] ) );
  DFFRX1 \dataout_r_reg[0][7]  ( .D(\dataout_w[0][7] ), .CK(clk), .RN(n257), 
        .Q(\dataout_r[0][7] ) );
  DFFRX1 \dataout_r_reg[0][8]  ( .D(\dataout_w[0][8] ), .CK(clk), .RN(n257), 
        .Q(\dataout_r[0][8] ) );
  DFFRX1 \data_buf_reg[0][7]  ( .D(n26), .CK(clk), .RN(n265), .Q(
        \data_buf[0][7] ) );
  DFFRX1 \data_buf_reg[1][7]  ( .D(n34), .CK(clk), .RN(n265), .Q(
        \data_buf[1][7] ) );
  DFFRX1 \data_buf_reg[2][7]  ( .D(n42), .CK(clk), .RN(n265), .Q(
        \data_buf[2][7] ) );
  DFFRX1 \data_buf_reg[3][7]  ( .D(n50), .CK(clk), .RN(n265), .Q(
        \data_buf[3][7] ) );
  DFFRX1 \idx_r_reg[2]  ( .D(n90), .CK(clk), .RN(n266), .Q(idx_r[2]), .QN(n6)
         );
  DFFRX1 \idx_r_reg[3]  ( .D(n97), .CK(clk), .RN(n266), .Q(idx_r[3]), .QN(n5)
         );
  DFFRX1 \idx_r_reg[1]  ( .D(n91), .CK(clk), .RN(n266), .Q(N18), .QN(n290) );
  DFFRX1 \idx_r_reg[0]  ( .D(n92), .CK(clk), .RN(n266), .Q(N17), .QN(N67) );
  DFFRX1 \state_reg[2]  ( .D(n94), .CK(clk), .RN(n266), .Q(state[2]), .QN(n9)
         );
  DFFRX1 output_valid_r_reg ( .D(n93), .CK(clk), .RN(n266), .QN(n3) );
  DFFRX4 \state_reg[0]  ( .D(n96), .CK(clk), .RN(n266), .Q(state[0]), .QN(n241) );
  DFFRX2 \state_reg[1]  ( .D(n95), .CK(clk), .RN(n266), .Q(state[1]), .QN(n239) );
  AND2X2 U202 ( .A(n189), .B(n188), .Y(n186) );
  NOR2X2 U203 ( .A(n241), .B(n245), .Y(n225) );
  NOR3XL U204 ( .A(state[1]), .B(state[2]), .C(n241), .Y(n15) );
  INVX12 U205 ( .A(n3), .Y(output_valid) );
  NOR2X2 U206 ( .A(n246), .B(n231), .Y(n234) );
  AOI22XL U207 ( .A0(N67), .A1(n235), .B0(N67), .B1(n225), .Y(n211) );
  AOI22XL U208 ( .A0(N68), .A1(n235), .B0(N53), .B1(n225), .Y(n213) );
  NOR3X1 U209 ( .A(idx_r[2]), .B(idx_r[3]), .C(n23), .Y(n22) );
  NOR2X1 U210 ( .A(n20), .B(idx_r[3]), .Y(n19) );
  NAND3X1 U211 ( .A(n241), .B(n9), .C(n14), .Y(n16) );
  CLKINVX1 U212 ( .A(reset), .Y(n291) );
  INVX3 U213 ( .A(n275), .Y(n271) );
  INVX3 U214 ( .A(n274), .Y(n272) );
  INVX3 U215 ( .A(n275), .Y(n269) );
  INVX3 U216 ( .A(n275), .Y(n268) );
  INVX3 U217 ( .A(n275), .Y(n270) );
  CLKINVX1 U218 ( .A(n275), .Y(n273) );
  CLKBUFX3 U219 ( .A(n289), .Y(n274) );
  CLKBUFX3 U220 ( .A(n289), .Y(n275) );
  CLKBUFX3 U221 ( .A(n288), .Y(n276) );
  CLKBUFX3 U222 ( .A(n288), .Y(n277) );
  CLKBUFX3 U223 ( .A(n287), .Y(n278) );
  CLKBUFX3 U224 ( .A(n287), .Y(n279) );
  CLKBUFX3 U225 ( .A(n286), .Y(n283) );
  CLKBUFX3 U226 ( .A(n287), .Y(n280) );
  CLKBUFX3 U227 ( .A(n287), .Y(n281) );
  CLKBUFX3 U228 ( .A(n286), .Y(n282) );
  CLKBUFX3 U229 ( .A(n286), .Y(n284) );
  CLKBUFX3 U230 ( .A(n286), .Y(n285) );
  INVX3 U231 ( .A(n221), .Y(n243) );
  INVXL U232 ( .A(n234), .Y(n244) );
  CLKINVX1 U233 ( .A(N53), .Y(N68) );
  CLKBUFX3 U234 ( .A(n267), .Y(n288) );
  CLKBUFX3 U235 ( .A(n267), .Y(n289) );
  CLKBUFX3 U236 ( .A(n288), .Y(n287) );
  CLKBUFX3 U237 ( .A(n288), .Y(n286) );
  CLKBUFX3 U238 ( .A(n263), .Y(n257) );
  CLKBUFX3 U239 ( .A(n264), .Y(n258) );
  CLKBUFX3 U240 ( .A(n291), .Y(n259) );
  CLKBUFX3 U241 ( .A(n291), .Y(n260) );
  CLKBUFX3 U242 ( .A(n262), .Y(n261) );
  CLKBUFX3 U243 ( .A(n291), .Y(n262) );
  CLKBUFX3 U244 ( .A(n291), .Y(n263) );
  CLKBUFX3 U245 ( .A(n291), .Y(n264) );
  CLKBUFX3 U246 ( .A(n260), .Y(n265) );
  CLKBUFX3 U247 ( .A(n291), .Y(n266) );
  CLKINVX1 U248 ( .A(n246), .Y(n245) );
  XOR2X1 U249 ( .A(n239), .B(n246), .Y(n218) );
  CLKINVX1 U250 ( .A(n231), .Y(n240) );
  NOR2BX1 U251 ( .AN(nxt_state[2]), .B(n293), .Y(n94) );
  NOR2BX1 U252 ( .AN(n23), .B(n21), .Y(N53) );
  CLKINVX1 U253 ( .A(n24), .Y(n294) );
  CLKINVX1 U254 ( .A(N114), .Y(N48) );
  CLKBUFX3 U255 ( .A(n15), .Y(n267) );
  CLKINVX1 U256 ( .A(n16), .Y(n293) );
  AND2X2 U257 ( .A(n241), .B(n246), .Y(n238) );
  CLKBUFX3 U258 ( .A(n9), .Y(n246) );
  CLKINVX1 U259 ( .A(n238), .Y(n242) );
  AND2X2 U260 ( .A(N18), .B(N67), .Y(n205) );
  AND2X2 U261 ( .A(N17), .B(n290), .Y(n206) );
  AND2X2 U262 ( .A(N67), .B(n290), .Y(n207) );
  NOR2X2 U263 ( .A(n290), .B(N67), .Y(n204) );
  NOR2X1 U264 ( .A(n19), .B(n3), .Y(N74) );
  AO22X1 U265 ( .A0(N17), .A1(n293), .B0(idx_w[0]), .B1(n16), .Y(n92) );
  AO22X1 U266 ( .A0(n293), .A1(N18), .B0(idx_w[1]), .B1(n16), .Y(n91) );
  AO22X1 U267 ( .A0(n293), .A1(idx_r[3]), .B0(idx_w[3]), .B1(n16), .Y(n97) );
  AO21X1 U268 ( .A0(n20), .A1(idx_r[3]), .B0(n19), .Y(N70) );
  OAI2BB2XL U269 ( .B0(n16), .B1(n6), .A0N(idx_w[2]), .A1N(n16), .Y(n90) );
  OAI21XL U270 ( .A0(n21), .A1(n6), .B0(n20), .Y(N69) );
  OAI2BB2XL U271 ( .B0(n17), .B1(n3), .A0N(output_valid_w), .A1N(n17), .Y(n93)
         );
  AND2X2 U272 ( .A(n18), .B(n272), .Y(n17) );
  NAND4X1 U273 ( .A(state[1]), .B(n14), .C(n241), .D(n9), .Y(n18) );
  NOR2X1 U274 ( .A(n294), .B(n9), .Y(N58) );
  NOR2X1 U275 ( .A(n22), .B(n9), .Y(N65) );
  NOR2X1 U276 ( .A(n294), .B(n241), .Y(N56) );
  NOR2X1 U277 ( .A(n22), .B(n241), .Y(N63) );
  NOR2BX1 U278 ( .AN(nxt_state[0]), .B(n293), .Y(n96) );
  NAND2X1 U279 ( .A(n239), .B(n24), .Y(N57) );
  NAND2X1 U280 ( .A(N18), .B(N17), .Y(n23) );
  NOR2X1 U281 ( .A(N18), .B(N17), .Y(n21) );
  NAND2X1 U282 ( .A(\cmd_r[0] ), .B(n292), .Y(N114) );
  NAND2X1 U283 ( .A(n25), .B(n5), .Y(n24) );
  NAND2X1 U284 ( .A(n21), .B(n6), .Y(n20) );
  XNOR2X1 U285 ( .A(idx_r[2]), .B(n23), .Y(N54) );
  NOR2X1 U286 ( .A(n23), .B(n6), .Y(n25) );
  NOR2X1 U287 ( .A(n292), .B(\cmd_r[0] ), .Y(N49) );
  OAI21XL U288 ( .A0(n25), .A1(n5), .B0(n24), .Y(N55) );
  NOR2X1 U289 ( .A(n19), .B(n9), .Y(N73) );
  NOR2X1 U290 ( .A(n22), .B(n239), .Y(N64) );
  OA21XL U291 ( .A0(N49), .A1(N48), .B0(cmd_valid_r), .Y(N51) );
  NOR2X1 U292 ( .A(n22), .B(n3), .Y(N66) );
  NOR2X1 U293 ( .A(n19), .B(n241), .Y(N71) );
  NOR2X1 U294 ( .A(n19), .B(n239), .Y(N72) );
  AO22X1 U295 ( .A0(n293), .A1(state[1]), .B0(nxt_state[1]), .B1(n16), .Y(n95)
         );
  AO22X1 U296 ( .A0(n270), .A1(\data_buf[4][7] ), .B0(n280), .B1(
        \data_buf[3][7] ), .Y(n58) );
  AO22X1 U297 ( .A0(n269), .A1(\data_buf[3][7] ), .B0(n281), .B1(
        \data_buf[2][7] ), .Y(n50) );
  AO22X1 U298 ( .A0(n269), .A1(\data_buf[2][7] ), .B0(n282), .B1(
        \data_buf[1][7] ), .Y(n42) );
  AO22X1 U299 ( .A0(n268), .A1(\data_buf[1][7] ), .B0(n284), .B1(
        \data_buf[0][7] ), .Y(n34) );
  AO22X1 U300 ( .A0(n270), .A1(\data_buf[0][7] ), .B0(datain_r[7]), .B1(n285), 
        .Y(n26) );
  AO22X1 U301 ( .A0(n277), .A1(\data_buf[5][7] ), .B0(n271), .B1(
        \data_buf[6][7] ), .Y(n74) );
  AO22X1 U302 ( .A0(n278), .A1(\data_buf[4][7] ), .B0(n271), .B1(
        \data_buf[5][7] ), .Y(n66) );
  AO22X1 U303 ( .A0(n276), .A1(\data_buf[5][0] ), .B0(n272), .B1(
        \data_buf[6][0] ), .Y(n81) );
  AO22X1 U304 ( .A0(n277), .A1(\data_buf[4][0] ), .B0(n271), .B1(
        \data_buf[5][0] ), .Y(n73) );
  AO22X1 U305 ( .A0(n271), .A1(\data_buf[4][1] ), .B0(n279), .B1(
        \data_buf[3][1] ), .Y(n64) );
  AO22X1 U306 ( .A0(n270), .A1(\data_buf[3][1] ), .B0(n280), .B1(
        \data_buf[2][1] ), .Y(n56) );
  AO22X1 U307 ( .A0(n269), .A1(\data_buf[2][1] ), .B0(n281), .B1(
        \data_buf[1][1] ), .Y(n48) );
  AO22X1 U308 ( .A0(n269), .A1(\data_buf[1][1] ), .B0(n283), .B1(
        \data_buf[0][1] ), .Y(n40) );
  AO22X1 U309 ( .A0(n271), .A1(\data_buf[4][2] ), .B0(n279), .B1(
        \data_buf[3][2] ), .Y(n63) );
  AO22X1 U310 ( .A0(n270), .A1(\data_buf[3][2] ), .B0(n280), .B1(
        \data_buf[2][2] ), .Y(n55) );
  AO22X1 U311 ( .A0(n269), .A1(\data_buf[2][2] ), .B0(n282), .B1(
        \data_buf[1][2] ), .Y(n47) );
  AO22X1 U312 ( .A0(n269), .A1(\data_buf[1][2] ), .B0(n283), .B1(
        \data_buf[0][2] ), .Y(n39) );
  AO22X1 U313 ( .A0(n271), .A1(\data_buf[4][3] ), .B0(n279), .B1(
        \data_buf[3][3] ), .Y(n62) );
  AO22X1 U314 ( .A0(n270), .A1(\data_buf[3][3] ), .B0(n280), .B1(
        \data_buf[2][3] ), .Y(n54) );
  AO22X1 U315 ( .A0(n269), .A1(\data_buf[2][3] ), .B0(n282), .B1(
        \data_buf[1][3] ), .Y(n46) );
  AO22X1 U316 ( .A0(n268), .A1(\data_buf[1][3] ), .B0(n283), .B1(
        \data_buf[0][3] ), .Y(n38) );
  AO22X1 U317 ( .A0(n270), .A1(\data_buf[4][4] ), .B0(n279), .B1(
        \data_buf[3][4] ), .Y(n61) );
  AO22X1 U318 ( .A0(n270), .A1(\data_buf[3][4] ), .B0(n281), .B1(
        \data_buf[2][4] ), .Y(n53) );
  AO22X1 U319 ( .A0(n269), .A1(\data_buf[2][4] ), .B0(n282), .B1(
        \data_buf[1][4] ), .Y(n45) );
  AO22X1 U320 ( .A0(n268), .A1(\data_buf[1][4] ), .B0(n283), .B1(
        \data_buf[0][4] ), .Y(n37) );
  AO22X1 U321 ( .A0(n270), .A1(\data_buf[4][5] ), .B0(n279), .B1(
        \data_buf[3][5] ), .Y(n60) );
  AO22X1 U322 ( .A0(n270), .A1(\data_buf[3][5] ), .B0(n281), .B1(
        \data_buf[2][5] ), .Y(n52) );
  AO22X1 U323 ( .A0(n269), .A1(\data_buf[2][5] ), .B0(n282), .B1(
        \data_buf[1][5] ), .Y(n44) );
  AO22X1 U324 ( .A0(n268), .A1(\data_buf[1][5] ), .B0(n283), .B1(
        \data_buf[0][5] ), .Y(n36) );
  AO22X1 U325 ( .A0(n270), .A1(\data_buf[4][6] ), .B0(n280), .B1(
        \data_buf[3][6] ), .Y(n59) );
  AO22X1 U326 ( .A0(n270), .A1(\data_buf[3][6] ), .B0(n281), .B1(
        \data_buf[2][6] ), .Y(n51) );
  AO22X1 U327 ( .A0(n269), .A1(\data_buf[2][6] ), .B0(n282), .B1(
        \data_buf[1][6] ), .Y(n43) );
  AO22X1 U328 ( .A0(n268), .A1(\data_buf[1][6] ), .B0(n284), .B1(
        \data_buf[0][6] ), .Y(n35) );
  AO22X1 U329 ( .A0(n271), .A1(\data_buf[4][0] ), .B0(n279), .B1(
        \data_buf[3][0] ), .Y(n65) );
  AO22X1 U330 ( .A0(n270), .A1(\data_buf[3][0] ), .B0(n280), .B1(
        \data_buf[2][0] ), .Y(n57) );
  AO22X1 U331 ( .A0(n269), .A1(\data_buf[2][0] ), .B0(n281), .B1(
        \data_buf[1][0] ), .Y(n49) );
  AO22X1 U332 ( .A0(n269), .A1(\data_buf[1][0] ), .B0(n283), .B1(
        \data_buf[0][0] ), .Y(n41) );
  AO22X1 U333 ( .A0(n276), .A1(\data_buf[5][1] ), .B0(n272), .B1(
        \data_buf[6][1] ), .Y(n80) );
  AO22X1 U334 ( .A0(n277), .A1(\data_buf[4][1] ), .B0(n271), .B1(
        \data_buf[5][1] ), .Y(n72) );
  AO22X1 U335 ( .A0(n276), .A1(\data_buf[5][2] ), .B0(n272), .B1(
        \data_buf[6][2] ), .Y(n79) );
  AO22X1 U336 ( .A0(n278), .A1(\data_buf[4][2] ), .B0(n271), .B1(
        \data_buf[5][2] ), .Y(n71) );
  AO22X1 U337 ( .A0(n276), .A1(\data_buf[5][3] ), .B0(n272), .B1(
        \data_buf[6][3] ), .Y(n78) );
  AO22X1 U338 ( .A0(n278), .A1(\data_buf[4][3] ), .B0(n271), .B1(
        \data_buf[5][3] ), .Y(n70) );
  AO22X1 U339 ( .A0(n277), .A1(\data_buf[5][4] ), .B0(n272), .B1(
        \data_buf[6][4] ), .Y(n77) );
  AO22X1 U340 ( .A0(n278), .A1(\data_buf[4][4] ), .B0(n271), .B1(
        \data_buf[5][4] ), .Y(n69) );
  AO22X1 U341 ( .A0(n277), .A1(\data_buf[5][5] ), .B0(n272), .B1(
        \data_buf[6][5] ), .Y(n76) );
  AO22X1 U342 ( .A0(n278), .A1(\data_buf[4][5] ), .B0(n271), .B1(
        \data_buf[5][5] ), .Y(n68) );
  AO22X1 U343 ( .A0(n277), .A1(\data_buf[5][6] ), .B0(n272), .B1(
        \data_buf[6][6] ), .Y(n75) );
  AO22X1 U344 ( .A0(n278), .A1(\data_buf[4][6] ), .B0(n271), .B1(
        \data_buf[5][6] ), .Y(n67) );
  AO22X1 U345 ( .A0(n276), .A1(\data_buf[6][7] ), .B0(\data_buf[7][7] ), .B1(
        n272), .Y(n82) );
  AO22X1 U346 ( .A0(n277), .A1(\data_buf[6][2] ), .B0(\data_buf[7][2] ), .B1(
        n272), .Y(n87) );
  AO22X1 U347 ( .A0(n275), .A1(\data_buf[6][3] ), .B0(\data_buf[7][3] ), .B1(
        n272), .Y(n86) );
  AO22X1 U348 ( .A0(n277), .A1(\data_buf[6][4] ), .B0(\data_buf[7][4] ), .B1(
        n272), .Y(n85) );
  AO22X1 U349 ( .A0(n276), .A1(\data_buf[6][6] ), .B0(\data_buf[7][6] ), .B1(
        n272), .Y(n83) );
  AO22X1 U350 ( .A0(n268), .A1(\data_buf[0][4] ), .B0(datain_r[4]), .B1(n285), 
        .Y(n29) );
  AO22X1 U351 ( .A0(n268), .A1(\data_buf[0][5] ), .B0(datain_r[5]), .B1(n285), 
        .Y(n28) );
  AO22X1 U352 ( .A0(n268), .A1(\data_buf[0][6] ), .B0(datain_r[6]), .B1(n285), 
        .Y(n27) );
  AO22X1 U353 ( .A0(n276), .A1(\data_buf[6][0] ), .B0(\data_buf[7][0] ), .B1(
        n273), .Y(n89) );
  AO22X1 U354 ( .A0(n274), .A1(\data_buf[6][1] ), .B0(\data_buf[7][1] ), .B1(
        n273), .Y(n88) );
  AO22X1 U355 ( .A0(n276), .A1(\data_buf[6][5] ), .B0(\data_buf[7][5] ), .B1(
        n273), .Y(n84) );
  AO22X1 U356 ( .A0(n268), .A1(\data_buf[0][0] ), .B0(datain_r[0]), .B1(n284), 
        .Y(n33) );
  AO22X1 U357 ( .A0(n268), .A1(\data_buf[0][1] ), .B0(datain_r[1]), .B1(n284), 
        .Y(n32) );
  AO22X1 U358 ( .A0(n268), .A1(\data_buf[0][2] ), .B0(datain_r[2]), .B1(n284), 
        .Y(n31) );
  AO22X1 U359 ( .A0(n268), .A1(\data_buf[0][3] ), .B0(datain_r[3]), .B1(n284), 
        .Y(n30) );
  AOI22X1 U360 ( .A0(\dataout_r[2][0] ), .A1(n205), .B0(\dataout_r[3][0] ), 
        .B1(n204), .Y(n189) );
  AOI22X1 U361 ( .A0(\dataout_r[0][0] ), .A1(n207), .B0(\dataout_r[1][0] ), 
        .B1(n206), .Y(n188) );
  AOI22X1 U362 ( .A0(\dataout_r[2][1] ), .A1(n205), .B0(\dataout_r[3][1] ), 
        .B1(n204), .Y(n191) );
  AOI22X1 U363 ( .A0(\dataout_r[0][1] ), .A1(n207), .B0(\dataout_r[1][1] ), 
        .B1(n206), .Y(n190) );
  NAND2X1 U364 ( .A(n191), .B(n190), .Y(N26) );
  AOI22X1 U365 ( .A0(\dataout_r[2][2] ), .A1(n205), .B0(\dataout_r[3][2] ), 
        .B1(n204), .Y(n193) );
  AOI22X1 U366 ( .A0(\dataout_r[0][2] ), .A1(n207), .B0(\dataout_r[1][2] ), 
        .B1(n206), .Y(n192) );
  NAND2X1 U367 ( .A(n193), .B(n192), .Y(N25) );
  AOI22X1 U368 ( .A0(\dataout_r[2][3] ), .A1(n205), .B0(\dataout_r[3][3] ), 
        .B1(n204), .Y(n195) );
  AOI22X1 U369 ( .A0(\dataout_r[0][3] ), .A1(n207), .B0(\dataout_r[1][3] ), 
        .B1(n206), .Y(n194) );
  NAND2X1 U370 ( .A(n195), .B(n194), .Y(N24) );
  AOI22X1 U371 ( .A0(\dataout_r[2][4] ), .A1(n205), .B0(\dataout_r[3][4] ), 
        .B1(n204), .Y(n197) );
  AOI22X1 U372 ( .A0(\dataout_r[0][4] ), .A1(n207), .B0(\dataout_r[1][4] ), 
        .B1(n206), .Y(n196) );
  NAND2X1 U373 ( .A(n197), .B(n196), .Y(N23) );
  AOI22X1 U374 ( .A0(\dataout_r[2][5] ), .A1(n205), .B0(\dataout_r[3][5] ), 
        .B1(n204), .Y(n199) );
  AOI22X1 U375 ( .A0(\dataout_r[0][5] ), .A1(n207), .B0(\dataout_r[1][5] ), 
        .B1(n206), .Y(n198) );
  NAND2X1 U376 ( .A(n199), .B(n198), .Y(N22) );
  AOI22X1 U377 ( .A0(\dataout_r[2][6] ), .A1(n205), .B0(\dataout_r[3][6] ), 
        .B1(n204), .Y(n201) );
  AOI22X1 U378 ( .A0(\dataout_r[0][6] ), .A1(n207), .B0(\dataout_r[1][6] ), 
        .B1(n206), .Y(n200) );
  NAND2X1 U379 ( .A(n201), .B(n200), .Y(N21) );
  AOI22X1 U380 ( .A0(\dataout_r[2][7] ), .A1(n205), .B0(\dataout_r[3][7] ), 
        .B1(n204), .Y(n203) );
  AOI22X1 U381 ( .A0(\dataout_r[0][7] ), .A1(n207), .B0(\dataout_r[1][7] ), 
        .B1(n206), .Y(n202) );
  NAND2X1 U382 ( .A(n203), .B(n202), .Y(N20) );
  AOI22X1 U383 ( .A0(\dataout_r[2][8] ), .A1(n205), .B0(\dataout_r[3][8] ), 
        .B1(n204), .Y(n209) );
  AOI22X1 U384 ( .A0(\dataout_r[0][8] ), .A1(n207), .B0(\dataout_r[1][8] ), 
        .B1(n206), .Y(n208) );
  NAND2X1 U385 ( .A(n209), .B(n208), .Y(N19) );
  NOR2X1 U386 ( .A(state[1]), .B(state[0]), .Y(n231) );
  NAND2X1 U387 ( .A(N17), .B(n234), .Y(n212) );
  AO22X1 U388 ( .A0(n239), .A1(N49), .B0(N114), .B1(state[1]), .Y(n210) );
  NAND2X1 U389 ( .A(n210), .B(n238), .Y(n214) );
  NOR2X1 U390 ( .A(n246), .B(n240), .Y(n235) );
  NAND3X1 U391 ( .A(n212), .B(n214), .C(n211), .Y(idx_w[0]) );
  NAND2X1 U392 ( .A(N18), .B(n234), .Y(n215) );
  NAND3X1 U393 ( .A(n215), .B(n214), .C(n213), .Y(idx_w[1]) );
  AOI222XL U394 ( .A0(idx_r[2]), .A1(n234), .B0(N69), .B1(n235), .C0(N54), 
        .C1(n225), .Y(n216) );
  CLKINVX1 U395 ( .A(n216), .Y(idx_w[2]) );
  AOI222XL U396 ( .A0(idx_r[3]), .A1(n234), .B0(N70), .B1(n235), .C0(N55), 
        .C1(n225), .Y(n217) );
  CLKINVX1 U397 ( .A(n217), .Y(idx_w[3]) );
  NOR2X1 U398 ( .A(state[0]), .B(n246), .Y(n219) );
  OAI21XL U399 ( .A0(n219), .A1(n225), .B0(n218), .Y(n220) );
  OAI2BB2XL U400 ( .B0(n186), .B1(n220), .A0N(\dataout_r[0][0] ), .A1N(n220), 
        .Y(n303) );
  NOR2X1 U401 ( .A(state[1]), .B(n241), .Y(n230) );
  AO22X1 U402 ( .A0(N48), .A1(n241), .B0(N63), .B1(state[0]), .Y(n222) );
  AOI222XL U403 ( .A0(n292), .A1(n231), .B0(n230), .B1(N56), .C0(n222), .C1(
        state[1]), .Y(n224) );
  AOI21X1 U404 ( .A0(N71), .A1(n239), .B0(state[0]), .Y(n223) );
  OAI22XL U405 ( .A0(state[2]), .A1(n224), .B0(n246), .B1(n223), .Y(
        nxt_state[0]) );
  AOI221XL U406 ( .A0(n241), .A1(N48), .B0(N64), .B1(state[0]), .C0(state[2]), 
        .Y(n228) );
  NAND3X1 U407 ( .A(state[2]), .B(n241), .C(N72), .Y(n227) );
  AOI33X1 U408 ( .A0(n225), .A1(n239), .A2(N57), .B0(n231), .B1(n246), .B2(N48), .Y(n226) );
  OAI211X1 U409 ( .A0(n239), .A1(n228), .B0(n227), .C0(n226), .Y(nxt_state[1])
         );
  AO22X1 U410 ( .A0(n241), .A1(N114), .B0(N65), .B1(state[0]), .Y(n229) );
  AOI222XL U411 ( .A0(N49), .A1(n231), .B0(n230), .B1(N58), .C0(n229), .C1(
        state[1]), .Y(n233) );
  NAND2X1 U412 ( .A(N73), .B(state[2]), .Y(n232) );
  OAI211X1 U413 ( .A0(state[2]), .A1(n233), .B0(n232), .C0(n244), .Y(
        nxt_state[2]) );
  AOI22X1 U414 ( .A0(N74), .A1(n235), .B0(output_valid), .B1(n234), .Y(n237)
         );
  OAI221XL U415 ( .A0(N66), .A1(n241), .B0(N51), .B1(state[1]), .C0(n246), .Y(
        n236) );
  NAND2X1 U416 ( .A(n237), .B(n236), .Y(output_valid_w) );
  AO22X1 U417 ( .A0(cmd_valid_r), .A1(n238), .B0(busy_r), .B1(n242), .Y(n304)
         );
  AOI211X4 U418 ( .A0(n239), .A1(n246), .B0(n238), .C0(n234), .Y(n221) );
  AO22XL U419 ( .A0(\dataout_r[0][8] ), .A1(n243), .B0(N19), .B1(n221), .Y(
        n295) );
  AO22XL U420 ( .A0(\dataout_r[0][7] ), .A1(n243), .B0(N20), .B1(n221), .Y(
        n296) );
  AO22XL U421 ( .A0(\dataout_r[0][6] ), .A1(n243), .B0(N21), .B1(n221), .Y(
        n297) );
  AO22XL U422 ( .A0(\dataout_r[0][5] ), .A1(n243), .B0(N22), .B1(n221), .Y(
        n298) );
  AO22XL U423 ( .A0(\dataout_r[0][4] ), .A1(n243), .B0(N23), .B1(n221), .Y(
        n299) );
  AO22XL U424 ( .A0(\dataout_r[0][3] ), .A1(n243), .B0(N24), .B1(n221), .Y(
        n300) );
  AO22XL U425 ( .A0(\dataout_r[0][2] ), .A1(n243), .B0(N25), .B1(n221), .Y(
        n301) );
  AO22XL U426 ( .A0(\dataout_r[0][1] ), .A1(n243), .B0(N26), .B1(n221), .Y(
        n302) );
  BUFX12 U427 ( .A(n304), .Y(busy) );
  BUFX12 U428 ( .A(n302), .Y(dataout[1]) );
  BUFX12 U429 ( .A(n301), .Y(dataout[2]) );
  BUFX12 U430 ( .A(n300), .Y(dataout[3]) );
  BUFX12 U431 ( .A(n299), .Y(dataout[4]) );
  BUFX12 U432 ( .A(n298), .Y(dataout[5]) );
  BUFX12 U433 ( .A(n297), .Y(dataout[6]) );
  BUFX12 U434 ( .A(n296), .Y(dataout[7]) );
  BUFX12 U435 ( .A(n295), .Y(dataout[8]) );
  BUFX12 U436 ( .A(n303), .Y(dataout[0]) );
endmodule

