//-- feb 2021 add all colors square 
// (c) Technion IIT, Department of Electrical Engineering 2021


module	back_ground_draw	(	

					input	logic	clk,
					input	logic	resetN,
					input logic putStar,
					input 	logic	[10:0]	pixelX,
					input 	logic	[10:0]	pixelY,

					output	logic	[7:0]	BG_RGB,
					output	logic		boardersDrawReq
);

parameter int	xFrameSize = 635;
parameter int	yFrameSize = 400;
const int	bracketOffset =	32;
const int   COLOR_MARTIX_SIZE  = 16*8 ; // 128 

logic [2:0] redBits;
logic [2:0] greenBits;
logic [1:0] blueBits;
logic [10:0] shift_pixelX;


localparam logic [2:0] WHITE = 3'b111 ;// bitmap of a dark color
localparam logic [2:0] BLACK = 3'b000 ;// bitmap of a light color

 
localparam  int RED_TOP_Y  = 156 ;
localparam  int RED_LEFT_X  = 256 ;
localparam  int GREEN_RIGHT_X  = 32 ;
localparam  int BLUE_BOTTOM_Y  = 300 ;
localparam  int BLUE_RIGHT_X  = 200 ;
 
parameter  logic [10:0] COLOR_MATRIX_TOP_Y  = 100 ; 
parameter  logic [10:0] COLOR_MATRIX_LEFT_X = 100 ;

 

// this is a block to generate the background 
//it has four sub modules : 

	// 1. draw the yellow borders
	// 2. draw four lines with "bracketOffset" offset from the border 
	// 3.  draw red rectangle at the bottom right,  green on the left, and blue on top left 
	// 4. draw a matrix of 16*16 rectangles with all the colors, each rectsangle 8*8 pixels  	

 
 
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
				redBits <= BLACK;	
				greenBits <= BLACK;	
				blueBits <= BLACK; 	 
	end 
	else begin

	// defaults 
		greenBits <= BLACK; 
		redBits <= BLACK;
		blueBits <= BLACK;
		boardersDrawReq <= 1'b0; 

		
		if ( pixelX == 1 ||
			  pixelY == bracketOffset ||
			  pixelX == xFrameSize  || 
		    ((pixelY == (yFrameSize)) && ((pixelX < 185) || (pixelX > 455))) ) begin 
					redBits <= WHITE;	
					greenBits <= WHITE;	
					blueBits <= WHITE;
					boardersDrawReq <= 1'b1; // pulse if drawing the boarders 
		end
		
//		else begin
//			if (putStar) begin
//					redBits <= WHITE;	
//					greenBits <= WHITE;	
//					blueBits <= WHITE;
//			end
//		end
		
	BG_RGB =  {redBits , greenBits , blueBits} ; //collect color nibbles to an 8 bit word 
	
	end		
end 
endmodule

