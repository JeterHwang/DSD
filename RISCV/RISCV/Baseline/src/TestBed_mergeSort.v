`timescale 1 ns/10 ps
`define EndAddr     32'd255	 // 536 / 4
`define MemSize     8       // 8 array numbers
`define Arrbegin    128
`define Arrend      136
`define golden     "./pattern/sortedArray.dat"

module	TestBed(
	clk,
	rst,
	addr,
	data,
	wen,
	error_num,
	duration,
	finish
);
	input			clk, rst;
	input	[29:0]	addr;
	input	[31:0]	data;
	input			wen;

	output	[7:0]	error_num;
	output	[15:0]	duration;
	output			finish;
	
	reg		[7:0]	error_num;
	reg		[15:0]	duration;
	reg				finish;

	reg     [1:0]   curstate;

	reg signed [31:0] sortedArr  [0 : `MemSize - 1];
	reg	signed [31:0] mem_answer [0:255];

	wire    [31:0]  data_modify;
		
	integer i;

	assign data_modify = {data[7:0],data[15:8],data[23:16],data[31:24]}; // convert little-endian format to readable format
	
	initial begin
		error_num 	= 0;
		duration 	= 0;
		finish 		= 0;
		curstate 	= 2'b00;
		$readmemh(`golden, sortedArr);
	end

	always@(posedge wen) begin
		if(addr == `EndAddr) begin
			$display("--------------------------- Simulation FINISH !!---------------------------");
			for(i = `Arrbegin; i < `Arrend; i = i + 1) begin
				if(mem_answer[i] !== sortedArr[i - `Arrbegin]) begin
					if(i == 0)
						$display("Error !!\n");
					$display("Element #%d : expected %d while got %d\n", i - `Arrbegin + 1, sortedArr[i - `Arrbegin], mem_answer[i]);
					error_num = error_num + 1;
				end
			end
			if (error_num) begin 
				$display("============================================================================");
				$display("\n (T_T) FAIL!! The simulation result is FAIL!!! there were %d errors at all.\n", error_num);
				$display("============================================================================");
			end
			 else begin 
				$display("============================================================================");
				$display("\n \\(^o^)/ CONGRATULATIONS!!  The simulation result is PASS!!!\n");
				$display("============================================================================");
			end
			curstate 	= 2'b10;
			finish 		= 1;
		end
		else begin
			mem_answer[addr] 	= data_modify;
			curstate 			= 2'b01;
		end
	end
endmodule