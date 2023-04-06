module open_sm
	(
	input logic clk, 
	input logic resetN, 
	input logic start,
	input logic drawing_request, 
		
	output logic openMessege_DR
	);
	
	
	enum logic {s_idle, s_play} game_ps, game_ns;
	
	always @(posedge clk or negedge resetN)
	begin
	
	if ( !resetN )  // Asynchronic reset
		game_ps <= s_idle;
   
	else 		// Synchronic logic FSM
		game_ps <= game_ns;
		
	end // always sync
	
	always_comb begin
	
	game_ns = game_ps;
	openMessege_DR = 0;
		
	case (game_ps)
	
	s_idle: begin
		openMessege_DR = drawing_request;
		if (start == 1'b1) begin
			game_ns = s_play;
			openMessege_DR = 0;
		end
	end
	
	s_play: begin
			
	end

	endcase
	end
endmodule
			