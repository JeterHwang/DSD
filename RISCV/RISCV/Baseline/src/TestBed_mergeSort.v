`timescale 1 ns/10 ps
`define EndAddr     30'd255	 // 536 / 4
`define MemSize     8       // 8 array numbers
`define Arrbegin    30'd128
`define Arrend      30'd136
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

	reg     [1:0]   curstate, nxtstate;

	reg signed [31:0] sortedArr  [0 : `MemSize - 1];
	reg	signed [31:0] mem_answer_r [0:255];
	reg	signed [31:0] mem_answer_w [0:255];

	wire    [31:0]  data_modify;
	
	parameter	state_idle 	= 2'b00;
	parameter	state_check = 2'b01;
	parameter	state_report= 2'b10;
	
	integer i;

	assign data_modify = {data[7:0],data[15:8],data[23:16],data[31:24]}; // convert little-endian format to readable format
	
	initial begin
		error_num 	= 0;
		duration 	= 0;
		$readmemh(`golden, sortedArr);
	end

	always@(*) begin
		for(i = 0; i < 256; i = i + 1)
			mem_answer_w[i] = mem_answer_r[i];
		case (curstate)
			state_check: begin
				finish = 1'b0;
				if(wen) begin
					//$display("Write %d on address %d", data_modify, addr);
					if(addr == `EndAddr) begin
						nxtstate = state_report;
					end
					else begin
						nxtstate = state_check;
					end
					mem_answer_w[addr] 	= data_modify;
				end
				else begin
					nxtstate = curstate;
				end
			end
			state_report: begin
				finish = 1'b1;
				nxtstate = state_report;
			end
			default: begin
				finish = 1'b0;
				nxtstate = curstate;
			end
		endcase
	end

	always@( negedge clk )						
	begin
		if(curstate == state_report) begin
			$display("--------------------------- Simulation FINISH !!---------------------------");
			for(i = `Arrbegin; i < `Arrend; i = i + 1) begin
				if(mem_answer_r[i] !== sortedArr[i - `Arrbegin]) begin
					if(i == 0)
						$display("Error !!\n");
					$display("Element #%d : expected %d while got %d\n", i - `Arrbegin + 1, sortedArr[i - `Arrbegin], mem_answer_r[i]);
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
		end
	end

	always@( posedge clk or negedge rst )						// State-DFF
	begin
		if( ~rst )
		begin
			curstate <= state_check;
			for(i = 0; i < 256; i = i + 1)
				mem_answer_r[i] <= 32'd0;
		end
		else
		begin
			curstate <= nxtstate;
			for(i = 0; i < 256; i = i + 1)
				mem_answer_r[i] <= mem_answer_w[i];
		end
	end
endmodule