

module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	ball_DR,
			input logic bumper_DR,
			input logic movingObstacle_DR,
		   input logic wormhole1_DR,
			input logic wormhole2_DR,
      	input logic obtacle1_DR,
			input logic obtacle2_DR,
			input logic obtacle3_DR,
			input logic leftFlipper_DR,
			input logic rightFlipper_DR,
			input logic cannon_DR,
			input	logic	brackets_DR,
			
			output logic collision_Brackets,
			output logic collision_MovingObstacle,
			output logic collision_Wormhole1,
			output logic collision_Wormhole2,
			output logic collision_Obstacle1,
			output logic collision_Obstacle2,
			output logic collision_Obstacle3,
			output logic collision_Obstacles123,
			output logic collision_Bumper,
			output logic collision_LeftFlipper,
			output logic collision_RightFlipper,
			output logic collision,
			output logic SingleHitPulseObstacle1,
			output logic SingleHitPulseObstacle2,
			output logic SingleHitPulseObstacle3,
			output logic SingleHitPulseSpecial,
			output logic SingleHitPulseAnyObstacle
			// critical code, generating A single pulse in a frame 
);


assign collision_Brackets = (ball_DR && brackets_DR) || (ball_DR && cannon_DR) ;

assign collision_MovingObstacle = (ball_DR && movingObstacle_DR);
					
assign collision_Wormhole1 = (ball_DR && wormhole1_DR);

assign collision_Wormhole2 = (ball_DR && wormhole2_DR);

assign collision_Obstacle1 = (ball_DR && obtacle1_DR);

assign collision_Obstacle2 = (ball_DR && obtacle2_DR);

assign collision_Obstacle3 = (ball_DR && obtacle3_DR);

assign collision_Obstacles123 = ((ball_DR && obtacle3_DR) || (ball_DR && obtacle2_DR) || (ball_DR && obtacle1_DR));

assign collision_Bumper = (ball_DR && bumper_DR);

assign collision_LeftFlipper = (ball_DR && leftFlipper_DR);

assign collision_RightFlipper = (ball_DR && rightFlipper_DR); 

assign collision = (collision_Brackets || collision_MovingObstacle || collision_Wormhole1 || collision_Wormhole2
						 || collision_Obstacle1 || collision_Obstacle2 || collision_Obstacle3                   
						 || collision_Bumper || collision_LeftFlipper || collision_RightFlipper);    					
					
logic flag; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulseObstacle1 <= 1'b0;
		SingleHitPulseObstacle3 <= 1'b0;
		SingleHitPulseSpecial <= 1'b0; 
		SingleHitPulseAnyObstacle <= 1'b0;
		SingleHitPulseObstacle2 <= 1'b0;
	end 
	
	else begin 
		SingleHitPulseObstacle1 <= 1'b0;
		SingleHitPulseObstacle3 <= 1'b0;
		SingleHitPulseSpecial <= 1'b0;  // default 
		SingleHitPulseAnyObstacle <= 1'b0;
		SingleHitPulseObstacle2 <= 1'b0;
		
		if(startOfFrame) begin
			flag <= 1'b0 ; // reset for next time 
		end	
		
		if ((collision_Obstacle1 || collision_Obstacle2 || collision_Obstacle3) && (flag == 1'b0)) begin 
			flag	<= 1'b1; // to enter only once 
			SingleHitPulseAnyObstacle <= 1'b1;
		end
		
		if ((collision_Obstacle1) && (flag == 1'b0)) begin 
			flag	<= 1'b1; // to enter only once 
			SingleHitPulseObstacle1 <= 1'b1; 
		end 
		
		if ((collision_Obstacle2) && (flag == 1'b0)) begin 
			flag	<= 1'b1; // to enter only once 
			SingleHitPulseObstacle2 <= 1'b1; 
		end 
		
		if ((collision_Obstacle3) && (flag == 1'b0)) begin 
				flag	<= 1'b1; // to enter only once 
				SingleHitPulseObstacle3 <= 1'b1; 
		end 
		
		if ((collision_MovingObstacle) && (flag == 1'b0)) begin 
			flag	<= 1'b1; // to enter only once 
			SingleHitPulseSpecial <= 1'b1;
		end
	end 
end

endmodule
