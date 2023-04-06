

module	objects_mux	(	
 	
					input	logic	clk,
					input	logic	resetN,
					
					input	logic highScoreDR,
					input logic [7:0] highScoreRGB,
					input	logic lowScoreDR,
					input	logic [7:0] lowScoreRGB,

					input	logic	ballDrawingRequest, 
					input	logic	[7:0] ballRGB, 
					
					input logic S1ballDrawingRequest,
					input logic [7:0] S1ballRGB,
				
					input logic S2ballDrawingRequest,
					input logic [7:0] S2ballRGB,
					
					input logic bumperDrawingRequest,
					input logic [7:0]bumperRGB,
			  
					input logic movingObstacleDrawingRequest,
					input	logic [7:0] movingObstacleRGB,
					
					input logic wormhole1ObstacleDrawingRequest,
					input	logic [7:0] wormhole1RGB,
					input logic wormhole2ObstacleDrawingRequest,
					input	logic [7:0] wormhole2RGB,
					
					input	logic obstacle1DrawingRequest,
					input logic [7:0] obstacle1RGB,
					input	logic obstacle2DrawingRequest,
					input logic [7:0] obstacle2RGB,
					input	logic obstacle3DrawingRequest,
					input logic [7:0] obstacle3RGB,
					
					input logic LeftFlipperDrawingRequest,
					input	logic [7:0] LeftFlipperRGB,
					input logic rightFlipperDrawingRequest,
					input	logic [7:0] rightFlipperRGB,
					
					
					
					input logic  openMessege_DR,
					input logic [7:0] openMessegeRGB,
					input logic  gameOverMessege_DR,
					input logic [7:0] gameOverMessegeRGB,
					input logic  winMessege_DR,
					input logic [7:0] winMessegeRGB,
					
					input logic cannon_DR, 
					input logic [7:0] cannonRGB,
	
					input	logic	[7:0] backGroundRGB, 
			  
				   output logic [7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
		if (openMessege_DR == 1'b1) begin 
			RGBOut <= openMessegeRGB ;
		end
		
		else begin
			if(gameOverMessege_DR == 1'b1) begin 
			RGBOut <= gameOverMessegeRGB ;
			end
			
			else begin
				if ( winMessege_DR == 1'b1) begin 
					RGBOut <= winMessegeRGB ;
				end
				
				else begin
					if (highScoreDR == 1'b1 ) begin  
						RGBOut <= highScoreRGB;  
					end
					
					else begin
						if (lowScoreDR == 1'b1 ) begin  
							RGBOut <= lowScoreRGB;
						end
						
						else begin
							if (ballDrawingRequest == 1'b1 ) begin			
								RGBOut <= ballRGB;   
							end
							
							else begin
								if (S1ballDrawingRequest == 1'b1 ) begin
									RGBOut <= S1ballRGB;
								end
								
								else begin
									if (S2ballDrawingRequest == 1'b1 ) begin
										RGBOut <= S2ballRGB;
									end
						
									else begin
										if (bumperDrawingRequest == 1'b1) begin
											RGBOut <= bumperRGB;
										end	 
							 
										else begin
											if (movingObstacleDrawingRequest == 1'b1) begin
												RGBOut <= movingObstacleRGB;
											end
							 
											else begin
												if (wormhole1ObstacleDrawingRequest == 1'b1) begin
													RGBOut <= wormhole1RGB;
												end
												
												else begin
													if (wormhole2ObstacleDrawingRequest == 1'b1) begin
														RGBOut <= wormhole2RGB;
													end
												
													else begin
														if (obstacle1DrawingRequest == 1'b1) begin
															RGBOut <= obstacle1RGB;
														end
														
														else begin
															if (obstacle2DrawingRequest == 1'b1) begin
																RGBOut <= obstacle2RGB;
															end
															
															else begin
																if (obstacle3DrawingRequest == 1'b1) begin
																	RGBOut <= obstacle3RGB;
																end
																
																else begin
																	if (LeftFlipperDrawingRequest == 1'b1) begin
																		RGBOut <= LeftFlipperRGB;
																	end
																	
																	else begin
																		if (rightFlipperDrawingRequest == 1'b1) begin
																			RGBOut <= rightFlipperRGB;
																		end
																		
																		else begin 
																			if (cannon_DR == 1'b1) begin
																				RGBOut <= cannonRGB ;
																			end
																		
																			else begin								
																				RGBOut <= backGroundRGB ; // last priority
																			end
																		end	
																	end
																end
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end	
					end		
				end			
			end
		end	
	end
end
endmodule


