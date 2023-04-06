// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	cannon_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz    
					input	logic	[3:0] HitEdgeCode, //one bit per edge 
					input logic cannon_load,
					input logic cannon_hold,

					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 610;
parameter int INITIAL_Y = 385;
parameter int INITIAL_X_SPEED = 80;
parameter int INITIAL_Y_SPEED = 5;
parameter int MAX_Y_SPEED = 230;
const int  Y_ACCEL = -1;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	635 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	400 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;
const int   OBJECT_WIDTH_X = 64;

int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;
int Yaccel;



//////////--------------------------------------------------------------------------------------------------------------=
//  calculation 0f Y Axis speed using gravity or colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		Yspeed	<= 0;
		Yaccel   <= 0;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end 
	else begin
	// colision Calcultaion 
			
		//hit bit map has one bit per edge:  Left-Top-Right-Bottom	 

		if (cannon_load) begin 
			Yspeed <= INITIAL_Y_SPEED;
		end
	

		// perform  position and speed integral only 30 times per second 
		
		if (startOfFrame == 1'b1) begin 
				if (!cannon_hold) begin
					if (cannon_load) begin 
						topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed; 
					end
					else begin 
						topLeftY_FixedPoint  <= INITIAL_Y * FIXED_POINT_MULTIPLIER  ; 
					end
					
				end
				
				
				if (Yspeed < MAX_Y_SPEED ) //  limit the spped while going down 
						Yspeed <= Yspeed  ; // deAccelerate : slow the speed down every clock tick 
		
								



		end
	end
end 

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation of X Axis speed using and position calculate regarding X_direction key or colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		Xspeed	<= 0;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
	end
end
		


//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
