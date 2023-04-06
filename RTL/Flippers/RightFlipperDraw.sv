// created by Roee Dror & Chaim Javaheri, students of the Electrical & Computers Engineering faculty at the Technion.
// created as part of the final project in Lab A 1, March-May 2022.


module	RightFlipperDraw	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic signed	[10:0] pixelX,// current VGA pixel 
					input 	logic signed	[10:0] pixelY,
					input 	logic signed	[10:0] X1, //turning edges of flipper  
					input 	logic	signed   [10:0] Y1,  
					
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,
					output	logic	drawingRequest, // indicates pixel inside the bracket
					output	logic	[7:0]	 RGBout 
);


parameter  logic [7:0] OBJECT_COLOR = 8'h5b ;
parameter int Xc = 455 ; //the fixed edge of the flipper
parameter int Yc = 400  ;

parameter int THICKNESS = 5; // thickness of flipper

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
localparam logic [2:0] DARK_COLOR = 3'b111 ;// bitmap of a dark color
 

logic insideBracket ; 
 

//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries

//calculating wether the object is inside the intended area of the flipper					
assign	insideBracket  = ( ((pixelY-Yc)*(X1-Xc) >= ((Y1-Yc)*(pixelX-Xc) + (X1-Xc)*THICKNESS))
										&& ((pixelY-Yc)*(X1-Xc) <= ((Y1-Yc)*(pixelX-Xc) - (X1-Xc)*THICKNESS))
										&& (pixelY  >= Yc -THICKNESS) &&  (pixelY <= Y1 + THICKNESS)
										&&	(pixelX  >= X1 - THICKNESS) && (pixelX <= Xc + THICKNESS) );



//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout			<=	8'b0;
		drawingRequest	<=	1'b0;
	end
	else begin 
	    
		if (insideBracket) // test if it is inside the rectangle 
		begin 
			RGBout  <= OBJECT_COLOR ;	// colors table 
			drawingRequest <= 1'b1 ;
			offsetX	<= (pixelX - Xc); //offsets are calculated for optional future use
			offsetY	<= (pixelY - Yc);
		end
	
		else begin
			RGBout <= TRANSPARENT_ENCODING ; // so it will not be displayed 
			drawingRequest <= 1'b0 ;// transparent color 
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
		end
	end
end 
endmodule 