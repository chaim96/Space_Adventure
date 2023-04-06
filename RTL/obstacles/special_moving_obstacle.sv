//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2021 


module	special_moving_obstacle	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic signed [10:0] pixelX,// current VGA pixel 
					input logic signed [10:0] pixelY,
					
					
					output logic [10:0] offsetX,
					output logic [10:0] offsetY,
					output logic drawingRequest, // indicates pixel inside the bracket
					output logic [7:0] RGBout //optional color output for mux 		
);


// a module used to generate the object trajectory.  

parameter int INITIAL_X = 300;
parameter int INITIAL_Y = 300;
parameter int INITIAL_X_SPEED = 120;
const int FIXED_POINT_MULTIPLIER	=	64;

parameter  int OBJECT_WIDTH_X = 32;
parameter  int OBJECT_HEIGHT_Y = 16;

int topLeftX = INITIAL_X * FIXED_POINT_MULTIPLIER; //coordinates of the object's corners
int topLeftY = INITIAL_Y * FIXED_POINT_MULTIPLIER;
int pixelX_fixed;
int pixelY_fixed;
int rightX;   
int bottomY;
int Xspeed;
logic insideBracket; 
parameter  logic [7:0] OBJECT_COLOR = 8'h5b;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 

assign rightX	= (topLeftX + (OBJECT_WIDTH_X * FIXED_POINT_MULTIPLIER));
assign bottomY	= (topLeftY + (OBJECT_HEIGHT_Y * FIXED_POINT_MULTIPLIER));
assign	insideBracket  = 	 ( (pixelX_fixed  >= topLeftX) &&  (pixelX_fixed < rightX) // math is made with SIGNED variables  
						   && (pixelY_fixed  >= topLeftY) &&  (pixelY_fixed < bottomY) )  ; // as the top left position can be negative

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation of X Axis speed using and position calculate regarding X_direction key or colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		Xspeed	<= INITIAL_X_SPEED;
		topLeftX	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		topLeftY <= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end
	else begin
	
			if (insideBracket) begin 
					RGBout <= OBJECT_COLOR ; 
					drawingRequest <= 1'b1 ;
					offsetX <= (pixelX_fixed - topLeftX) / FIXED_POINT_MULTIPLIER;
					offsetY <= (pixelY_fixed - topLeftY) / FIXED_POINT_MULTIPLIER;
			end
			
			else begin
					RGBout <= TRANSPARENT_ENCODING ; // so it will not be displayed 
					drawingRequest <= 1'b0 ;// transparent color 
					offsetX <= 0;
					offsetY <= 0;
			end	
			
			// collisions with the sides 			
			if (topLeftX <= (7 * FIXED_POINT_MULTIPLIER)) begin  
					if (Xspeed < 0 ) // while moving left
								Xspeed <= -Xspeed ; // positive move right 
			end
			
			if (rightX >= (633 * FIXED_POINT_MULTIPLIER)) begin  // hit right border of brick  
					if (Xspeed > 0 ) //  while moving right
								Xspeed <= -Xspeed  ;  // negative move left    
			end	
		   	
			if (startOfFrame == 1'b1) begin
					topLeftX  <= topLeftX + Xspeed;				
			end
	end
end   


endmodule 