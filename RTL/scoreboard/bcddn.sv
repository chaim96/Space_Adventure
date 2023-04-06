// (c) Technion IIT, Department of Electrical Engineering 2022 
// Written By Liat Schwartz August 2018 
// Updated by Mor Dahan - January 2022

// Implements a BCD down counter 99 down to 0 with several enable inputs and loadN data
// having countL, countH and tc outputs
// by instantiating two one bit down-counters


module bcddn
	(
	input  logic clk, 
	input  logic resetN, 
	input	 logic hit, 
	input  logic bonus, 
	input  logic gameOver,
	input	 logic scoreCheat,
	
	output logic [3:0] countL, 
	output logic [3:0] countH,
	output logic tc
   );

// Parameters defined as external, here with a default value - to be updated 
// in the upper hierarchy file with the actial bomb down counting values
// -----------------------------------------------------------

// -----------------------------------------------------------
	parameter int BONUS_SCORE = 2;
	parameter int Regular_SCORE = 1;
	parameter int CHEAT_SCORE = 9;
	logic  tclow, tchigh;// internal variables terminal count 
	logic enableH;
	logic tcPrep;
	
// Low counter instantiation
	up_counter lowc( 
							.clk(clk),
							.resetN(resetN),
							.gameOver(gameOver),
							.hit(hit),
							.bonus(bonus),	
							.enable(1'b1),  	
							.count(countL), 
							.tc(tclow),
							.scoreCheat(scoreCheat) );
	
// High counter instantiation
	up_counter highc(
							.clk(clk),
							.resetN(resetN),
							.gameOver(gameOver),
							.hit(hitH),
							.bonus(1'b0),	
							.enable(enableH), 	
							.count(countH), 
							.tc(tchigh),
							.scoreCheat(scoreCheat) );	
  
 
	assign hitH = hit || bonus ; // for highc to have indiciation of any sort of hit since its bonus indication is disabled.
	assign enableH = tclow  ;
	assign tcPrep = (countH == 4'd9  && countL == 4'd9 && (hit || bonus)) ||
																					(countH == 4'd9 && countL >= 4'd9 && bonus);
																	
	//assign tc =  enableH && tchigh; 
	
	
	always_ff @(posedge clk or negedge resetN) begin
	
		if (!resetN) begin 
			tc <= 0;
		end
		else begin 
			if (tcPrep) 
				tc <= 1;
		end	
	end
	
endmodule
