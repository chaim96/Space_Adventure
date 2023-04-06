// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	ball2_survival_mode_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	Y_direction,  //change the direction in Y to up   
					input logic collisionBrackets,  //collision if ball hits  brackets
					input	logic	[3:0] HitEdgeCode, //one bit per edge 
					input logic startGame,
					input	logic collisionMovingObstacle, //the following signals are varied objects collsion signals
					input	logic collisionWormhole1,
					input	logic collisionWormhole2,
					input	logic collisionObstacle,
					input	logic collisionBumper,
					input	logic collisionLeftFlipper,
					input logic collisionRightFlipper,
					input logic [6:0]alphaLeft,	// the angle of the flippers
					input logic [6:0]alphaRight,

					
					
					output logic signed 	[10:0]	topLeftX, // output the top left corner 
					output logic signed	[10:0]	topLeftY,  // can be negative , if the object is partliy outside
				   output logic gameOver 	
					
);


// a module used to generate the  ball trajectory.  
//parameters for easy change of properties
parameter int INITIAL_X = 10;
parameter int INITIAL_Y = 210;
parameter int INITIAL_X_SPEED = 150;
parameter int INITIAL_Y_SPEED = -150;
parameter int MAX_Y_SPEED = 300;
parameter int MAX_X_SPEED = 300;
parameter int GRAVITATION_ADDITION = 3;
parameter int SPEED_ADDITION = -20;
parameter int OBSTACLE_SPEED_ADDITION = 10;
parameter int WORMHOLE_SPEED_ADDITION = 20;
parameter int WORMHOLE1_Y = 150;
parameter int WORMHOLE1_X = 570;
parameter int WORMHOLE2_Y = 34;
parameter int WORMHOLE2_X = 5;
parameter int X_RIGHT_BORDER = 635; 
parameter int X_LEFT_BORDER = 1;
parameter int Y_TOP_BORDER = 32; 
parameter int Y_BOTTOM_BORDER = 400;
parameter int BALL_WIDTH = 16; 
parameter int BALL_HEIGHT = 16;
parameter int SPEED_REDUCTION = 20;

const int  Y_ACCEL = -1;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
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

		if (startGame == 1'b1) begin //determinig start speed
			Yspeed <= INITIAL_Y_SPEED ;
			Yaccel <= GRAVITATION_ADDITION ;
		end
				

		
		//collisions with brackets and obstacles			
		if ((collisionBrackets) && (HitEdgeCode [2] == 1 && ( HitEdgeCode [1] == 1 || HitEdgeCode [3] == 1 ) )
										 && (topLeftY_FixedPoint <= Y_TOP_BORDER * FIXED_POINT_MULTIPLIER))
		begin   
				if (Yspeed < 0) begin 
					Yspeed <= -Yspeed ; 
				end
		end
		
		else if ( collisionBrackets == 1 && HitEdgeCode [2] == 1 
							&& topLeftX_FixedPoint <= X_LEFT_BORDER * FIXED_POINT_MULTIPLIER
							&& topLeftX_FixedPoint >= (X_RIGHT_BORDER - BALL_WIDTH - 1) * FIXED_POINT_MULTIPLIER)
		begin 
				if (Yspeed < 0) begin 
					Yspeed <= -Yspeed ; 
				end
		end
		
			
		if ((( collisionObstacle  || collisionBumper)  
				&& (HitEdgeCode [2] == 1  ))) begin  
				if (Yspeed < 0) begin 
					Yspeed <= -Yspeed ; 
				end
		end
		
					
		if (((collisionBrackets) && (HitEdgeCode [0] == 1 && ( HitEdgeCode [1] == 1 || HitEdgeCode [3] == 1 )) 
										 && topLeftY_FixedPoint >= (Y_BOTTOM_BORDER - BALL_HEIGHT) * FIXED_POINT_MULTIPLIER )) 
		begin  
				if (Yspeed > 0) begin 
					Yspeed <= (Yspeed <= 40) ? -Yspeed :-Yspeed +2*SPEED_REDUCTION; 
				end
		end
		
		else if ( collisionBrackets == 1 && HitEdgeCode [0] == 1 
							&& topLeftX_FixedPoint <= X_LEFT_BORDER * FIXED_POINT_MULTIPLIER
							&& topLeftX_FixedPoint >= (X_RIGHT_BORDER - BALL_WIDTH - 1) * FIXED_POINT_MULTIPLIER)
		begin 
				if (Yspeed > 0) begin 
					Yspeed <= (Yspeed <= 40) ? -Yspeed :-Yspeed +2*SPEED_REDUCTION ; 
				end
		end			
				
		if ((( collisionObstacle || collisionBumper) 
				&& (HitEdgeCode [0] == 1 ))) begin  
				if (Yspeed > 0) begin
					Yspeed <= (Yspeed <= 40) ? -Yspeed :-Yspeed +2*SPEED_REDUCTION; ;
				end
		end
		
		//collision with moving obstacle
		if ((collisionMovingObstacle  && HitEdgeCode [2] == 1 ))	begin
				if (Yspeed < 0) begin
					Yspeed <= -Yspeed + OBSTACLE_SPEED_ADDITION; 
				end
		end
		
		
		if ((collisionMovingObstacle && HitEdgeCode [0] == 1 )) begin
				if (Yspeed > 0 ) begin
					Yspeed <= -Yspeed - OBSTACLE_SPEED_ADDITION;
				end
		end
		
		//upon entering a wormhole
		if (collisionWormhole1) begin
				topLeftY_FixedPoint <= WORMHOLE1_Y * FIXED_POINT_MULTIPLIER ;
				if (Yspeed < 0 ) begin
					Yspeed <= -Yspeed + WORMHOLE_SPEED_ADDITION;
				end
				else begin
					Yspeed <= Yspeed + WORMHOLE_SPEED_ADDITION;
				end
		end
			
		if (collisionWormhole2) begin
				topLeftY_FixedPoint <= WORMHOLE2_Y * FIXED_POINT_MULTIPLIER;
				if (Yspeed < 0 ) begin
					Yspeed <= -Yspeed + WORMHOLE_SPEED_ADDITION;
				end
				else begin
					Yspeed <= Yspeed + WORMHOLE_SPEED_ADDITION;
				end
		end
		
		 //Flippers collisions
		
		if (collisionLeftFlipper && HitEdgeCode[0])
		begin 
			if (Yspeed > 0) begin
				if (alphaLeft <= 7'd10 )
					Yspeed <= (Yspeed + SPEED_REDUCTION >= MAX_Y_SPEED) ? -MAX_Y_SPEED : -Yspeed - SPEED_REDUCTION ;
				else if (alphaLeft <= 7'd35 && alphaLeft > 7'd10)
					Yspeed <= (Yspeed + 5*SPEED_REDUCTION >= MAX_Y_SPEED) ? -MAX_Y_SPEED : -Yspeed - 3*SPEED_REDUCTION  ;
				else Yspeed <= (Yspeed + 2*SPEED_REDUCTION >= MAX_Y_SPEED) ? -MAX_Y_SPEED : -Yspeed - 2*SPEED_REDUCTION ;
			end
			
		end
		
		if (collisionRightFlipper && HitEdgeCode[0])
		begin 
			if (Yspeed > 0) begin
				if (alphaRight <= 7'd10 )
					Yspeed <= (Yspeed + SPEED_REDUCTION >= MAX_Y_SPEED) ? -MAX_Y_SPEED : -Yspeed - SPEED_REDUCTION ;
				else if (alphaRight <= 7'd35 && alphaRight > 7'd10)
					Yspeed <= (Yspeed + 5*SPEED_REDUCTION >= MAX_Y_SPEED) ? -MAX_Y_SPEED : -Yspeed - 3*SPEED_REDUCTION  ;
				else Yspeed <= (Yspeed + 2*SPEED_REDUCTION >= MAX_Y_SPEED) ? -MAX_Y_SPEED : -Yspeed - 2*SPEED_REDUCTION ;
			end
			
		end
		
		
		
		
//		if ((collisionLeftFlipper || collisionRightFlipper) && HitEdgeCode[0])
//		begin 
//			if (Yspeed > 0) 
//				 Yspeed <= (Yspeed +5*SPEED_REDUCTION >= MAX_Y_SPEED) ? -MAX_Y_SPEED : -Yspeed - 5*SPEED_REDUCTION ;
//			
//			
//		end
		

		

		// Y direction cheat
		if (Y_direction && Yspeed < 0 )
			Yspeed <= -Yspeed;
		
		

					
		
		if (startOfFrame == 1'b1) begin 
				topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed; // position interpolation 
				if (Yspeed < MAX_Y_SPEED ) begin //  limit the spped while going down 
					Yspeed <= (Xspeed != 0) ? Yspeed  + Yaccel : Yspeed; // deAccelerate : slow the speed down SOF 
				end
		end
		

				if (topLeftY_FixedPoint >= 480 * FIXED_POINT_MULTIPLIER ) begin
					gameOver <= 1'b1;
					Yspeed	<= 0;
    	         Yaccel   <= 0;
					topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
				end
				else begin
				gameOver <= 0;
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
	else begin
	
	
				if (startGame == 1'b1) begin //determinig start speed
					Xspeed <= INITIAL_X_SPEED ;
				end
				
	// collisions with the sides and other obstacles	
				if (((collisionBrackets ) && (HitEdgeCode [3] == 1 && ( HitEdgeCode [0] == 1 || HitEdgeCode [2] == 1  )) 
												&& topLeftX_FixedPoint <=  X_LEFT_BORDER * FIXED_POINT_MULTIPLIER))  
				begin  
					if (Xspeed < 0 ) begin// while moving left
							Xspeed <= -Xspeed  ;
					end	; // positive move right 
				end
				else if (collisionBrackets && HitEdgeCode [3] == 1  
								&& topLeftY_FixedPoint <= Y_TOP_BORDER * FIXED_POINT_MULTIPLIER
								&& topLeftY_FixedPoint >= (Y_BOTTOM_BORDER - BALL_HEIGHT - 1) * FIXED_POINT_MULTIPLIER)
				begin 
					if (Xspeed < 0 ) begin// while moving left
							Xspeed <= -Xspeed  ;
					end	; // positive move right 
				end
			  if (( collisionObstacle || collisionBumper)
																			&& HitEdgeCode [3] == 1) begin  
					if (Xspeed < 0 ) begin // while moving left
							Xspeed <= -Xspeed  ;
					end	// positive move right 
				end
				if ((collisionBrackets) && (HitEdgeCode  [1] == 1 && (HitEdgeCode [2] == 1 || HitEdgeCode [0] == 1))
			                           && topLeftX_FixedPoint >=  (X_RIGHT_BORDER - BALL_WIDTH) * FIXED_POINT_MULTIPLIER	) begin  // hit right border of brick  
					if (Xspeed > 0 )begin //  while moving right
							Xspeed <= -Xspeed  ; 
					end	  // negative move left
				end
		      else if (collisionBrackets && HitEdgeCode [1] == 1  
								&& topLeftY_FixedPoint <= Y_TOP_BORDER * FIXED_POINT_MULTIPLIER
								&& topLeftY_FixedPoint >= (Y_BOTTOM_BORDER - BALL_HEIGHT - 1) * FIXED_POINT_MULTIPLIER)
				begin 
				  	  if (Xspeed > 0 )begin //  while moving right
							Xspeed <= -Xspeed  ; 
					end	  // negative move left
				end		
			   
				 if (( collisionObstacle || collisionBumper )
																			&& HitEdgeCode  [1] == 1 ) begin  // hit right border of brick  
					if (Xspeed > 0 ) begin //  while moving right
							Xspeed <= -Xspeed   ; 
					end	// negative move left    
				end	
				
				//collision with the moving obstacle increases speed
				if (collisionMovingObstacle && HitEdgeCode [3] == 1) begin  
					if (Xspeed < 0 ) begin // while moving left
							Xspeed <= (-Xspeed + OBSTACLE_SPEED_ADDITION > MAX_Y_SPEED) ? MAX_Y_SPEED : -Xspeed + OBSTACLE_SPEED_ADDITION;
					end
					if (Xspeed == 0) begin
							Xspeed <= 120;
					end 
				end
				if (collisionMovingObstacle && HitEdgeCode  [1] == 1 ) begin    
					if (Xspeed > 0 ) begin //  while moving right
							Xspeed <= (Xspeed + OBSTACLE_SPEED_ADDITION > MAX_Y_SPEED) ? -MAX_Y_SPEED : -Xspeed - OBSTACLE_SPEED_ADDITION;
					end
					if (Xspeed == 0) begin
							Xspeed <= -120;
					end   
				end		
				
				//upon entering a wormhole
				if (collisionWormhole1) begin
							topLeftX_FixedPoint <= WORMHOLE1_X * FIXED_POINT_MULTIPLIER;
							if (Xspeed < 0) begin
								Xspeed <= -Xspeed + WORMHOLE_SPEED_ADDITION;
							end
							else begin
								Xspeed <= Xspeed + WORMHOLE_SPEED_ADDITION;
							end
				end
				
				if (collisionWormhole2) begin
					if (Xspeed < 0) begin							
							Xspeed <= Xspeed - WORMHOLE_SPEED_ADDITION;
					end 
					else begin 
							Xspeed <= Xspeed + WORMHOLE_SPEED_ADDITION;
					end 
					topLeftX_FixedPoint <= WORMHOLE2_X * FIXED_POINT_MULTIPLIER ;
				end
				if (collisionBumper && (Xspeed == 0)) begin
						Xspeed <= Yspeed;
				end
				
				
				//Flipper coliisions
				if (collisionLeftFlipper)
				begin
					if (Xspeed < 0 && HitEdgeCode[3]) begin
							
						if (alphaLeft <= 7'd35 && alphaLeft > 7'd10)
							Xspeed <= (-Xspeed + 2*SPEED_REDUCTION >= MAX_Y_SPEED) ? MAX_X_SPEED : Xspeed + SPEED_REDUCTION;
						else if ( alphaLeft >  7'd35 )
							Xspeed <= (-Xspeed + 3*SPEED_REDUCTION >= MAX_Y_SPEED) ? MAX_X_SPEED : Xspeed + 2*SPEED_REDUCTION;
					end
					if (Xspeed > 0) begin
   					if (alphaRight > 7'd35 )
							Xspeed <= (Xspeed + 3*SPEED_REDUCTION >= MAX_Y_SPEED) ? MAX_X_SPEED : Xspeed + 3*SPEED_REDUCTION;
					end
						
					
				end
				

							
					
						
				if (collisionRightFlipper)
				begin
					if (Xspeed > 0 && HitEdgeCode[1])  begin
						
						if (alphaRight <= 7'd35 && alphaRight > 7'd10)
							Xspeed <= (Xspeed + 2*SPEED_REDUCTION >= MAX_Y_SPEED) ? -MAX_X_SPEED : -Xspeed - SPEED_REDUCTION;
						else if ( alphaRight >  7'd35 )
							Xspeed <= (Xspeed + 2*SPEED_REDUCTION >= MAX_Y_SPEED) ? -MAX_X_SPEED : -Xspeed - 2*SPEED_REDUCTION;
					end
					if (Xspeed < 0 ) begin
   					if (alphaRight > 7'd35 )
							Xspeed <= (-Xspeed + 2*SPEED_REDUCTION >= MAX_Y_SPEED) ? -MAX_X_SPEED : Xspeed - 2*SPEED_REDUCTION;
					end
						
					
				end
						
						
				
				
				
				
				
				
				
		   
			
		if (startOfFrame == 1'b1 ) begin//&& Yspeed != 0) 
	
				        topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;
		end
			

		if (topLeftY_FixedPoint >= 480 * FIXED_POINT_MULTIPLIER) begin
					Xspeed	<= 0;
					topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
				end				
					
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
