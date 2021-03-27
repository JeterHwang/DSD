//continuous assignment tb
`timescale 1ns/10ps
`define CYCLE   10
`define HCYCLE  5

module alu_assign_tb;
    reg  [3:0] ctrl;
    reg  [7:0] x;
    reg  [7:0] y;
    wire       carry;
    wire [7:0] out;
    
    alu_assign alu_assign(
        ctrl     ,
        x        ,
        y        ,
        carry    ,
        out  
    );

   initial begin
       $fsdbDumpfile("alu_assign.fsdb");
       $fsdbDumpvars;
   end

    initial begin
        ctrl = 4'b1101;
        x    = 8'd0;
        y    = 8'd0;
        
        #(`CYCLE);
        // 0100 boolean not
        ctrl = 4'b0100;
        
        #(`HCYCLE);
        if( out == 8'b1111_1111 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );
        
        x = 8'd4;
        y = 8'd14;
        // 0010 Bitwise And
        ctrl = 4'b0010;
        
        #(`HCYCLE);
        if( out == 8'b0000_0100 ) $display( "PASS --- 0010 bitwise and" );
        else $display( "FAIL --- 0010 btiwise and" );

        // 0011 Bitwise Or
        ctrl = 4'b0011;
        
        #(`HCYCLE);
        if( out == 8'b0000_1110 ) $display( "PASS --- 0011 bitwise or" );
        else $display( "FAIL --- 0011 bitwise or" );

        // 0101 Bitwise Xor
        ctrl = 4'b0101;

        #(`HCYCLE);
        if( out == 8'b0000_1010 ) $display( "PASS --- 0101 bitwise Xor" );
        else $display( "FAIL --- 0101 bitwise Xor" );

        // 0110 Bitwise Nor
        ctrl = 4'b0110;

        #(`HCYCLE);
        if( out == 8'b1111_0001 ) $display( "PASS --- 0110 bitwise Nor" );
        else $display( "FAIL --- 0110 bit" );
        
        x = 8'd4;
        y = 8'd2;
        // 0111 Shift left logical variable
        ctrl = 4'b0111;
        
        #(`HCYCLE);
        if( out == 8'b0010_0000 ) $display( "PASS --- 0111 Shift left logical variable" );
        else $display( "FAIL --- 0111 Shift left logical variable" );
        
        // 1000 Shift right logical variable
        ctrl = 4'b1000;
        
        #(`HCYCLE);
        if( out == 8'b0000_0000 ) $display( "PASS --- 1000 shift right logical variable" );
        else $display( "FAIL --- 1000 shift right logical variable" );

        x = 8'b1110_0001;
        y = 8'd2;
        // 1001 Shift right arithmetic
        ctrl = 4'b1001;
        
        #(`HCYCLE);
        if( out == 8'b1111_1000 ) $display( "PASS --- 1001 shift right arithmetic" );
        else $display( "FAIL --- 1001 shift right arithmetic" );

        // 1010 Rotate left
        ctrl = 4'b1010;
        
        #(`HCYCLE);
        if( out == 8'b1100_0011 ) $display( "PASS --- 1010 rotate left" );
        else $display( "FAIL --- 1010 rotate left" );

        // 1011 Rotate Right
        ctrl = 4'b1011;
        
        #(`HCYCLE);
        if( out == 8'b1111_0000 ) $display( "PASS --- 1011 rotate right" );
        else $display( "FAIL --- 1011 rotate right" );

        // 1100 equal
        ctrl = 4'b1100;
        
        #(`HCYCLE);
        if( out == 8'b0000_0000 ) $display( "PASS --- 1100 equal" );
        else $display( "FAIL --- 1100 equal" );
        
        // 1101 NOP
        ctrl = 4'b1101;
        
        #(`HCYCLE);
        if( out == 8'b0000_0000 ) $display( "PASS --- 1101 NOP" );
        else $display( "FAIL --- 1101 NOP" );

        // 1110 NOP
        ctrl = 4'b1110;
        
        #(`HCYCLE);
        if( out == 8'b0000_0000 ) $display( "PASS --- 1101 NOP" );
        else $display( "FAIL --- 1101 NOP" );

        // 1111 NOP
        ctrl = 4'b1111;
        
        #(`HCYCLE);
        if( out == 8'b0000_0000 ) $display( "PASS --- 1101 NOP" );
        else $display( "FAIL --- 1101 NOP" );

        x = 8'd20;
        y = 8'b1111_0110; // -10
        // 0000 Add(signed)
        ctrl = 4'b0000;
        
        #(`HCYCLE);
        if( out == 8'b0000_1010 ) $display( "PASS --- 0000 signed addition (positive)" );
        else $display( "FAIL --- 0000 signed addition (positive)" );

        x = 8'd0;
        #(`HCYCLE);
        if( out == 8'b1111_0110 ) $display( "PASS --- 0000 signed addition (negative)" );
        else $display( "FAIL --- 0000 signed addition" );

        // 0001 Sub(signed)
        ctrl = 4'b0001;
        
        x = 8'd26;
        y = 8'd13;
        #(`HCYCLE);
        if( out == 8'd13 ) $display( "PASS --- 0001 signed substraction (positive)" );
        else $display( "FAIL --- 0001 signed substraction (positive)" );

        x = 8'd0;
        #(`HCYCLE);
        if( out == -8'd13 ) $display( "PASS --- 0001 signed substraction (negative)" );
        else $display( "FAIL --- 0001 signed substraction (negative)" );

        // finish tb
        #(`CYCLE) $finish;
    end

endmodule
