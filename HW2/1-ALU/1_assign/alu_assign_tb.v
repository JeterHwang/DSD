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
        if( out == 8'b0000_0100 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );

        // 0011 Bitwise Or
        ctrl = 4'b0011;
        
        #(`HCYCLE);
        if( out == 8'b0000_1110 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );

        // 0101 Bitwise Xor
        ctrl = 4'b0101;

        #(`HCYCLE);
        if( out == 8'b0000_1010 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );

        // 0110 Bitwise Nor
        ctrl = 4'b0110;

        #(`HCYCLE);
        if( out == 8'b1111_0001 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );

        x = 8'd4;
        y = 8'd2;
        // 0111 Shift left logical variable
        ctrl = 4'b0111;
        
        #(`HCYCLE);
        if( out == 8'b0001_0000 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );
        
        // 1000 Shift right logical variable
        ctrl = 4'b1000;
        
        #(`HCYCLE);
        if( out == 8'b0000_0000 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );

        x = 8'b1110_0001
        y = 8'd2;
        // 1001 Shift right arithmetic
        ctrl = 4'b1001;
        
        #(`HCYCLE);
        if( out == 8'b1111_1000 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );

        // 1010 Rotate left
        ctrl = 4'b1010;
        
        #(`HCYCLE);
        if( out == 8'b1100_0011 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );

        // 1011 Rotate Right
        ctrl = 4'b1011;
        
        #(`HCYCLE);
        if( out == 8'b1111_0000 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );

        // 1100 equal
        ctrl = 4'b1100;
        
        #(`HCYCLE);
        if( out == 8'b0000_0000 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );
        
        // 1101 NOP
        ctrl = 4'b1101;
        
        #(`HCYCLE);
        if( out == 8'b0000_0000 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );

        // 1110 NOP
        ctrl = 4'b1110;
        
        #(`HCYCLE);
        if( out == 8'b0000_0000 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );

        // 1111 NOP
        ctrl = 4'b1111;
        
        #(`HCYCLE);
        if( out == 8'b0000_0000 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );

        x = 8'd1111
        // 0000 Add(signed)
        ctrl = 4'b1111;
        
        #(`HCYCLE);
        if( out == 8'b0000_0000 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );

        // 0001 Sub(signed)
        ctrl = 4'b1111;
        
        #(`HCYCLE);
        if( out == 8'b0000_0000 ) $display( "PASS --- 0100 boolean not" );
        else $display( "FAIL --- 0100 boolean not" );

        // finish tb
        #(`CYCLE) $finish;
    end

endmodule
