// created by Roee Dror & Chaim Javaheri, students of the Electrical & Computers Engineering faculty at the Technion.
// created as part of the final project in Lab A 1, March-May 2022.


module ball_sm
	(
	input logic clk, 
	input logic resetN, 
	input logic start, // to start the game
	input logic oneSec,  //counts seconds

		
	output logic [2:0] startSpeed,
	output logic startGame,
	output logic cannon_load,
	output logic cannon_hold
	);
	
	
	enum logic [2:0] {s_idle, s_hold1, s_hold2, s_hold3, s_hold4, s_hold5, s_play} game_ps, game_ns;
	
	always @(posedge clk or negedge resetN)
	begin
	
	if ( !resetN )  // Asynchronic reset
		game_ps <= s_idle;
   
	else 		// Synchronic logic FSM
		game_ps <= game_ns;
		
	end // always sync
	
	always_comb begin
	
	//default values
	game_ns = game_ps;
	startSpeed = 0;
	startGame = 0;
	cannon_load = 0;
	cannon_hold = 0; 
	
	
	case (game_ps)
	
	s_idle: begin
		if (start == 1'b1) begin //when the game starts
			game_ns = s_hold1;
			cannon_load = 1'b1;
		end
	end
	
	
	//in the following five states the cannon loads and the start speed changes every second
	s_hold1: begin
		cannon_load = 1'b1;
		if (start == 0) begin //launch
			cannon_load = 0;
			game_ns = s_play;
			startGame = 1'b1;
		end
		else if (oneSec) begin
		game_ns = s_hold2;
		
		end
	end
	
	s_hold2: begin
		cannon_load = 1'b1;
		if (start == 0) begin // launch
		   cannon_load = 1'b1;
			game_ns = s_play;
			startGame = 1'b1;
			startSpeed = 3'b1;
		end
		else if (oneSec) begin
		game_ns = s_hold3;
		end
	end
	
	s_hold3: begin
		cannon_load = 1'b1;
		if (start == 0) begin //launch
			cannon_load = 0;
			game_ns = s_play;
			startGame = 1'b1;
			startSpeed = 3'd2;
		end
		else if (oneSec) begin
		game_ns = s_hold4;
		end
	end
	
	s_hold4: begin
		cannon_load = 1'b1;
		if (start == 0) begin // launch
			cannon_load = 0;
			game_ns = s_play;
			startGame = 1'b1;
			startSpeed = 3'd3;
		end
		else if (oneSec) begin
		game_ns = s_hold5;
		end
	end
	
	s_hold5: begin
		cannon_hold = 1'b1; //holding the cannon in its place
		if (start == 0) begin // launch
			game_ns = s_play;
			startGame = 1'b1;
			startSpeed = 3'd4;
		end
	end
	
	//the is launched and the game starts
	s_play: begin //everything is in default 

	end
			
	
	endcase
	end
endmodule
			