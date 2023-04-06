// created by Roee Dror & Chaim Javaheri, students of the Electrical & Computers Engineering faculty at the Technion.
// created as part of the final project in Lab A 1, March-May 2022.


module right_flipper_move (
				input		logic	clk,
				input		logic	resetN,
				input    logic SOF,
				input		logic move,
				
				output	logic	[10:0]X1, // indicates pixel inside the bracket
				output	logic	[10:0]Y1,//optional color output for mux
				output	logic [6:0] alpha_out
);

parameter int  Xc = 455 ;
parameter int  Yc	= 400 ;	
parameter int R = 80;
parameter int SHIFT_VALUE = 10 ;
parameter int INITIAL_ALPHA = 52 ;
parameter int FINAL_ALPHA = 0 ;
parameter int ALPHA_SPEED = 4;


logic [6:0] alpha; 

int cos[0:90] = 
'{ 

1024,
1024,
1023,
1023,
1022,
1020,
1018,
1016,
1014,
1011,
1008,
1005,
1002,
998,
994,
989,
984,
979,
974,
968,
962,
956,
949,
943,
935,
928,
920,
912,
904,
896,
887,
878,
868,
859,
849,
839,
828,
818,
807,
796,
784,
773,
761,
749,
737,
724,
711,
698,
685,
672,
658,
644,
630,
616,
602,
587,
573,
558,
543,
527,
512,
496,
481,
465,
449,
433,
416,
400,
384,
367,
350,
333,
316,
299,
282,
265,
248,
230,
213,
195,
178,
160,
143,
125,
107,
89,
71,
54,
36,
18,
0
};

int sin[0:90] =
'{
0,
18,
36,
54,
71,
89,
107,
125,
143,
160,
178,
195,
213,
230,
248,
265,
282,
299,
316,
333,
350,
367,
384,
400,
416,
433,
449,
465,
481,
496,
512,
527,
543,
558,
573,
587,
602,
616,
630,
644,
658,
672,
685,
698,
711,
724,
737,
749,
761,
773,
784,
796,
807,
818,
828,
839,
849,
859,
868,
878,
887,
896,
904,
912,
920,
928,
935,
943,
949,
956,
962,
968,
974,
979,
984,
989,
994,
998,
1002,
1005,
1008,
1011,
1014,
1016,
1018,
1020,
1022,
1023,
1023,
1024,
1024
}; 


always_ff@(posedge clk or negedge resetN)
begin

	if(!resetN) begin 
		alpha <= INITIAL_ALPHA ;		
	end 
	else begin 
	
	 if (SOF) begin
		if (move &&  (alpha == FINAL_ALPHA)) begin
			alpha <= FINAL_ALPHA;
		end 

		if (move && ((alpha > FINAL_ALPHA) && (alpha <= INITIAL_ALPHA))) begin
			alpha <= alpha - ALPHA_SPEED;
		end
		 if ((!move) && ((alpha >= FINAL_ALPHA) && (alpha < INITIAL_ALPHA))) begin
			alpha <= alpha + ALPHA_SPEED;
		end

	end
 end 	
	

end

assign X1 = Xc - ((R*cos[alpha]) / 1024 );
assign Y1 = Yc + ((R*sin[alpha]) / 1024 );
assign alpha_out = alpha; 			


endmodule					