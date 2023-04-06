module game_over
	(
	input logic clk, 
	input logic resetN, 
	input logic gameOver,
		
	output logic gameOver_DR
	);
	
	
	enum logic {s_idle, s_game_over} game_ps, game_ns;
	
	always @(posedge clk or negedge resetN)
	begin
	
	if ( !resetN )  // Asynchronic reset
		game_ps <= s_idle;
   
	else 		// Synchronic logic FSM
		game_ps <= game_ns;
		
	end // always sync
	
	always_comb begin
	
	game_ns = game_ps;
	gameOver_DR = 0;
		
	case (game_ps)
	
	s_idle: begin
		if (gameOver == 1'b1) begin
			game_ns = s_game_over;
			gameOver_DR = 1'b1;
		end
	end
	
	s_game_over: begin
			gameOver_DR = 1'b1;
	end

	endcase
	end
endmodule
			