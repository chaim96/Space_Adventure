
module wormholes_sm
	(
	input logic clk, 
	input logic resetN, 
	input logic oneSec,		
	input logic collision_Wormhole1,
	input logic collision_Wormhole2,
	input logic S1_collision_Wormhole1,
	input logic S1_collision_Wormhole2,
	input logic S2_collision_Wormhole1,
	input logic S2_collision_Wormhole2,
	
	output logic collision_Wormhole1_Updated,
	output logic collision_Wormhole2_Updated,
	output logic S1_collision_Wormhole1_Updated,
	output logic S1_collision_Wormhole2_Updated,
	output logic S2_collision_Wormhole1_Updated,
	output logic S2_collision_Wormhole2_Updated
	);
	
	
	enum logic [2:0] {s_idle, s_hold1_collision_with_wormhole1, s_hold2_collision_with_wormhole1,
							s_hold1_collision_with_wormhole2, s_hold2_collision_with_wormhole2} game_ps, game_ns;
							
	logic any_collision_WH1 ; 
	logic any_collision_WH2 ;
	
	
	always @(posedge clk or negedge resetN)
	begin
	
		if ( !resetN ) 
			game_ps <= s_idle;
		
		else 		
			game_ps <= game_ns;
			
	end 
	
	always_comb begin
	
	
		any_collision_WH1 = collision_Wormhole1 || S1_collision_Wormhole1 || S2_collision_Wormhole1 ; 
		any_collision_WH2 = collision_Wormhole2 || S2_collision_Wormhole2 || S2_collision_Wormhole2 ;
	
		game_ns = game_ps;
		collision_Wormhole1_Updated = collision_Wormhole1;
		collision_Wormhole2_Updated = collision_Wormhole2;
		S1_collision_Wormhole1_Updated = S1_collision_Wormhole1;
		S1_collision_Wormhole2_Updated = S1_collision_Wormhole2;
		S2_collision_Wormhole1_Updated = S2_collision_Wormhole1;
		S2_collision_Wormhole2_Updated = S2_collision_Wormhole2;
		case (game_ps)
		
			s_idle: begin
				if (any_collision_WH1 == 1'b1) begin
					game_ns = s_hold1_collision_with_wormhole1;
					collision_Wormhole2_Updated = 0;
					S1_collision_Wormhole2_Updated = 0;
					S2_collision_Wormhole2_Updated = 0;
				end
				if (any_collision_WH2 == 1'b1) begin
					game_ns = s_hold1_collision_with_wormhole2;
					collision_Wormhole1_Updated = 0;
					S1_collision_Wormhole1_Updated = 0;
					S2_collision_Wormhole1_Updated = 0;
				end
			end
			
			s_hold1_collision_with_wormhole1: begin
					collision_Wormhole2_Updated = 0;
					S1_collision_Wormhole2_Updated = 0;
					S2_collision_Wormhole2_Updated = 0;
				if (oneSec) begin
					game_ns = s_hold2_collision_with_wormhole1;
				end
			end
			
			s_hold2_collision_with_wormhole1: begin
				collision_Wormhole2_Updated = 0;
				S1_collision_Wormhole2_Updated = 0;
				S2_collision_Wormhole2_Updated = 0;
				if (oneSec) begin
					game_ns = s_idle;
				end
			end
			
			s_hold1_collision_with_wormhole2: begin
				collision_Wormhole1_Updated = 0;
				S1_collision_Wormhole1_Updated = 0;
				S2_collision_Wormhole1_Updated = 0;
				if (oneSec) begin
					game_ns = s_hold2_collision_with_wormhole2;
				end
			end
			
			s_hold2_collision_with_wormhole2: begin
				collision_Wormhole1_Updated = 0;
				S1_collision_Wormhole1_Updated = 0;
				S2_collision_Wormhole1_Updated = 0;
				if (oneSec) begin
					game_ns = s_idle;
				end
			end
		
		endcase
	end
endmodule
			