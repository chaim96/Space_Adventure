module ball_survival_mode_sm
	(
	input logic clk, 
	input logic resetN, 
	input logic start,
	input logic gameOver,
	input logic tc ,
		
	output logic startGame,
	output logic SMBallDR
	);
	
	
	enum logic [2:0] {s_idle, s_play, s_gameOver} game_ps, game_ns;
	
	always @(posedge clk or negedge resetN)
	begin
	
	if ( !resetN )  // Asynchronic reset
		game_ps <= s_idle;
   
	else 		// Synchronic logic FSM
		game_ps <= game_ns;
		
	end // always sync
	
	always_comb begin
	
	game_ns = game_ps;
	startGame = 0;
	SMBallDR = 0;
	
	
	case (game_ps)
	
	s_idle: begin
		if (!start) begin
			SMBallDR = 1'b1 ;
			startGame = 1'b1 ;
			game_ns = s_play ;
		end
	end


	
	s_play: begin
		SMBallDR = 1'b1 ;
		if (gameOver || tc) begin
			game_ns = s_gameOver;
		end
	end
	
	s_gameOver: begin
		
	end
	
	endcase
	end
endmodule
			