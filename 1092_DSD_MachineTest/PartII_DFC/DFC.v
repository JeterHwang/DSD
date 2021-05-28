module DFC(clk, reset, datain, cmd, cmd_valid, dataout, output_valid, busy);
input           clk;
input           reset;
input   [7:0]   datain;
input   [1:0]   cmd;
input           cmd_valid;
output  [8:0]   dataout;
output          output_valid;
output          busy;

parameter IDLE      = 3'd0;
parameter LOAD_DATA = 3'd1;
parameter OUT       = 3'd2;
parameter FIFO      = 3'd3;
parameter LIFO      = 3'd4;



reg [1:0] cmd_r;
reg cmd_valid_r;
reg [7:0] datain_r;
reg [8:0] dataout_r [0:3];

reg busy_r, busy_w;
reg output_valid_r, output_valid_w;

reg [7:0] data_buf [0:7];
reg [7:0] nxt_data_buf [0:7];
reg [3:0] idx_r, idx_w;
reg [2:0] state, nxt_state;

reg [8:0] dataOutput;
wire [8:0] dataout_w [0:3];

integer i;

assign dataout 		= dataOutput;
assign busy 		= busy_w;
assign output_valid = output_valid_r;

ALU A1	(.out(dataout_w[0]), .mode(1'b1), .in_a(data_buf[7]), .in_b(data_buf[3]));       
ALU A2  (.out(dataout_w[1]), .mode(1'b1), .in_a(data_buf[6]), .in_b(data_buf[2]));       
ALU A3  (.out(dataout_w[2]), .mode(1'b1), .in_a(data_buf[5]), .in_b(data_buf[1]));       
ALU A4  (.out(dataout_w[3]), .mode(1'b1), .in_a(data_buf[4]), .in_b(data_buf[0]));       


//========= FSM =================
always@(*) begin  
	for(i = 0; i < 8; i = i + 1) begin
		nxt_data_buf[i] = data_buf[i];
	end
	busy_w 			= busy_r;
	output_valid_w 	= output_valid_r;
	idx_w 			= idx_r;
	nxt_state 		= state;
	dataOutput 		= dataout_r[0];

	case (state)
        IDLE: begin
			busy_w 			= 1'b0;
			output_valid_w 	= 1'b0;
			if(cmd_valid_r) begin
				if(cmd_r == 2'b00) begin
					nxt_state 	= LOAD_DATA;
					idx_w		= 4'd0;
				end
				else if(cmd_r == 2'b01) begin
					nxt_state 	= FIFO;
					idx_w		= 4'd0;
					output_valid_w = 1'b1;
				end
				else if(cmd_r == 2'b10) begin
					nxt_state 	= LIFO;
					idx_w		= 4'd3;
					output_valid_w = 1'b1;
				end
				else begin
					nxt_state 	= IDLE;
					idx_w		= 4'd0;
				end
				busy_w 		= 1'b1;
			end
        end
        LOAD_DATA: begin
			nxt_data_buf[0] = datain_r;
			for(i = 1 ; i < 8; i = i + 1)
				nxt_data_buf[i] = data_buf[i - 1];
			
			idx_w = idx_r + 1;
			if(idx_r == 7) begin
				nxt_state 	= OUT;
			end
        end
		OUT: begin
			busy_w 		= 1'b0;
            if(cmd_valid_r) begin
				nxt_state 	= cmd_r == 2'b01 ? FIFO : LIFO;
				idx_w 		= cmd_r == 2'b01 ? 4'd0 : 4'd3;
				busy_w 		= 1'b1;
				output_valid_w = 1'b1;
			end
        end
        FIFO: begin
			dataOutput 	= dataout_r[idx_r];
			idx_w 		= idx_r + 1;
			if(idx_r == 3) begin
				nxt_state 	= IDLE;
				output_valid_w = 1'b0;
			end
        end
        LIFO: begin
			dataOutput 	= dataout_r[idx_r];
			idx_w 		= idx_r - 1;
			if(idx_r == 0) begin
				nxt_state 	= IDLE;
				output_valid_w = 1'b0;
			end
        end
	endcase
end

//=============== Sequential =================
always @(posedge clk or posedge reset) begin  
	if (reset) begin
		for(i=0;i<8;i=i+1)
			data_buf[i] <= 8'd0;
		for(i = 0; i < 4; i = i + 1)
			dataout_r[i] <= 9'd0;
		cmd_r 			<= 2'd0;
		cmd_valid_r 	<= 1'b0;
		datain_r		<= 8'd0;
		busy_r 			<= 1'b0;
		output_valid_r 	<= 1'b0;
		idx_r 			<= 4'd0;
		state 			<= IDLE;
	end
	else begin
		for(i=0;i<8;i=i+1)
			data_buf[i] <= nxt_data_buf[i];
		for(i = 0; i < 4; i = i + 1)
			dataout_r[i] <= dataout_w[i];
		cmd_r 			<= cmd;
		cmd_valid_r 	<= cmd_valid;
		datain_r		<= datain;
		busy_r 			<= busy_w;
		output_valid_r 	<= output_valid_w;
		idx_r 			<= idx_w;
		state 			<= nxt_state;
	end
end

endmodule
