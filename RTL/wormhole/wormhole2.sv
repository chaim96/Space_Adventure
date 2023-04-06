//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2021 

module	wormhole2	(	
 					input		logic	clk,
					input		logic	resetN,
					input 	logic signed	[10:0] pixelX,// current VGA pixel 
					input 	logic signed	[10:0] pixelY,
					input 	logic signed	[10:0] topLeftX_Original, 
					input 	logic	signed [10:0] topLeftY_Original,   
					input 	logic signed	[10:0] topLeftX_Cheat,
					input 	logic	signed [10:0] topLeftY_Cheat,
					input		logic wormholeCheat,
					
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,
					output	logic	drawingRequest, // indicates pixel inside the bracket
					output	logic	[7:0]	 RGBout //optional color output for mux 
);

parameter  int OBJECT_WIDTH_X = 32;
parameter  int OBJECT_HEIGHT_Y = 32;
parameter  logic [7:0] OBJECT_COLOR = 8'h5b ; 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 

int rightX; //coordinates of the sides  
int bottomY;
logic insideBracket; 
logic signed [10:0] topLeftX; 
logic	signed [10:0] topLeftY; 

//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries
assign rightX	= (topLeftX + OBJECT_WIDTH_X);
assign bottomY	= (topLeftY + OBJECT_HEIGHT_Y);
assign	insideBracket  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < rightX) // math is made with SIGNED variables  
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY) )  ; // as the top left position can be negative
		


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
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
	
 
		if (insideBracket) // test if it is inside the rectangle 
		begin 
			RGBout  <= OBJECT_COLOR ;	// colors table 
			drawingRequest <= 1'b1 ;
			offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner allways a positive number 
			offsetY	<= (pixelY - topLeftY);
		end		
	end
end 


always_comb begin

	if (wormholeCheat) begin
		topLeftX = topLeftX_Cheat;
		topLeftY = topLeftY_Cheat;
	end

	else begin
		topLeftX = topLeftX_Original;
		topLeftY = topLeftY_Original;
	end
end

endmodule 