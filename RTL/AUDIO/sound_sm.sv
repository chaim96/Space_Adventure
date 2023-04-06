module sound_sm
	(
	input logic clk, 
	input logic resetN,
   input logic obstacleHit,
	input logic wormholeHit, 
	input logic rightFlipperHit,
	input logic leftFlipperHit,
	input logic win,
	input logic gameOver,
	input logic keyPadValid,
	input logic longTime, 
	input logic shortTime,
		
	output logic [3:0] tone,
	output logic enable
	);
	
	
	enum logic [6:0] {s_start, s_idle, s_hold_cannon, s_hold_shot, s_hit_obstacle1, s_hit_obstacle2, s_hit_wormhole1, s_hit_wormhole2, 
	            s_win1, s_win2, s_win3, s_win4, s_win5, s_win_pause1, s_win_pause2, s_win_pause3,
					s_game_over1, s_game_over2, s_game_over3, s_game_over4, s_game_over5, s_final} game_ps, game_ns;
	
	always @(posedge clk or negedge resetN  )
	begin
	
	if ( !resetN )  // Asynchronic reset
		game_ps <= s_start;
   
	else 		// Synchronic logic FSM
		game_ps <= game_ns;
		
	end // always sync
	
	always_comb begin
	
	game_ns = game_ps;
	tone = 0;
	enable = 0; 
		
	case (game_ps)
	
	s_start: begin
		if (keyPadValid) begin
			game_ns = s_hold_cannon ; 			
			
		end
	end
	
	s_hold_cannon: begin
		if (!keyPadValid) begin 
			enable = 1'b1 ;
			tone = 4'd11 ;
			game_ns = s_hold_shot; 
		end 
	end
	
	s_hold_shot: begin 
			enable = 1'b1 ;
			tone = 4'd11 ;
		if (shortTime) begin 
			game_ns = s_idle;
		end
	end 
	
	s_idle: begin 
	
		if (win) begin 
			game_ns = s_win1 ;
			enable = 1'b1 ;
			tone = 4'd5; 
		end 
	
		if ( obstacleHit  ) begin 
			game_ns = s_hit_obstacle1;
			enable = 1'b1; 
			tone = 4'd5 ;
		end
		if (wormholeHit) begin
			game_ns = s_hit_wormhole1 ; 
			enable = 1'b1 ;
			tone = 4'd0 ;
		end

		if (gameOver ) begin 
			game_ns = s_game_over1 ; 
 
		end 
	end
	
	s_hit_obstacle1: begin 
		enable =1'b1 ; 
		tone = 4'd5 ; 
		if ( shortTime ) begin 
			game_ns = s_hit_obstacle2 ;
			enable =1'b1 ; 
			tone = 4'd5 ;
		end
		if (win) begin 
			game_ns = s_win1 ;
			enable = 1'b1 ;
			tone = 4'd5; 
		end 
		if (gameOver ) begin 
			game_ns = s_game_over1 ; 
 
		end 		
	end
	s_hit_obstacle2: begin 
		enable =1'b1 ; 
		tone = 4'd5 ; 
		if ( shortTime ) begin 
			game_ns = s_idle ;
		end
		if (win) begin 
			game_ns = s_win1 ;
			enable = 1'b1 ;
			tone = 4'd5; 
		end
		if (gameOver ) begin 
			game_ns = s_game_over1 ; 
 
		end  		
	end 
	
	s_hit_wormhole1: begin 
		enable =1'b1 ; 
		tone = 4'd0 ; 
		if ( shortTime ) begin 
			game_ns = s_hit_wormhole2 ;
			enable =1'b1 ; 
			tone = 4'd0 ;
		end
		if (win) begin 
			game_ns = s_win1 ;
			enable = 1'b1 ;
			tone = 4'd5; 
		end 		
	end 
	
	s_hit_wormhole2: begin 
		enable =1'b1 ; 
		tone = 4'd0 ; 
		if ( shortTime ) begin 
			game_ns = s_idle ;

		end
		if (win) begin 
			game_ns = s_win1 ;
			enable = 1'b1 ;
			tone = 4'd5; 
		end 		
	end
	
	s_win1: begin 
		//enable =1'b1 ; 
		//tone = 4'd6 ; 
		if ( shortTime ) begin 
			game_ns = s_win2 ;
			enable = 1'b1 ; 
			tone = 4'd5 ;
		end 
	end 

	s_win2: begin 
		enable =1'b1 ; 
		tone = 4'd5 ; 
		if ( shortTime ) begin 
			game_ns = s_win_pause1 ;
			enable = 1'b1 ; 
			tone = 4'd5 ;
		end 
	end 
	
	s_win_pause1: begin 
		enable =1'b0 ;  
		if ( shortTime ) begin 
			game_ns = s_win3 ;
			enable = 1'b1 ; 
			tone = 4'd5 ;
		end 
	end 	
	
	s_win3: begin 
		enable = 1'b1 ; 
			tone = 4'd5 ;  
		if ( shortTime ) begin 
			game_ns = s_win_pause2 ;
			enable = 1'b1 ; 
			tone = 4'd5 ;
		end 
	end 

	s_win_pause2: begin 
		enable = 0 ;   
		if ( shortTime ) begin 
			game_ns = s_win4 ;
			enable = 1'b1 ; 
			tone = 4'd5 ;
		end 
	end 

	s_win4: begin 
		enable = 1'b1 ; 
		tone = 4'd5 ;   
		if ( shortTime ) begin 
			game_ns = s_win_pause3 ;
			enable = 1'b1 ; 
			tone = 4'd5 ;
		end 
	end 			
	
	s_win_pause3: begin 
		enable = 0 ;   
		if ( shortTime ) begin 
			game_ns = s_win5 ;
			enable = 1'b1 ; 
			tone = 4'd11 ;
		end 
	end 
	
	s_win5: begin 
		enable = 1'b1 ; 
		tone = 4'd11 ;   
		if ( longTime ) begin 
			game_ns = s_final ;
			enable = 1'b1 ; 
			tone = 4'd11 ;
		end 
	end 	

	
	
	
	s_game_over1: begin 
		enable = 0 ;  
		if ( shortTime ) begin 
			game_ns = s_game_over2 ;
			enable = 1'b1 ; 
			tone = 4'd0 ;
		end 
	end 

	s_game_over2: begin 
		enable =1'b1 ; 
		tone = 4'd0 ; 
		if ( shortTime ) begin 
			game_ns = s_game_over3 ;
			enable = 1'b1 ; 
			tone = 4'd1 ;
		end 
	end 
	
	s_game_over3: begin 
		enable = 1'b1 ; 
		tone = 4'd1 ;  
		if ( shortTime ) begin 
			game_ns = s_game_over4 ;
			enable = 1'b1 ; 
			tone = 4'd2 ;
		end 
	end 	
	
	s_game_over4: begin 
		enable = 1'b1 ; 
		tone = 4'd2 ;  
		if ( shortTime ) begin 
			game_ns = s_game_over5 ;
			enable = 1'b1 ; 
			tone = 4'd3 ;
		end 
	end 

	s_game_over5: begin 
		enable = 1'b1 ; 
		tone = 4'd3 ;  
		if ( longTime ) begin 
			game_ns = s_idle ;
			enable = 0 ; 
		end 
	end 
	
	s_final: begin 
	end
	

	endcase
	end
	
endmodule 