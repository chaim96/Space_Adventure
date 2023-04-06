// (c) Technion IIT, Department of Electrical Engineering 2021 
module random_obstacle2 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input	logic	 rise,
	output logic unsigned [SIZE_BITS-1:0] dout	
  ) ;

// Generating a random number by latching a fast counter with the rising edge of an input ( e.g. key pressed )

parameter unsigned INITIAL = 100; 
parameter unsigned OFFSET = 30 ; 
parameter SIZE_BITS = 8;
parameter unsigned  MIN_VAL = 0;  //set the min and max values 
parameter unsigned MAX_VAL = 255; 



	logic unsigned  [SIZE_BITS-1:0] counter/* synthesis keep = 1 */;
	logic rise_d /* synthesis keep = 1 */;
	logic ONE = 0; 
	
always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			dout <= INITIAL;
			counter <= MIN_VAL;
			rise_d <= 1'b0;
		end
		
		else begin
			counter <= counter+10;
			if ( counter >= MAX_VAL ) // the +1 is done on the next clock 
				counter <=  MIN_VAL ; // set min and max mvalues 
			rise_d <= rise;
			if (rise && !rise_d) begin  // rising edge 
				dout <= INITIAL + ONE * OFFSET ;
				ONE  <= ONE + 1'b1;
			end
		end
	
	end
 
endmodule
