module endgame_sm
	(
	input logic clk, 
	input logic resetN, 
	input logic gameOver,
	input logic win,
	input logic original_gameOver_DR,
	input logic original_win_DR,
		
	output logic gameOver_DR,
	output logic win_DR
	);
	
	
	enum logic [1:0] {s_idle, s_game_over, s_win} game_ps, game_ns;
	
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
	win_DR = 0;
		
	case (game_ps)
	
	s_idle: begin
		if (gameOver == 1'b1) begin
			game_ns = s_game_over;
			gameOver_DR = original_gameOver_DR;
		end
		if (win == 1'b1) begin
			game_ns = s_win;
			win_DR = original_win_DR;
		end
	end
	
	s_game_over: begin
			gameOver_DR = original_gameOver_DR;
	end
	
	s_win: begin
	      win_DR = original_win_DR;
	end		
		
	endcase
	end
endmodule
			