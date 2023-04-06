
module random_putStar 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	output logic dout	
  ) ;

// Generating a random number by latching a fast counter with the rising edge of an input ( e.g. key pressed )
 

parameter SIZE_BITS = 6;
parameter unsigned  MIN_VAL = 1;  //set the min and max values 
parameter unsigned MAX_VAL1 = 30;

int maxCounter = MAX_VAL1;

	logic unsigned  [SIZE_BITS-1:0] counter/* synthesis keep = 1 */;
	logic rise_d /* synthesis keep = 1 */;
	
	
always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			dout <= 0;
			counter <= MIN_VAL;
			rise_d <= 1'b0;
		end
		
		else begin
			counter <= counter+1;
			dout <= 1'b0;
			
			if ( counter >= maxCounter ) begin // the +1 is done on the next clock 
				counter <=  MIN_VAL; // set min and max mvalues 
				dout <= 1'b1;		
			end
			
		end
	
end
 
endmodule

