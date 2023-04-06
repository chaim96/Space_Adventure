//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2021 


module	bumper	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic signed	[10:0] pixelX,// current VGA pixel 
					input 	logic signed	[10:0] pixelY,
					//input 	logic signed	[10:0] topLeftX, //position on the screen 
					//input 	logic	signed [10:0] topLeftY,   // can be negative , if the object is partliy outside 
					
					//output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					//output 	logic	[10:0] offsetY,
					output	logic	drawingRequest, // indicates pixel inside the bracket
					output	logic	[7:0]	 RGBout //optional color output for mux 
);

//parameter  int OBJECT_WIDTH_X = 100;
//parameter  int OBJECT_HEIGHT_Y = 100;
parameter  logic [7:0] OBJECT_COLOR = 8'h5b ;
parameter  logic [7:0] WHITE_COLOR = 8'hFFFFFF ;

parameter logic [10:0] X1 = 11'd595 ;
parameter logic [10:0] Y1 = 11'd32  ;
parameter logic [10:0] X2 = 11'd635 ;
parameter logic [10:0] Y2 = 11'd72  ;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 
//int rightX ; //coordinates of the sides  
//int bottomY ;
logic insideBracket ; 
 

//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries
//assign rightX	= (topLeftX + OBJECT_WIDTH_X);
//assign bottomY	= (topLeftY + OBJECT_HEIGHT_Y);
assign	insideBracket  = 	 (((pixelY-Y1)*(X1-X2) >= (Y1-Y2)*(pixelX-X1)) // math is made with SIGNED variables  
						   && (pixelY  > Y1) &&  (pixelY < Y2) 
							&&	(pixelX  > X1) &&  (pixelX < X2)) ; // as the top left position can be negative
		


//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout			<=	8'b0;
		drawingRequest	<=	1'b0;
	end
	else begin 
		// DEFUALT outputs
	      RGBout <= TRANSPARENT_ENCODING ; // so it will not be displayed 
			drawingRequest <= 1'b0 ;// transparent color 
//			offsetX	<= 0; //no offset
//			offsetY	<= 0; //no offset

		if (insideBracket) // test if it is inside the rectangle 
		begin 
			RGBout  <= WHITE_COLOR ;	// colors table 
			drawingRequest <= 1'b1 ;
//			offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner allways a positive number 
//			offsetY	<= (pixelY - topLeftY);
		end 
		

		
	end
end 
endmodule 