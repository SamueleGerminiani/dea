
`define SAC(SIGNAL,MASK) \
`ifdef SIGNAL  \
    {SIGNAL & MASK}\
`else\
    SIGNAL\
`endif

module sobel( clk, p0, p1, p2, p3, p5, p6, p7, p8, out);

	input  [8:0] p0,p1,p2,p3,p5,p6,p7,p8;	
	input clk;

	output [7:0] out;					

	wire [8:0] p2_p0, p8_p6, p0_p6, p2_p8, p5_p3, p1_p7, center_rm, center_tm;
	wire [9:0] center_1, center_2, center_3, center_4, gx_temp, gy_temp;

	wire or_out, add_out_1, add_out_2, add_out_3, add_out_4;
	wire [10:0] gx , gy, gx_comp, gy_comp;
	wire [10:0] gx_2s_comp, gy_2s_comp;   
				 	
	wire [10:0] abs_gx,abs_gy;	
	wire [10:0] sum;
	wire [10:0] _sum;


	reg [10:0] gx_reg, gy_reg;		
	wire [10:0] _gx_reg, _gy_reg;		

	//Horizontal Gradient
	sobel_add_nb #(9) S0 (.a(p2),.b(p0),.ans_out(p2_p0),.subtract(1'b1),.cout()); 		//9-bit Subtractor
	sobel_add_nb #(9) S1 (.a(p5),.b(p3),.ans_out(p5_p3),.subtract(1'b1),.cout()); 		//9-bit Subtractor
	assign center_1 = `SAC(p5_p3,`MASK_p5_p3) << 1;
	sobel_add_nb #(9) S2 (.a(p8),.b(p6),.ans_out(p8_p6),.subtract(1'b1),.cout()); 		//9-bit Subtractor
	sobel_add_nb #(9) S3 (.a(`SAC(p2_p0,`MASK_p2_p0)),.b(`SAC(p8_p6,`MASK_p8_p6)),.ans_out(center_rm),.subtract(1'b0),.cout(add_out_1)); 	//9-bit Adder
	assign center_2 = {`SAC(add_out_1,`MASK_add_out_1),`SAC(center_rm,`MASK_center_rm)};
	sobel_add_nb #(10) S4 (.a(`SAC(center_1,`MASK_center_1)),.b(`SAC(center_2,`MASK_center_2)),.ans_out(gx_temp),.subtract(1'b0),.cout(add_out_2)); 	//10-bit Adder
	assign gx = {`SAC(add_out_2,`MASK_add_out_2),`SAC(gx_temp,`MASK_gx_temp)};


	//Vertical Gradient
	sobel_add_nb #(9) S5 (.a(p0),.b(p6),.ans_out(p0_p6),.subtract(1'b1),.cout()); 		//9-bit Subtractor
	sobel_add_nb #(9) S6 (.a(p1),.b(p7),.ans_out(p1_p7),.subtract(1'b1),.cout()); 		//9-bit Subtractor
	assign center_3 = `SAC(p1_p7,`MASK_p1_p7) << 1; 
	sobel_add_nb #(9) S7 (.a(p2),.b(p8),.ans_out(p2_p8),.subtract(1'b1),.cout()); 		//9-bit Subtractor
	sobel_add_nb #(9) S8 (.a(`SAC(p2_p8,`MASK_p2_p8)),.b(`SAC(p0_p6,`MASK_p0_p6)),.ans_out(center_tm),.subtract(1'b0),.cout(add_out_3));  	//9-bit Adder
	assign center_4 = {`SAC(add_out_3,`MASK_add_out_3),`SAC(center_tm,`MASK_center_tm)};
	sobel_add_nb #(10) S9 (.a(`SAC(center_3,`MASK_center_3)),.b(`SAC(center_4,`MASK_center_4)),.ans_out(gy_temp),.subtract(1'b0),.cout(add_out_4));  //10-bit Adder
	assign gy = {`SAC(add_out_4,`MASK_add_out_4),`SAC(gy_temp,`MASK_gy_temp)};

	
	always @(posedge clk)
	begin
		gx_reg <= `SAC(gx,`MASK_gx);
		gy_reg <= `SAC(gy,`MASK_gy);
	end

    assign _gx_reg=`SAC(gx_reg,`MASK_gx_reg);
    assign _gy_reg=`SAC(gy_reg,`MASK_gy_reg);


	not_11b N0 (_gx_reg,gx_comp);
	not_11b N1 (_gy_reg,gy_comp);
	
	sobel_add_nb #(11) S10 (.a(11'b1), .b(`SAC(gx_comp,`MASK_gx_comp)), .ans_out(gx_2s_comp), .subtract(1'b0), .cout());	//11-bit Adder
	sobel_add_nb #(11) S11 (.a(11'b1), .b(`SAC(gy_comp,`MASK_gy_comp)), .ans_out(gy_2s_comp), .subtract(1'b0), .cout());	//11-bit Adder

	mux_11b M0 (_gx_reg, `SAC(gx_2s_comp,`MASK_gx_2s_comp), _gx_reg[8], abs_gx);
	mux_11b M1 (_gy_reg, `SAC(gy_2s_comp,`MASK_gy_2s_comp), _gy_reg[8], abs_gy);

	sobel_add_nb #(11) S12 (.a(`SAC(abs_gx,`MASK_abs_gx)), .b(`SAC(abs_gy,`MASK_abs_gy)), .ans_out(sum), .subtract(1'b0), .cout());	//11-bit Adder

    assign _sum=`SAC(sum,`MASK_sum);
	//or_4b O0 (sum[8], sum[9], sum[10], sum[11], or_out);
	mux_8b M2 (_sum[7:0], 8'hff, _sum[8], out); 

endmodule
