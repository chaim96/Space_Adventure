// (c) Technion IIT, Department of Electrical Engineering 2022 
// Updated by Mor Dahan - January 2022

// Implements a 4 bits down counter 9  down to 0 with several enable inputs and loadN data.
// It outputs count and asynchronous terminal count, tc, signal 

module up_counter
	(
	input logic clk,
	input logic resetN, 
	input logic hit,
	input logic bonus, 
	input logic enable,
   input logic gameOver,
   input	logic scoreCheat,
	
	
	output logic [3:0] count,
	output logic tc
   );
	
	parameter int BONUS_SCORE = 2; 
	parameter int REGULAR_SCORE = 1; 
	parameter int CHEAT_SCORE = 9;
	

	logic bonushit;
	logic flag; 

	
always_ff @(posedge clk or negedge resetN or posedge gameOver)
   begin
	     
      if ( (!resetN) || (gameOver) )	begin// Asynchronic reset
			count <= 0;
			flag <= 0;
		end
				
      else begin
			
			if (!scoreCheat) begin
				count <= CHEAT_SCORE;
			end
			
			else begin
				
				if ( !bonus && !hit ) begin
					flag <= 1'b0 ;
				end 
				
				if (bonus && enable) begin	// Synchronic logic		
					flag <= 1'b1 ; // so as to not to have multiple score additions in a single visible collision.
					if (count > 9 - BONUS_SCORE) begin
						count <= count - (10 - BONUS_SCORE); // in order to have a correct 9-digit cyclic counting.
					end	
					
					else begin
						count <= count + BONUS_SCORE;
					end	
				end
				
				else begin
					if (hit && enable) begin
						flag <= 1'b1 ;
						count <= (count == 4'd9) ? 0 : count + REGULAR_SCORE;
					end 
				end	
			end
		end
	end
	
	
assign bonushit = bonus && enable && (count > 9 - BONUS_SCORE)	 ; // when there is a need to chnge the higher digit as well as the lower.

assign tc =  (bonushit || (count==4'd9 && hit));
		


endmodule
