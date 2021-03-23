`timescale 1ns/10ps
`define CYCLE  10
`define HCYCLE  5

module register_file_tb;
    // port declaration for design-under-test
    reg Clk, WEN;
    reg  [2:0] RW, RX, RY;
    reg  [7:0] busW;
    wire [7:0] busX, busY;
    
    // instantiate the design-under-test
    register_file rf(
        Clk  ,
        WEN  ,
        RW   ,
        busW ,
        RX   ,
        RY   ,
        busX ,
        busY
    );
    initial Clk = 0;
    always #(`HCYCLE) Clk = ~Clk; 
    // write your test pattern here

    initial begin
        $fsdbDumpfile("register_file.fsdb");
        $fsdbDumpvars;
    end

    initial begin
        @(negedge Clk) WEN = 1;
        @(posedge Clk) begin
            RW      = 3'b000;
            busW    = 8'b00000000; 
            
            RX      = 3'b000;
            RY      = 3'b001;
            
        end
        @(posedge Clk) begin
            RW      = 3'b001;
            busW    = 8'b00000001;
        end
        @(posedge Clk) begin
            RW      = 3'b010;
            busW    = 8'b00000010;

            $display("########### Output ###########");
            if(busX != 8'b00000000)                
                $display("busX Expect 8'b00000000 but %8b received !!", busX);
            else
                $display("busX pattern Pass !!");
            if(busY != 8'b00000001)
                $display("busY Expect 8'b00000001 but %8b received !!", busY);
            else
                $display("busY pattern Pass !!");
            $display("##############################");
        end
        @(posedge Clk) begin
            RW      = 3'b011;
            busW    = 8'b00000011;

            $display("########### Output ###########");
            if(busX != 8'b00000000)                
                $display("busX Expect 8'b00000000 but %8b received !!", busX);
            else
                $display("busX pattern Pass !!");
            if(busY != 8'b00000001)
                $display("busY Expect 8'b00000001 but %8b received !!", busY);
            else
                $display("busY pattern Pass !!");
            $display("##############################");
        end
        @(posedge Clk) begin
            RW      = 3'b100;
            busW    = 8'b00000100;
        end
        @(posedge Clk) begin
            RW      = 3'b101;
            busW    = 8'b00000101;

            RX      = 3'b010;
            RY      = 3'b101;
        end
        @(posedge Clk) begin
            RW      = 3'b110;
            busW    = 8'b00000110;

            $display("########### Output ###########");
            if(busX != 8'b00000010)                
                $display("busX Expect 8'b00000010 but %8b received !!", busX);
            else
                $display("busX pattern Pass !!");
            if(busY != 8'b00000101)
                $display("busY Expect 8'b00000101 but %8b received !!", busY);
            else
                $display("busY pattern Pass !!");
            $display("##############################");
        end
        @(posedge Clk) begin
            RW      = 3'b111;
            busW    = 8'b00000111;

            $display("########### Output ###########");
            if(busX != 8'b00000010)                
                $display("busX Expect 8'b00000010 but %8b received !!", busX);
            else
                $display("busX pattern Pass !!");
            if(busY != 8'b00000101)
                $display("busY Expect 8'b00000101 but %8b received !!", busY);
            else
                $display("busY pattern Pass !!");
            $display("##############################");
        end
        @(negedge Clk) WEN = 0;
        
        RX = 3'b111;
        RY = 3'b000;
        #(`CYCLE * 3)
        @(posedge Clk) begin
            $display("########### Output ###########");
            if(busX != 8'b00000111)                
                $display("busX Expect 8'b00000111 but %8b received !!", busX);
            else
                $display("busX pattern Pass !!");
            if(busY != 8'b00000000)
                $display("busY Expect 8'b00000000 but %8b received !!", busY);
            else
                $display("busY pattern Pass !!");
            $display("##############################");

        end
        @(posedge Clk) begin
            WEN = 1;
            RW  = 3'b000;
            busW = 8'b00000111;

            RX = 3'b000;
            RY = 3'b001;
        end
        @(posedge Clk) begin
            $display("########### Output ###########");
            if(busX != 8'b00000000)                
                $display("busX Expect 8'b00000000 but %8b received !!", busX);
            else
                $display("busX pattern Pass !!");
            if(busY != 8'b00000001)
                $display("busY Expect 8'b00000001 but %8b received !!", busY);
            else
                $display("busY pattern Pass !!");
            $display("##############################");
        end
        $display("------ Simualation finish ------");
        $finish;
    end

endmodule
